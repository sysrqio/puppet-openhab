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

  $habmin_url                     = 'https://github.com/cdjackson/HABmin/archive/master.zip'

  $configuration                  = undef

}
