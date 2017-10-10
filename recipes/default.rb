# #
# # Cookbook:: encrypted-databag
# # Recipe:: default
# #
# # Copyright:: 2017, The Authors, All Rights Reserved.
# # Create encrypted databag and use it
#
# db = data_bag('dev')
# creds = data_bag_item('dev','user1')
#
# Chef::Log.info("Showing DataBagItem Full Name: #{creds['Full Name']}")
# Chef::Log.info("Showing DataBagItem Shell: #{creds['shell']}")
# Chef::Log.info("Showing DataBagItem Password: #{creds['password']}")
#
# # Write this to a template
# template "/tmp/user.conf" do
#      variables(:FullName => creds['Full Name'],
#                :Shell => creds['shell'],
#                :Password => creds['password'])
#      owner "root"
#      mode  "0644"
#      source "user.conf.erb"
# end
#
#
#
# secret = Chef::EncryptedDataBagItem.load_secret("/tmp/secrets/secret_key")
# samba_creds = Chef::EncryptedDataBagItem.load("users", "credentials", secret)
# db_creds = Chef::EncryptedDataBagItem.load("users", "db_credentials", secret)
# default['dcc-samba']['username']=samba_creds['user']
# default['dcc-samba']['password']=samba_creds['password']

# Create Encrypted Databag from Databag using secret
# ruby encrypt_databag.rb databag.json users.json secret.txt

log Chef::Config[:data_bag_path]

directory '/tmp/databags' do
  owner 'root'
  group 'root'
  mode '0755'
  action :create
end

# chef_data_bag 'users1' do
#   name "users1"
#   action :create
# end
#
# chef_data_bag_item 'karl' do
#   data_bag 'users1'
#   # raw_data '/tmp/users.json'
#   raw_json = '{ "Full Name": "Karl Miller", "shell": "/bin/bash", "password": "InsecurePW" }'
#   action :create
# end
#
# chef_data_bag_item 'sam' do
#   data_bag 'users1'
#   raw_json = '{ "Full Name": "Sam Miller", "shell": "/bin/bash", "password": "C0mplexPW$" }'
#   action :create
# end



# Copy the encrypt_databag.rb to tmp dir
cookbook_file "/tmp/encrypt_databag.rb" do
  source 'encrypt_databag.rb'
  owner 'root'
  group 'root'
  mode '0755'
  action :create
end


#  cookbook_file "#{Chef::Config[:data_bag_path]}/users.json"
cookbook_file "/var/chef/data_bags/users.json" do
  owner 'root'
  group 'root'
  mode '0644'
  source 'users.json'
  action :create
end



template '/tmp/chef_configuration' do
  # content "#{Chef::Config[:data_bag_path]}"
  variables({
    :data_bag_path => "#{Chef::Config[:data_bag_path]}",
    :log_level => "#{Chef::Config[:log_level]}",
    :log_location => "#{Chef::Config[:log_location]}"
  })
  mode '0755'
  owner 'root'
  group 'root'
  source 'chef_config.erb'
end

# directory "#{Chef::Config[:data_bag_path]}" do
#   owner 'root'
#   group 'root'
#   mode '0755'
#   action :create
# end

log Chef::Config[:data_bag_path]
log "Log Level: #{Chef::Config[:log_level]}"
log "Log Location: #{Chef::Config[:log_location]}"

log "DATA_BAG_PATH: #{Chef::Config[:data_bag_path]}"
log "DATA_BAG_SECRET: #{Chef::Config[:encrypted_data_bag_secret]}"


secret = Chef::EncryptedDataBagItem.load_secret("/etc/chef/encrypted_data_bag_secret")
creds = Chef::EncryptedDataBagItem.load("users.json", "user1", secret)
log creds['name']
log password=creds['password']


# users=begin
#           Chef::DataBag.load("users")
#         rescue Net::HTTPServerException, Chef::Exceptions::InvalidDataBagPath
#           nil
#         end


# bagname = 'users1'
# user = 'sam'
# item = begin
#          Chef::DataBagItem.load(bagname, user)
#       rescue Net::HTTPServerException => e
#         if e.response.code == "404" then
#           log("INFO: Creating a new data bag item")
#           item = Chef::DataBagItem.new
#           item.data_bag(bagname)
#           item['id'] = 'sam'
#           item['fullname'] = "Sam Miller"
#           # item.save
#         else
#           log("ERROR: Received an HTTPException of type " + e.response.code)
#           raise
#         end
#       end
# log item.inspect
# log Chef::DataBag.load("users1")
# log Chef::DataBagItem.load('users1','karl')

# users=Chef::DataBag.load("users")
# user=Chef::DataBagItem.load('users','karl')
# log "KARL Fullname: #{user['Full Name']}"



# user_info = data_bag_item('karl', 'users')
# full_name=user_info['Full Name']
# users = chef_data_bag('users')
#
# if users
#   log "users: #{users}"
# end

# users =  begin
#             chef_data_bag('users')
#
#             nil
#           end
# log "users: #{users}"
# full_name = data_bag_item('users','karl')
# log "fullname: #{full_name}"

# if users
#   users.each do |user|
#     full_name = chef_data_bag_item('users',user)
#                 rescue Net::HTTPServerException, Chef::Exceptions::InvalidDataBagPath
#                  nil
#                 end
#     log "fullname: #{full_name}"
#   end
# end
