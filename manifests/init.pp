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
  $version                        = $::openhab::params::version,
  $install_dir                    = $::openhab::params::install_dir,
  $sourceurl                      = $::openhab::params::sourceurl,
  $personalconfigmodule           = $::openhab::params::personalconfigmodule,
  $install_java                   = $::openhab::params::install_java,
  $install_habmin                 = $::openhab::params::install_habmin,
  $install_greent                 = $::openhab::params::install_greent,
  $install_repository             = $::openhab::params::install_repository,

  $security_netmask               = $::openhab::params::security_netmask,
  $security_netmask_enable        = $::openhab::params::security_netmask_enable,

  $habmin_url                     = $::openhab::params::habmin_url,

  $configuration                  = $::openhab::params::configuration,
  ) inherits ::openhab::params{

    if $openhab::install_repository {
      case $::operatingsystem {
        'Debian', 'Ubuntu': {
          include apt
					# deb http://dl.bintray.com/openhab/apt-repo stable main
					apt::source { "openhab-${openhab::version}":
						comment  => 'This is the Openhab Repository',
						location => 'http://dl.bintray.com/openhab/apt-repo',
						release  => 'stable',
						repos    => 'main',
						key      => {
							'id'     => 'EDB7D0304E2FCAF629DF1163075721F6A224060A',
							'source' => 'https://bintray.com/user/downloadSubjectPublicKey?username=openhab',
						},
						include  => {
							'deb' => true,
						},
					}
        }
        default : {
          fail ("Apt not supported on ${::operatingsystem}") }
      }
    }
    include ::archive
    ensure_packages(['unzip'])

    anchor {'openhab::begin':}
    anchor {'openhab::end':}

    if $openhab::install_java {
      include ::java
      Anchor['openhab::begin'] ->
        Class['java'] ->
        Service['openhab'] ->
      Anchor['openhab::end']
    }

    if $openhab::install_habmin {
        include ::openhab::habmin
      Anchor['openhab::begin'] ->
        Class['openhab::habmin'] ->
        Service['openhab'] ->
      Anchor['openhab::end']
    }
    if $openhab::install_greent {
        include ::openhab::greent
      Anchor['openhab::begin'] ->
        Archive['openhab-runtime']
        Class['openhab::greent'] ->
        Service['openhab'] ->
      Anchor['openhab::end']
    }

	if $::openhab::install_repository {
		package {'openhab-runtime':
			ensure => $::openhab::version,
		}
	} else {
		file {'/opt/openhab':
			ensure => directory,
			path   => '/opt/openhab',
		}
		archive {'openhab-runtime':
			ensure       => present,
			path         => "/tmp/distribution-${version}-runtime.zip",
			source       => "${sourceurl}/distribution-${version}-runtime.zip",
			creates      => "${install_dir}/server/plugins/org.openhab.core_${version}.jar",
			extract      => true,
			cleanup      => false,
			extract_path => $install_dir,
			require      => [File['/opt/openhab'], Package['unzip']],
		}
		file {"${install_dir}/addons_repo":
			ensure  => directory,
			path		=> '/opt/openhab/addons_repo',
			require => Archive['openhab-runtime'],
		}
		archive {"openhab-addons-${version}":
			ensure       => present,
			path				 => "/tmp/distribution-${version}-addons.zip",
			source       => "${sourceurl}/distribution-${version}-addons.zip",
			creates      => "${install_dir}/addons_repo/org.openhab.io.myopenhab-${version}.jar",
			extract      => true,
			cleanup      => false,
			extract_path => "${install_dir}/addons_repo",
			require			 => File["${install_dir}/addons_repo"],
		}
    file {'openhab.initd':
      ensure  => present,
      path    => '/etc/init.d/openhab',
      mode    => '0755',
      source  => 'puppet:///modules/openhab/openhab.initd',
      require => Archive['openhab-runtime'],
    }
	}

  user { 'openhab':
    ensure  => present,
    groups  => [ 'dialout' ],
    require => $::openhab::install_repository ? { true => Package['openhab-runtime'], false =>  Archive['openhab-runtime'] },
  }

  $addons = hiera('openhab_addons', {})
  create_resources('addon', $addons)

  
	if !$::openhab::install_repository {
    file {'openhab-items':
      ensure  => directory,
      path    => '/opt/openhab/configurations/items',
      recurse => 'remote',
      source  => "puppet:///modules/${personalconfigmodule}/items",
    }
    file {'openhab-rules':
      ensure  => directory,
      path    => '/opt/openhab/configurations/rules',
      recurse => 'remote',
      source  => "puppet:///modules/${personalconfigmodule}/rules",
    }
    file {'openhab-sitemaps':
      ensure  => directory,
      path    => '/opt/openhab/configurations/sitemaps',
      recurse => 'remote',
      source  => "puppet:///modules/${personalconfigmodule}/sitemaps",
    }
  }
  
  concat { "${install_dir}/configurations/openhab.cfg":
    ensure  => present,
    owner   => 'openhab',
    group   => 'openhab',
    require => $::openhab::install_repository ? { true => Package['openhab-runtime'], false => Archive['openhab-runtime'] },
    notify  => Service['openhab'],
  }

  concat::fragment { "openhab-runtime-${::openhab::version}":
    target  => "${::openhab::install_dir}/configurations/openhab.cfg",
    content => template("openhab/openhab-runtime-${::openhab::version}.cfg.erb"),
    order   => '01'
  }

  service {'openhab':
    ensure    => running,
    enable    => true,
    subscribe => File["${install_dir}/configurations/openhab.cfg"],
  }

}
