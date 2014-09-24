settings = {
  #the user that php runs as generally www_data on debian boxes, apache on redhat
  :php_user => 'apache',
  #the unix user that the deployed files will b owned by
  :app_owner => 'sites',
  :mysql_user => 'root'
}
