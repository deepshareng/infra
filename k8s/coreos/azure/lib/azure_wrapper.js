var _ = require('underscore');

var fs = require('fs');
var cp = require('child_process');

var yaml = require('js-yaml');

var openssl = require('openssl-wrapper');

var clr = require('colors');
var inspect = require('util').inspect;

var util = require('./util.js');

var coreos_image_ids = {};

var conf = {};

var service_name = "";
var index = -1;

var hosts = {
  collection: [],
  ssh_port_counter: 2200,
};

var task_queue = [];

exports.run_task_queue = function (dummy) {
  var tasks = {
    todo: task_queue,
    done: [],
  };

  var pop_task = function() {
    console.log(clr.yellow('azure_wrapper/task:'), clr.grey(inspect(tasks)));
    var ret = {};
    ret.current = tasks.todo.shift();
    ret.remaining = tasks.todo.length;
    return ret;
  };

  (function iter (task) {
    if (task.current === undefined) {
      if (conf.destroying === undefined) {
        // do NOT change the order!!!
        // step 1
        save_state();
        // step 2
        create_ssh_conf();
      }
      return;
    } else {
      if (task.current.length !== 0) {
        console.log(clr.yellow('azure_wrapper/exec:'), clr.blue(inspect(task.current)));
        //iter(pop_task());
        cp.fork('node_modules/azure-cli/bin/azure', task.current)
          .on('exit', function (code, signal) {
            tasks.done.push({
              code: code,
              signal: signal,
              what: task.current.join(' '),
              remaining: task.remaining,
            });
            if (code !== 0 && conf.destroying === undefined) {
              console.log(clr.red('azure_wrapper/fail: Exiting due to an error.'));
              save_state();
              console.log(clr.cyan('azure_wrapper/info: You probably want to destroy and re-run.'));
              process.abort();
            } else {
              iter(pop_task());
            }
        });
      } else {
        iter(pop_task());
      }
    }
  })(pop_task());
};

var create_ssh_conf = function () {
  //var file_name = util.join_output_file_path(conf.name, 'ssh_conf');
  file_name = conf.resources.conf_file;
  var ssh_conf = [];
  var conf_hosts = [];
  for (var i=0; i<conf.services.length; i++){
    var ssh_conf_head = [
      "Host " + conf.services[i].name + "*",
      "\tHostname " + conf.services[i].name + (process.env['AZ_CHINA_CLOUD']?".chinacloudapp.cn":".cloudapp.net"),
      "\tUser core",
      "\tCompression yes",
      "\tLogLevel FATAL",
      "\tStrictHostKeyChecking no",
      "\tUserKnownHostsFile /dev/null",
      "\tIdentitiesOnly yes",
      "\tIdentityFile " + conf.resources['ssh_key']['key'],
      "\n",
    ];
    ssh_conf = ssh_conf.concat(ssh_conf_head);
    if (conf.services[i].hosts != null && conf.services[i].hosts.length > 0){
      conf_hosts = conf_hosts.concat(_.map(conf.services[i].hosts, function (host) {
        return _.template("Host <%= name %>\n\tPort <%= port %>\n")(host);
      }));
    };
  };
  ssh_conf = ssh_conf.concat(conf_hosts);
  //console.log(clr.yellow(ssh_conf.concat(conf_hosts).join('\n')));
  
  fs.writeFileSync(file_name, ssh_conf.join('\n'));

  console.log(clr.yellow('azure_wrapper/info:'), clr.green('Saved SSH config, you can use it like so: `ssh -F ', file_name, '<hostname>`'));
  console.log(clr.yellow('azure_wrapper/info:'), clr.green('The hosts in this deployment are:\n'), conf_hosts.join('\n'));
};

var save_state = function () {
  //var file_name = util.join_output_file_path(conf.name, 'deployment.yml');
  file_name = conf.resources.deployment_file;
  try {
    conf.services[index].hosts = hosts.collection;
    fs.writeFileSync(file_name, yaml.safeDump(conf));
    console.log(clr.yellow('azure_wrapper/info: Saved state into `%s`'), file_name);
  } catch (e) {
    console.log(clr.red(e));
  }
};

