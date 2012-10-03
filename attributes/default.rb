# copyright ...
#

default['zends']['arch'] = kernel['machine'] =~ /x86_64/ ? "x86_64" : "x86"
default['zends']['centos5']['x86_64']['url'] = "http://10.0.2.2:8080/zends-5.5.15-1.r51229.el5.x86_64.rpm"
default['zends']['centos6']['x86_64']['url'] = "http://10.0.2.2:8080/zends-5.5.15-1.r51229.el6.x86_64.rpm"
default['zends']['centos5']['x86']['url'] = "http://10.0.2.2:8080/zends-5.5.15-1.r51229.el5.x86.rpm"
default['zends']['centos6']['x86']['url'] = "http://10.0.2.2:8080/zends-5.5.15-1.r51229.el6.x86.rpm"


set['zends']['grants_path']                 = "/etc/zends_grants.sql"
node['zends']['zends_bin']                  = "/opt/zends/bin/mysql"
node['zends']['zendsadmin_bin']                  = "/opt/zends/bin/mysqladmin"

default['zends']['allow_remote_root']               = false
default['zends']['port'] = "13306"
default['zends']['socket'] = "/var/lib/zends/zends.sock"
default['zends']['pid-file'] = "/var/run/zends/zends.pid"
default['zends']['user'] = "zenoss"
default['zends']['basedir'] = "/opt/zends"
default['zends']['datadir'] = "/opt/zends/data"
default['zends']['allow_remote_root']               = false
default['zends']['tunable']['innodb_buffer_pool_size']  = "64M"
default['zends']['reload_action'] = "restart" # or "reload" or "none"
# log file size should be 25% of of buffer pool size
default['zends']['tunable']['innodb_log_file_size']  = "64M"
default['zends']['tunable']['innodb_additional_mem_pool_size']  = "32M"
default['zends']['tunable']['query_cache_size']     = "32M"
default['zends']['tunable']['innodb_log_buffer_size']  = "8M"
default['zends']['tunable']['query_cache_size']     = "32M"
default['zends']['tunable']['max_allowed_packet']   = "64M"
default['zends']['tunable']['wait_timeout']         = "86400"
default['zends']['tunable']['innodb_thread_concurrency']   = 4
default['zends']['tunable']['innodb_flush_method']  = "O_DIRECT"
default['zends']['tunable']['innodb_flush_log_at_trx_commit']  = "2"
