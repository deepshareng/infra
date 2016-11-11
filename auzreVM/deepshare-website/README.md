# Overview of deepshare-website
Flora用go写了一个webserver的程序，和静态网页的内容一起放在[github](https://github.com/MISingularity/deepshare_website)
上，webserver被build成docker image[r.fds.so:5000/dswebserver:20150907]
# Run webserver
假设VM上已经安装docker，如果没有安装，请先安装docker
首先将保存在github上的网页内容git clone到安装webserver的VM上
```
git clone https://github.com/MISingularity/deepshare_website /mnt/{$webserver}
```
进入存放静态网页的目录`cd /mnt/{$webserver}`，然后docker run webserver
```
sudo docker -d -p 4000:8082 -v ($pwd)://go/src/github.com/MISingularity/deepshare_website/_site \
--name webserver r.fds.so:5000/wswebserver:20150907
```
# Pull updated content from github to web server
来到静态网页目录`cd /mnt/{$webserver}`，然后`git pull` github上的内容到VM
然后，直接刷新网页，就可以看到更新的内容了