var load_state = function (file_name) {
  try {
    conf = yaml.safeLoad(fs.readFileSync(file_name, 'utf8'));
    console.log(clr.yellow('azure_wrapper/info: Loaded state from `%s`'), file_name);
    return conf;
  } catch (e) {
    console.log(clr.red(e));
  }
};

var get_location = function () {
  return '--location=' + conf.resources.vnet.location;
}

var get_vm_size = function (name_prefix) {
  if (process.env['AZ_VM_SIZE'] && name_prefix !== 'master') {
    return '--vm-size=' + process.env['AZ_VM_SIZE'];
  } else {
    return '--vm-size=Small';
  }
}

exports.queue_endpoints = function (name_prefix) {
  var x = conf.services[index].nodes[name_prefix];
  // create endpoint for master hosts
  if (name_prefix === 'master'){
    var vm_create_endpoint_base_args = [
      'vm', 'endpoint', 'create',
      '--dns-name=' + service_name + (process.env['AZ_CHINA_CLOUD']?".chinacloudapp.cn":".cloudapp.net"),
    ];
    task_queue = task_queue.concat(_(x).times(function (n) {
      if (conf.resizing && n < conf.old_size) {
        return [];
      } else {
        return vm_create_endpoint_base_args.concat([
          '--name=apiserver', '--protocol=tcp', '--load-balanced-set-name=apiserver',
          service_name + '-' + util.hostname(n, name_prefix), '6443', '443',
        ]);
      }
    }));
  };
};

exports.queue_endpoints_ilb = function (name_prefix) {
  var x = conf.services[index].nodes[name_prefix];
  // create endpoint for master hosts
  if (name_prefix === 'master'){
    var vm_create_endpoint_base_args = [
      'vm', 'endpoint', 'create',
      '--dns-name=' + service_name + (process.env['AZ_CHINA_CLOUD']?".chinacloudapp.cn":".cloudapp.net"),
    ];
    task_queue = task_queue.concat(_(x).times(function (n) {
      if (conf.resizing && n < conf.old_size) {
        return [];
      } else {
        return vm_create_endpoint_base_args.concat([
          '--name=apiserver-ilb', '--protocol=tcp', '--load-balanced-set-name=apiserver-ilb',
          '--internal-load-balancer-name=ilb', service_name + '-' + util.hostname(n, name_prefix), '443',
        ]);
      }
    }));
  };
};

exports.queue_init = function () {
  // create azure storage account
  //task_queue.push([
  //  'storage', 'account', 'create',
  //  get_location(), '--type=GRS', 
  //  conf.resources.storage_account,
  //]);
  // create vnet
  task_queue.push([
    'network', 'vnet', 'create',
    '--address-space=' + conf.resources.vnet.address_space, '--cidr=' + conf.resources.vnet.cidr, 
    get_location(), 
    '--subnet-start-ip=' + conf.resources.vnet.subnet[0].start_ip, 
    '--subnet-name=' + conf.resources.vnet.subnet[0].name,
    '--subnet-cidr=' + conf.resources.vnet.subnet[0].cidr,
    conf.resources.vnet.name,
  ]);
  // add subnet to vnet
  for (var i=1; i<conf.resources.vnet.subnet.length; i++){
    task_queue.push([
      'network', 'vnet', 'subnet', 'create',
      '--address-prefix=' + conf.resources.vnet.subnet[i].start_ip + '/' + conf.resources.vnet.subnet[i].cidr,
      conf.resources.vnet.name, conf.resources.vnet.subnet[i].name, 
    ]);
  }
  // create cloud services
  for (var i=0; i<conf.services.length; i++){
    task_queue.push([
      'service', 'create', get_location(), 
      conf.services[i].name, 
    ]);
  }
  // create ssh key
  create_ssh_key();
}

var create_ssh_key = function () {
  var opts = {
    x509: true,
    nodes: true,
    newkey: 'rsa:2048',
    subj: '/O=Singulariti/L=Beijing/C=CN/CN=Singulariti',
    keyout: conf.resources.ssh_key.key,
    out: conf.resources.ssh_key.pem,
  };
  openssl.exec('req', opts, function (err, buffer) {
    if (err) console.log(clr.red(err));
    fs.chmod(opts.keyout, '0600', function (err) {
      if (err) console.log(clr.red(err));
    });
  });
}

