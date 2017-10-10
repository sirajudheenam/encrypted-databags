#!/usr/bin/env ruby
require 'rubygems'
require 'json'
require 'chef/encrypted_data_bag_item'
require 'highline/import'

# DEFAULT_SECRET_FILE = "/Users/i072278/projects/cookbooks/i072278/cookbooks/encrypted-databag/files/secret.txt"

secret = Chef::EncryptedDataBagItem.load_secret("/etc/chef/encrypted_databag_secret")

puts secret 
# secret = Chef::EncryptedDataBagItem.load_secret("/Users/i072278/projects/cookbooks/i072278/cookbooks/encrypted-databag/files/secret.txt")
Chef::Config[:data_bag_path] = "/root/databags/"
credentials = Chef::EncryptedDataBagItem.load("user", "karl", secret)
puts credentials['Full Name']
puts credentials['shell']
puts credentials['password']