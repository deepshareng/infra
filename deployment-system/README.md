# 代码发布系统

基于php yii framework1.1编写，当前提供以下功能：
	 
	 1，多环境发布
	      测试，预发布，生产环境
	 2，管理员上线审核
	 3，预定化配置功能
	 4，代码回滚功能
	 5，基本不同的branch和commit版本发布
	 
	 
访问地址：
   http://qdu.cloudapp.net/
   
用户注册需要通过公司邮箱@misingularity来实现。



代码目录为：  
   git@github.com:MISingularity/deployment-system.git
   
该系统由两部分构成：

  前端和逻辑实现  
       r.fds.so:5000/deployment-server
       使用端口 80，443
     
  后端数据库(存储元数据)  
       r.fds.so:5000/mysql-server:latest
       使用端口 3306
       
  
  
数据备份：  
备份脚本－－ mysql-backup.sh   
通过crontab 实现定时备份   
  50 *    * * *   root    bash /opt/mysql-backup.sh
  
备份目录  
 /home/docker/_backup/mysql
 
 
数据恢复：  
所有脚本都位于 recover目录下，请启用service-recovery.sh.
并且将 staging,prod,test三个目录拷贝到恢复主机的/mnt目录下。并赋予相应的目录所属用户和组(根据之前发布系统内部配置的，默认为docker).
 
 


整个程序部署于 qdu.cloudapp.net

当前整个发布流程及文档请参阅：
 [发布系统文档](https://doc.huamanshu.com/%E7%93%A6%E5%8A%9B)
 

