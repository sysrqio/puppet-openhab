#class to install habmin
class openhab::habmin
{
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
