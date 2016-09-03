#class to install habmin
class openhab::habmin
{
	if $::openhab::install_repository {
    include stdlib
    refacter { "openhab_habmin_jar": 
      pattern => '^openhab_habmin_jar',
    }

    # New habmin zip has a different folder structure
		archive {'habmin':
			ensure       => present,
			path         => '/tmp/master.zip',
			source       => $::openhab::habmin_url,
      creates      => "/tmp/HABmin-master",
			extract      => true,
			cleanup      => false,
			extract_path => "/tmp",
      notify       => File['/usr/share/openhab/webapps/habmin'],
		}

    file { '/usr/share/openhab/webapps/habmin':
      source  => '/tmp/HABmin-master/',
      recurse => true,
			notify  => Refacter['openhab_habmin_jar'],
    }

    # Fact is updated on the puppet start. This will update after the second run.
    # Zip has no version, only "master.zip". This requires to unpack the file, to see what is inside.
    # Using Refacter to do it in one puppet run.
    file {"/usr/share/openhab/addons/${basename($openhab_habmin_jar)}":
      ensure  => link,
      target  => $openhab_habmin_jar,
      require => File['/usr/share/openhab/webapps/habmin'],
      notify  => Service['openhab'],
    }
	} else {
		archive {'habmin':
			ensure       => present,
			path         => '/tmp/habmin.zip',
			source       => 'https://github.com/cdjackson/HABmin/releases/download/0.1.3-snapshot/habmin.zip',
			creates      => "${openhab::install_dir}/addons/org.openhab.io.habmin-1.5.0-SNAPSHOT.jar",
			extract      => true,
			cleanup      => false,
			extract_path => "${openhab::install_dir}/",
			notify       => Service['openhab'],
		}

		#habmin comes packages with ancient zwave binding
		file {"${openhab::install_dir}/addons/org.openhab.binding.zwave-1.5.0-SNAPSHOT.jar":
			ensure => absent,
		}
	}

}
