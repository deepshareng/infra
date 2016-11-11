#!/bin/sh

export AZURE_STORAGE_DNS_SUFFIX=core.chinacloudapi.cn
export AZ_CHINA_CLOUD=yes
export AZ_LOCATION="China North"
# export AZ_VM_SIZE=ExtraLarge
export AZ_VM_SIZE=Large
azure account set 0149bea5-fc85-4729-9110-c0d4f297d550
