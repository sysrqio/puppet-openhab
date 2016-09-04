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

  $logging                        = {
                                        'openhab' => {
                                                        'enabled'          => true,
                                                        'logname'          => 'FILE',
                                                        'history'          => '30',
                                                        'rollover_pattern' => 'yyyy-ww',
                                                        'levels'           => [ 'WARN' ],
                                        },
                                        'stdout'  => {
                                                        'enabled'          => true,
                                                        'logname'          => 'STDOUT',
                                                        'levels'           => [ 'WARN' ],
                                        },
                                        'syslog'  => {
                                                        'enabled'          => false,
                                                        'logname'          => 'SYSLOG',
                                                        'host'             => undef,
                                                        'facility'         => undef,
                                                        'logpattern'       => undef,
                                                        'levels'           => [ 'WARN' ],
                                        },
                                        'events'  => {
                                                        'enabled'          => true,
                                                        'logname'          => 'EVENTFILE',
                                                        'history'          => '30',
                                                        'rollover_pattern' => 'yyyy-ww',
                                        },
                                    }

  $configuration                  = undef

}
