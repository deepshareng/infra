#nginx 编译手册


1，安装依赖关系


apt-get install -y openssl gcc g++ libssl-dev


2,拉取tengine到对应的编译服务器  
git clone apt-get https://github.com/alibaba/tengine.git

3,开始编译操作  

注：如果需要编译额外的模块，需要下载该模块源码到对应的目录，然后在运行configure命令的时候指定需要编译模块的绝对路径  
比如： --add-module=/mnt/tengine/modules/nginx-module-vts  


    ./configure --prefix=/etc/nginx --sbin-path=/usr/sbin/nginx --conf-path=/etc/nginx/nginx.conf --error-log-path=/var/log/nginx/error.log --http-log-path=/var/log/nginx/access.log --pid-path=/var/run/nginx.pid --lock-path=/var/run/nginx.lock --http-client-body-temp-path=/var/cache/nginx/client_temp --http-proxy-temp-path=/var/cache/nginx/proxy_temp --user=nginx --group=nginx --with-http_ssl_module --with-http_realip_module --with-http_addition_module --with-http_sub_module --with-http_dav_module --with-http_flv_module --with-http_mp4_module --with-http_gunzip_module --with-http_gzip_static_module --with-http_random_index_module --with-http_secure_link_module --with-http_stub_status_module --with-http_auth_request_module  --with-http_reqstat_module=shared --with-http_v2_module  --with-http_upstream_least_conn_module=shared --add-module=/mnt/tengine/modules/nginx-module-vts --with-cc-opt='-g -O2  -Wformat'  --with-ipv6


    make && make install

4，编译完后的已安装模块检测  

    nginx -V

    Tengine version: Tengine/2.2.0 (nginx/1.8.1)
    built by gcc 4.8.4 (Ubuntu 4.8.4-2ubuntu1~14.04)
    TLS SNI support enabled
    configure arguments: --prefix=/etc/nginx --sbin-path=/usr/sbin/nginx --conf-path=/etc/nginx/nginx.conf --error-log-path=/var/log/nginx/error.log --http-log-path=/var/log/nginx/access.log --pid-path=/var/run/nginx.pid --lock-path=/var/run/nginx.lock --http-client-body-temp-path=/var/cache/nginx/client_temp --http-proxy-temp-path=/var/cache/nginx/proxy_temp --user=nginx --group=nginx --with-http_ssl_module --with-http_realip_module --with-http_addition_module --with-http_sub_module --with-http_dav_module --with-http_flv_module --with-http_mp4_module --with-http_gunzip_module --with-http_gzip_static_module --with-http_random_index_module --with-http_secure_link_module --with-http_stub_status_module --with-http_auth_request_module --with-http_reqstat_module=shared --with-http_v2_module --with-http_upstream_least_conn_module=shared --add-module=/mnt/tengine/modules/nginx-module-vts --with-cc-opt='-g -O2 -Wformat' --with-ipv6
    loaded modules:
    ngx_core_module (static)
    ngx_errlog_module (static)
    ngx_conf_module (static)
    ngx_dso_module (static)
    ngx_events_module (static)
    ngx_event_core_module (static)
    ngx_epoll_module (static)
    ngx_procs_module (static)
    ngx_proc_core_module (static)
    ngx_openssl_module (static)
    ngx_regex_module (static)
    ngx_http_module (static)
    ngx_http_core_module (static)
    ngx_http_log_module (static)
    ngx_http_upstream_module (static)
    ngx_http_v2_module (static)
    ngx_http_static_module (static)
    ngx_http_gzip_static_module (static)
    ngx_http_dav_module (static)
    ngx_http_autoindex_module (static)
    ngx_http_index_module (static)
    ngx_http_random_index_module (static)
    ngx_http_auth_request_module (static)
    ngx_http_auth_basic_module (static)
    ngx_http_access_module (static)
    ngx_http_limit_conn_module (static)
    ngx_http_limit_req_module (static)
    ngx_http_realip_module (static)
    ngx_http_geo_module (static)
    ngx_http_map_module (static)
    ngx_http_split_clients_module (static)
    ngx_http_referer_module (static)
    ngx_http_rewrite_module (static)
    ngx_http_ssl_module (static)
    ngx_http_proxy_module (static)
    ngx_http_fastcgi_module (static)
    ngx_http_uwsgi_module (static)
    ngx_http_scgi_module (static)
    ngx_http_memcached_module (static)
    ngx_http_empty_gif_module (static)
    ngx_http_browser_module (static)
    ngx_http_user_agent_module (static)
    ngx_http_secure_link_module (static)
    ngx_http_flv_module (static)
    ngx_http_mp4_module (static)
    ngx_http_upstream_hash_module (static)
    ngx_http_upstream_ip_hash_module (static)
    ngx_http_upstream_consistent_hash_module (static)
    ngx_http_upstream_check_module (static)
    ngx_http_upstream_keepalive_module (static)
    ngx_http_upstream_dynamic_module (static)
    ngx_http_stub_status_module (static)
    ngx_http_vhost_traffic_status_module (static)
    ngx_http_write_filter_module (static)
    ngx_http_header_filter_module (static)
    ngx_http_chunked_filter_module (static)
    ngx_http_v2_filter_module (static)
    ngx_http_range_header_filter_module (static)
    ngx_http_gzip_filter_module (static)
    ngx_http_postpone_filter_module (static)
    ngx_http_ssi_filter_module (static)
    ngx_http_charset_filter_module (static)
    ngx_http_sub_filter_module (static)
    ngx_http_addition_filter_module (static)
    ngx_http_gunzip_filter_module (static)
    ngx_http_userid_filter_module (static)
    ngx_http_footer_filter_module (static)
    ngx_http_trim_filter_module (static)
    ngx_http_headers_filter_module (static)
    ngx_http_upstream_session_sticky_module (static)
    ngx_http_copy_filter_module (static)
    ngx_http_range_body_filter_module (static)
    ngx_http_not_modified_filter_module (static)



5，当前封装的nginx针对两个不同的环境分别开启不同的流量监控策略  
  5.1 针对fds.so线上和测试环境   
  http_reqstat_module   
  ＃tengine自带模块   
  针对不同应用访问的出入流量统计  
  
  
  5.2 针对特定部署的环境，比如聚美优品的nginx  
  nginx-module-vts  
  #github地址： https://github.com/vozlt/nginx-module-vts  
  统计不同的设备访问