exports.queue_internalloadbalancer = function (name, node_type) {
  if (node_type === 'master'){
    task_queue.push([
      'service', 'internal-load-balancer', 'add',
      '--subnet-name='+conf.services[index].subnet, '--static-virtualnetwork-ipaddress=172.18.100.100',
      name, 'ilb',
    ]);
  }
};

exports.queue_machines = function (name_prefix, coreos_update_channel, cloud_config_creator) {
  var x = conf.services[index].nodes[name_prefix];
  var vm_create_base_args = [
    'vm', 'create',
    get_vm_size(name_prefix),
    '--connect=' + service_name,
    '--virtual-network-name=' + conf.resources.vnet.name,
    '--no-ssh-password',
    '--ssh-cert=' + conf.resources['ssh_key']['pem'],
    '--subnet-names=' + conf.services[index].subnet,
    '--availability-set=' + service_name,
  ];

  if (process.env['AZ_CHINA_CLOUD'])  {
    coreos_image_ids = {
      'stable': 'coreos-cifs',
      'beta': '2b171e93f07c4903bcad35bda10acf22__CoreOS-Beta-723.3.0', // untested
      'alpha': '2b171e93f07c4903bcad35bda10acf22__CoreOS-Alpha-745.1.0' // untested
    };
  } else {
    coreos_image_ids = {
      'stable': '2b171e93f07c4903bcad35bda10acf22__CoreOS-Stable-899.15.0',
      'beta': '2b171e93f07c4903bcad35bda10acf22__CoreOS-Beta-723.3.0', // untested
      'alpha': '2b171e93f07c4903bcad35bda10acf22__CoreOS-Alpha-745.1.0' // untested
    };
  };
  var cloud_config = cloud_config_creator(name_prefix);

  var next_host = function (n) {
    hosts.ssh_port_counter += 1;
    var host = { name: util.hostname(n, service_name + '-' + name_prefix), 
      port: hosts.ssh_port_counter, }
    if (cloud_config instanceof Array) {
      host.cloud_config_file = cloud_config[n];
    } else {
      host.cloud_config_file = cloud_config;
    }
    hosts.collection.push(host);
    return _.map([
        "--vm-name=<%= name %>",
        "--ssh=<%= port %>",
        "--custom-data=<%= cloud_config_file %>",
    ], function (arg) { return _.template(arg)(host); });
  };

  //console.log(clr.red(service_name));
  task_queue = task_queue.concat(_(x).times(function (n) {
    if (conf.resizing && n < conf.old_size) {
      return [];
    } else {
      return vm_create_base_args.concat(next_host(n), [
        coreos_image_ids[coreos_update_channel], 'core',
      ]);
    }
  }));
  //console.log(clr.red(inspect(task_queue)));
};

exports.destroy_cluster = function (state_file) {
  load_state(state_file);
  //task_queue.push(['storage', 'account', 'delete', '--quiet', conf.resources['storage_account']]);
  for (var i=0; i<conf.services.length; i++){
    task_queue.push(['service', 'delete', '--quiet', conf.services[i].name]);
  }
  task_queue.push(['network', 'vnet', 'delete', '--quiet', conf.resources.vnet.name,]);

  exports.run_task_queue();
};

exports.load_state_for_resizing = function (state_file, service, node_type, new_nodes) {
  load_state(state_file);
  service_name = service;
  if (conf.services === undefined || !conf.services instanceof Array || conf.services.length === 0) {
    console.log(clr.red('azure_wrapper/fail: could not found service in config file.'));
    process.abort();
  }
  for (var i=0 ; i<conf.services.length; i++){
    if (conf.services[i].name === service){
      index = i;
      break;
    }
  }
  if (index < 0){
    console.log(clr.red('azure_wrapper/fail: could not found specified service in config file.'));
    process.abort();
  }
  conf.resizing = true;
  conf.old_size = conf.services[index].nodes[node_type];
  conf.old_state_file = state_file;
  conf.services[index].nodes[node_type] += new_nodes;
  hosts.collection = conf.services[index].hosts;
  hosts.ssh_port_counter += conf.services[index].hosts.length;
  process.env['AZURE_STORAGE_ACCOUNT'] = conf.resources['storage_account'];
  //console.log(clr.red(inspect(hosts)));
}
