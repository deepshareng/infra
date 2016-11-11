#!/bin/sh

export AZURE_STORAGE_DNS_SUFFIX=core.windows.net
unset AZ_CHINA_CLOUD
unset AZ_LOCATION
azure account set b4400ee1-1f12-4f67-bd93-871fa2c550ef
