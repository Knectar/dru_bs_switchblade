#!/usr/bin/ruby
#user new_drupal_app.rb CLIENT INSTANCE_NAME FILES
#will create and prepare directory tree that is relative to where the command
#was run that looks like 
# CLIENT/INSTANCE_NAME/FILES
# files with be chowned to the php user
# will also create an output new database details
# will create new branch and deployment role and branch in beanstalk
require 'optparse'

options = {:client => nil, :instance => 'dev', :files => 'sites/default/files', :php_version => '5.4'}
parser = OptionParser.new do|opts|
	opts.banner = "new_drupal_app.rb [options]"
	opts.on('-c' ,'--client client', "client value should match beanstalk project name") do |client|
		options[:client] = client;
	end
	
	opts.on('-i', '--instance instance', "the applications instance name. defualts to dev. \n If it is other than stage or dev it the url will be INSTANCE-CLIENT.dev.knectar.com") do |instance|
		options[:instance] = instance;
	end
	opts.on('-f', '--files path', 'path to drupal files dir') do |files|
		options[:files] = files;
	end 
	opts.on('-p', '--php php_version', 'can be "5.3", "5.4", "5.5". Defaults ot 5.4') do |ver|
		options[:php_version] = ver;
	end
	opts.on('-h', '--help', 'Displays help') do
		puts opts
		exit
	end
end

parser.parse!
if options[:client] == nil
	print 'you need to at least enter a clent name: '
	options[:clent] = gets.chomp
end

## making directories
require 'fileutils'
#FileUtils.mkdir_p

# makeing mysql info

# setting up new role and pulling from beanstalk
