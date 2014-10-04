#!/usr/bin/env ruby
#user new_drupal_app.rb CLIENT INSTANCE_NAME FILES
#will create and prepare directory tree that is relative to where the command
#was run that looks like 
# CLIENT/INSTANCE_NAME/FILES
# files with be chowned to the php user
# will also create an output new database details
# will create new branch and deployment role and branch in beanstalk

#require 'bundler'
#Bundler.require

require 'rubygems'
require 'mysql'
require 'securerandom'
require 'dotenv'
Dotenv.load

options = {:client => nil,
           :instance => ENV['instance'],
           :files => ENV['files'],
           :php_version => ENV['php_version'],
           :php_user => ENV['php_user'],
           :app_owner => ENV['app_owner'],
           :mysql_user => ENV['mysql_user']
}
require 'optparse'


parser = OptionParser.new do|opts|
  opts.banner = "new_drupal_app.rb [options]. All settings can be preset in a file called settings.rb"
  opts.on('-c' ,'--client client', "Client value should match beanstalk project name") do |client|
    options[:client] = client;
  end

  opts.on('-i', '--instance instance', "The applications instance name. Defaults to 'dev'. If it is other than stage or dev it the URL will be INSTANCE-CLIENT.dev.knectar.com") do |instance|
    options[:instance] = instance;
  end
  opts.on('-f', '--files path', 'Path to Drupal files directory') do |files|
    options[:files] = files;
  end 
  opts.on('-p', '--php_version php_version', 'can be "5.3", "5.4", "5.5". Defaults to 5.4') do |ver|
    options[:php_version] = ver;
  end
  opts.on( "-u", "--php_user",
          "the user that php runs as") do |opt|
    options[:php_user] = opt
  end
  opts.on( "-o", "--owner app owner", "The UNIX level owner that the application will live under, can be hard set in the settings") do |opt| 
    options[:app_owner] = opt;
  end
  opts.on( "-O", "--options",
          "Output all settings") do
    require 'yaml'
    puts YAML::dump(options)
  end
  opts.on('-h', '--help', 'Displays help') do
    puts opts
    exit
  end
end

parser.parse!
if options[:client] == nil
  print 'you need to at least enter a client name: '
  options[:client] = gets.chomp
end

## making directories
def mk_drufile_system(options)
  require 'fileutils'
  FileUtils.mkdir_p options[:client] + '/' + options[:instance] +'/' + options[:files]
  FileUtils.chown options[:app_owner], options[:app_owner], options[:client]
  FileUtils.chown_R options[:app_owner], options[:app_owner], options[:client] + '/' + options[:instance]
  FileUtils.chown_R options[:php_user], options[:app_owner], options[:client] + '/' + options[:instance] +'/' + options[:files] 
  puts "File system prepared"
end

def mk_db(options)
  # making MySQL info

  random_password = SecureRandom.hex(20)
  new_db = options[:client] + '_' + options[:instance]
  created = Mysql.real_connect('localhost', new_db, random_password, new_db)
  while created == 0
    print "what is the mysql " + options[:mysql_user] + "'s password?"
    sql_password = gets.chomp

    root_connect = Mysql.real_connect("localhost", options[:mysql_user], sql_password)
    root_connect.create_database(new_db)
    root_connect.query("CREATE USER ' #{new_db}'' @ 'localhost' IDENTIFIED BY '#{random_password}'")
    root_connect.query("GRANT ALL ON #{new_db}.* TO '#{new_db}'@'localhost'")
    root_connect.close
  end
  created.close
  puts "created database: #{new_db}"
  puts "creates user: #{new_db}"
  puts "password: #{random_password}"
end

# setting up new role and pulling from beanstalk
