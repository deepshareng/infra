#!/usr/bin/env node

var azure = require('./lib/azure_wrapper.js');
var kube = require('./lib/deployment_logic/kubernetes.js');

// check whether the cloud service and storage account is there, if not then create them
azure.create_config('k8s1-1-1', { 'master': 5, 'node': parseInt(process.argv[2] || 0) });

azure.run_task_queue([
 azure.queue_storage_if_needed(),
 azure.queue_cloudservice(),
 azure.queue_machines('master', 'stable',
   kube.create_master_cloud_config),
 azure.queue_endpoints('master'),
 azure.queue_lbs_apiserver(),
 azure.queue_machines('node', 'stable',
   kube.create_node_cloud_config),
]);