options = {:client => nil, :instance => 'dev', :files => 'sites/default/files', :php_version => '5.4',
  #the user that php runs as generally www_data on debian boxes, apache on redhat
  :php_user => 'apache',
  #the unix user that the deployed files will b owned by
  :app_owner => 'sites',
  :mysql_user => 'root'
}
