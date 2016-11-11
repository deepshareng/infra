#!/usr/bin/env node

var azure = require('./lib/azure_wrapper.js');
var kube = require('./lib/deployment_logic/kubernetes.js');

azure.load_state_for_resizing(process.argv[2], process.argv[3], process.argv[4], parseInt(process.argv[5] || 1));

if (process.argv[6] !== undefined && parseInt(process.argv[6]) == 1){
  azure.run_task_queue([
  	azure.queue_init(),
    azure.queue_machines(process.argv[4], 'stable', kube.create_cloud_config),
    azure.queue_internalloadbalancer(process.argv[3], process.argv[4]),
    //azure.queue_endpoints(process.argv[4]),
    azure.queue_endpoints_ilb(process.argv[4]),
  ]);
}else{
  if (process.argv[6] !== undefined && parseInt(process.argv[6]) == 2){
    azure.run_task_queue([
      azure.queue_machines(process.argv[4], 'stable', kube.create_cloud_config),
      azure.queue_internalloadbalancer(process.argv[3], process.argv[4]),
      //azure.queue_endpoints(process.argv[4]),
      azure.queue_endpoints_ilb(process.argv[4]),
    ]);
  }else{
    azure.run_task_queue([
      azure.queue_machines(process.argv[4], 'stable', kube.create_cloud_config),
      //azure.queue_endpoints(process.argv[4]),
      azure.queue_endpoints_ilb(process.argv[4]),
    ]);
  }
}