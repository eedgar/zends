# copyright
#

arch = node['zends']['arch']
family = node['family']

centos6 = (node['platform'] == 'centos' && Chef::VersionConstraint.new("~> 6.0").include?(node['platform_version']))
if centos6
  type='centos6'
else
  type='centos5'
end

rpm_url = node['zends'][type][arch]['url']
#
package "perl-DBI" do
    action :install
end

package "libaio" do
    action :install
end

breakpoint "zends_rpmonly"
zends_package "zends" do
    url rpm_url
    action :install
end
