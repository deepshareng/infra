# How to ssh to the servers in office
The step by step guide to connect to servers located in techCode office.

## Step 1: install vpn client on your Mac
You can [download](https://tunnelblick.net/downloads.html) tunnelblick, which is recommended vpn client on Mac.

## Step 2: Generate user's key and conf yourself
```
ssh ni@ni.chinacloudapp.cn -p 2222
```
note that sudo have diffent environment variables than your normal shell, also environment variables are not persistent between diffenent run of sudo, so I suggest run sudo su before following commands:
```
ni.chinacloudapp.cn$ sudo su
ni.chinacloudapp.cn# cd /etc/openvpn/easy-rsa/
ni.chinacloudapp.cn# source vars
ni.chinacloudapp.cn# ./build-key your_client_name
ni.chinacloudapp.cn# exit
ni.chinacloudapp.cn$
```

## Step 3: drag and drop the client.conf to tunnelblick on the menubar of your Mac

## Step 4: connect to vpn client machine in office
```
ssh <yourname>@<host-ip-in-vpn>
```
ask administrator for your password

## Step 5: ssh to other machines in office
now, you can ssh to any machine just like you were in office.

## Hostname and ips
```
Hostname    office-ip       VPN-ip
octo        172.11.51.2     10.8.0.42
octp		172.11.51.3     10.8.0.46
t430		172.11.51.4     -
quad		172.11.51.6     -
```