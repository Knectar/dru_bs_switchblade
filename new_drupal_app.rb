#!/usr/bin/env ruby
#user new_drupal_app.rb CLIENT INSTANCE_NAME FILES
#will create and prepare directory tree that is relative to where the command
#was run that looks like 
# CLIENT/INSTANCE_NAME/FILES
# files with be chowned to the php user
# will also create an output new database details
# will create new branch and deployment role and branch in beanstalk

require 'bundler'
Bundler.require

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
  opts.banner = "new_drupal_app.rb [options]. all settings can be preset in a file called settings.rb"
  opts.on('-c' ,'--client client', "client value should match beanstalk project name") do |client|
    options[:client] = client;
  end

  opts.on('-i', '--instance instance', "the applications instance name. defualts to dev. \n If it is other than stage or dev it the url will be INSTANCE-CLIENT.dev.knectar.com") do |instance|
    options[:instance] = instance;
  end
  opts.on('-f', '--files path', 'path to drupal files dir') do |files|
    options[:files] = files;
  end 
  opts.on('-p', '--php_version php_version', 'can be "5.3", "5.4", "5.5". Defaults ot 5.4') do |ver|
    options[:php_version] = ver;
  end
  opts.on( "-u", "--php_user",
          "the user that php runs as") do |opt|
    options[:php_user] = opt
  end
  opts.on( "-o", "--owner app owner", "the unix level owner that the application will live under, can be hard set in the settings") do |opt| 
    options[:app_owner] = opt;
  end
  opts.on( "-O", "--options",
          "Output all settings") do
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
require 'fileutils'
FileUtils.mkdir_p options[:client] + '/' + options[:instance] +'/' + options[:files]
FileUtils.chown options[:app_owner], options[:app_owner], options[:client]
FileUtils.chown_R options[:app_owner], options[:app_owner], options[:client] + '/' + options[:instance]
FileUtils.chown_R options[:php_user], options[:app_owner], options[:client] + '/' + options[:instance] +'/' + options[:files]

# makeing mysql info

# setting up new role and pulling from beanstalk
