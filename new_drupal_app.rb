#!/usr/bin/ruby
#user new_drupal_app.rb CLIENT INSTANCE_NAME FILES
#will create and prepare directory tree that is relative to where the command
#was run that looks like 
# CLIENT/INSTANCE_NAME/FILES
# files with be chowned to the php user
# will also create an output new database details
# will create new branch and deployment role and branch in beanstalk
require 'fileutils'
#FileUtils.mkdir_p
