# copyright
#

::Chef::Recipe.send(:include, Opscode::OpenSSL::Password)

# generate all passwords
if not node.zends.include?("server_root_password")
    node.set_unless['zends']['server_root_password'] = secure_password
    node.set_unless['zends']['server_repl_password']   = secure_password
end

arch = node['zends']['arch']
family = node['family']

centos6 = (node['platform'] == 'centos' && Chef::VersionConstraint.new("~> 6.0").include?(node['platform_version']))
if centos6
  type='centos6'
else
  type='centos5'
end

rpm_url = node['zends'][type][arch]['url']

package "perl-DBI" do
    action :install
end

package "libaio" do
    action :install
end

zends_package "zends" do
    url rpm_url
    action :install
end

service "zends" do
  start_command "/etc/init.d/zends start"
  restart_command "/etc/init.d/zends restart"
  stop_command "/etc/init.d/zends stop"
  supports :status => true, :restart => true, :reload => true
  action :nothing
end

skip_federated = case node['platform']
                 when 'fedora', 'ubuntu', 'amazon'
                   true
                 when 'centos', 'redhat', 'scientific'
                   node['platform_version'].to_f < 6.0
                 else
                   false
                 end


template "/opt/zends/etc/zends.cnf" do
  source "zends.cnf.erb"
  owner "root"
  group "root"
  mode 0644
  case node['zends']['reload_action']
  when 'restart'
    notifies :restart, resources(:service => "zends"), :immediately
  when 'reload'
    notifies :reload, resources(:service => "zends"), :immediately
  else
    Chef::Log.info "zends.cnf updated but zends.reload_action is #{node['zends']['reload_action']}. No action taken."
  end
  variables :skip_federated => skip_federated
end

if node.recipes.include?("iptables")
    iptables_rule "port_zends"
else
    Chef::Log.info("Iptables recipe has not been defined.  Skipping setting zends firewall rules....")
end

unless Chef::Config[:solo]
    ruby_block "save node data" do
        block do
            node.save
        end
            action :create
    end
end

# set the root password on platforms
# that don't support pre-seeding
unless platform?(%w{debian ubuntu})

  execute "assign-root-password" do
    command "su - zenoss -c \"#{node['zends']['zendsadmin_bin']} -u root password #{node['zends']['server_root_password']}\""
    action :run
    only_if "su - zenoss -c \"#{node['zends']['zends_bin']} -u root -e 'show databases;'\""
  end

end


grants_path = node['zends']['grants_path']

begin
  t = resources("template[#{grants_path}]")
rescue
  Chef::Log.info("Could not find previously defined grants.sql resource")
  t = template grants_path do
    source "grants.sql.erb"
    owner "zenoss"
    group "zenoss"
    mode "0600"
    action :create
  end
end

execute "zends-install-privileges" do
  command "su - zenoss -c '#{node['zends']['zends_bin']} -u root #{node['zends']['server_root_password'].empty? ? '' : '-p' }\"#{node['zends']['server_root_password']}\" < #{grants_path}'"
  action :nothing
  subscribes :run, resources("template[#{grants_path}]"), :immediately
end
