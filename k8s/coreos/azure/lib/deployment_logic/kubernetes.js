
var _ = require('underscore');
_.mixin(require('underscore.string').exports());

var util = require('../util.js');
var cloud_config = require('../cloud_config.js');


etcd_initial_cluster_conf_self = function (conf) {
  var port = '2380';

  var data = {
    nodes: _(conf.nodes.etcd).times(function (n) {
      var host = util.hostname(n, 'etcd');
      return [host, [host, port].join(':')].join('=http://');
    }),
  };

  return {
    'name': 'etcd2.service',
    'drop-ins': [{
      'name': '50-etcd-initial-cluster.conf',
      'content': _.template("[Service]\nEnvironment=ETCD_INITIAL_CLUSTER=<%= nodes.join(',') %>\n")(data),
    }],
  };
};

etcd_initial_cluster_conf_kube = function (conf) {
  var port = '4001';

  var data = {
    nodes: _(conf.nodes.etcd).times(function (n) {
      var host = util.hostname(n, 'etcd');
      return 'http://' + [host, port].join(':');
    }),
  };

  return {
    'name': 'kube-apiserver.service',
    'drop-ins': [{
      'name': '50-etcd-initial-cluster.conf',
      'content': _.template("[Service]\nEnvironment=ETCD_SERVERS=--etcd-servers=<%= nodes.join(',') %>\n")(data),
    }],
  };
};

exports.create_cloud_config = function (type) {
  var input_file = './cloud_config_templates/node.yaml';
  var output_file = util.join_output_file_path('node', 'generated.yml');
  if (type === 'master'){
    input_file = './cloud_config_templates/master.yaml';
    output_file = util.join_output_file_path('master', 'generated.yml');
  }
  return cloud_config.process_template(input_file, output_file, function(data) {
    return data;
  });
};
