# Class: openhab::params
#
# This class manages openhab parameters
#
# Parameters:
#
#
#
class openhab::params {

  $version                        = '1.7.1'
  $install_dir                    = '/opt/openhab'
  $sourceurl                      = 'https://bintray.com/artifact/download/openhab/bin'
  $personalconfigmodule           = 'openhab'
  $install_java                   = true
  $install_habmin                 = true
  $install_greent                 = true
  $install_repository             = false

  $security_netmask_enable        = true
  $security_netmask               = false

  $habmin_url                     = 'https://github.com/cdjackson/HABmin/archive/master.zip'

  ##action pushover
  $action_pushover_defaulttoken   = false
  $action_pushover_defaultuser    = false

  ##denon binding
  $binding_denon_id               = false
  $binding_denon_host             = false
  $binding_denon_update           = false

  ## mosquitto binding
  $binding_mqtt_id                = false
  $binding_mqtt_url               = false
  $binding_mqtt_clientId          = false
  $binding_mqtt_user              = false
  $binding_mqtt_password          = false
  $binding_mqtt_qos               = false
  $binding_mqtt_retain            = false
  $binding_mqtt_async             = false
  $binding_mqtt_lwt               = false

  ## persistence mysql
  $persistence_mysql_url          = false
  $persistence_mysql_user         = false
  $persistence_mysql_password     = false
  $persistence_mysql_reconnectCnt = false
  $persistence_mysql_waitTimeout  = false


}
