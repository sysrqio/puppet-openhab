# == Class: openhab
#
# Full description of class openhab here.
#
# === Parameters
#
# Document parameters here.
#
# [*sample_parameter*]
#   Explanation of what this parameter affects and what it defaults to.
#   e.g. "Specify one or more upstream ntp servers as an array."
#
# === Variables
#
# Here you should define a list of variables that this module would require.
#
# [*sample_variable*]
#   Explanation of how this variable affects the funtion of this class and if
#   it has a default. e.g. "The parameter enc_ntp_servers must be set by the
#   External Node Classifier as a comma separated list of hostnames." (Note,
#   global variables should be avoided in favor of class parameters as
#   of Puppet 2.6.)
#
# === Examples
#
#  class { 'openhab':
#    servers => [ 'pool.ntp.org', 'ntp.local.company.com' ],
#  }
#
# === Authors
#
# Mans Matulewicz <mans.matulewicz@gmail.com>
#
# === Copyright
#
# Copyright 2015 Mans Matulewicz
#
class openhab (
  $version                    = $::openhab::params::version,
  $install_dir                = $::openhab::params::install_dir,
  $sourceurl                  = $::openhab::params::sourceurl,
  $security_netmask           = $::openhab::params::security_netmask,

#denon binding
  $binding_denon_id           = $::openhab::params::binding_denon_id,
  $binding_denon_host         = $::openhab::params::binding_denon_host,
  $binding_denon_update       = $::openhab::params::binding_denon_update,

#mosquitto binding
  $binding_mqtt_id            = $::openhab::params::binding_mqtt_id,
  $binding_mqtt_url           = $::openhab::params::binding_mqtt_url,
  $binding_mqtt_clientId      = $::openhab::params::binding_mqtt_clientId, #todo-opt
  $binding_mqtt_user          = $::openhab::params::binding_mqtt_user, #todo-opt
  $binding_mqtt_password      = $::openhab::params::binding_mqtt_password, #todo-opt
  $binding_mqtt_qos           = $::openhab::params::binding_mqtt_qos, #todo-opt
  $binding_mqtt_retain        = $::openhab::params::binding_mqtt_retain, #todo-opt
  $binding_mqtt_async         = $::openhab::params::binding_mqtt_async, #todo-opt
  $binding_mqtt_lwt           = $::openhab::params::binding_mqtt_lwt, #todo-opt

  ) inherits ::openhab::params{

    include ::archive
    ensure_packages(['unzip'])

    file {'/opt/openhab':
    ensure => directory,
    path   => '/opt/openhab',
  } ->
  archive {'openhab-runtime':
    ensure       => present,
    path         => "/tmp/distribution-${version}-runtime.zip",
    source       => "${sourceurl}/distribution-${version}-runtime.zip",
    creates      => "${install_dir}/server/plugins/org.openhab.core_${version}.jar",
    extract      => true,
    cleanup      => false,
    extract_path => $install_dir,
    require      => Package['unzip'],
  } ->
  file {"${install_dir}/addons_repo":
  ensure => directory,
  path   => '/opt/openhab/addons_repo',
}

  archive {"openhab-addons-${version}":
    ensure       => present,
    path         => "/tmp/distribution-${version}-addons.zip",
    source       => "${sourceurl}/distribution-${version}-addons.zip",
    creates      => "${install_dir}/addons_repo/org.openhab.io.myopenhab-${version}.jar",
    extract      => true,
    cleanup      => false,
    extract_path => "${install_dir}/addons_repo",
  }

  $addons = hiera('openhab_addons', {})
  create_resources('addon', $addons)

  file {'openhab.initd':
    ensure => present,
    path   => '/etc/init.d/openhab',
    mode   => '0755',
    source => 'puppet:///modules/openhab/openhab.initd',
  } ->

  user { 'openhab':
      ensure  => present,
      groups  => [ 'dialout' ],
      require => Archive['openhab-runtime'],
    } ->
  file  {'openhab.cfg':
    ensure  => present,
    path    => "${install_dir}/configurations/openhab.cfg",
    content => template('openhab/openhab.cfg.erb'),
    require => Archive['openhab-runtime'],
} ->
  service {'openhab':
    ensure    => running,
    enable    => true,
    subscribe => File['openhab.cfg'],
  }
}
