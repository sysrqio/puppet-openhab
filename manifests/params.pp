# Class: openhab::params
#
# This class manages openhab parameters
#
# Parameters:
#
#
#
class openhab::params {

  $version                    = '1.7.1'
  $install_dir                = '/opt/openhab'
  $sourceurl                  = 'https://bintray.com/artifact/download/openhab/bin'
  $security_netmask_enable    = true
  $security_netmask           = false

  ##denon binding
  $binding_denon_id           = false
  $binding_denon_host         = false
  $binding_denon_update       = false

  ## mosquitto binding
  $binding_mqtt_id            = false
  $binding_mqtt_url           = false
  $binding_mqtt_clientId      = false
  $binding_mqtt_user          = false
  $binding_mqtt_password      = false
  $binding_mqtt_qos           = false
  $binding_mqtt_retain        = false
  $binding_mqtt_async         = false
  $binding_mqtt_lwt           = false


}
