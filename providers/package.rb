# copyright...

action :install do
   filename = new_resource.url.split('/')[-1]
   localfile = "#{Chef::Config[:file_cache_path]}/#{filename}"
   remote_file "#{localfile}" do
     source new_resource.url
     action :create_if_missing
   end
   rpm_package "#{localfile}" do
       action :install
   end
end

action :remove do
   rpm_package zends do
       action :remove
   end
   file "#{localfile}" do
       action :remove
   end
end
