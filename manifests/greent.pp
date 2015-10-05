#greent install module
class openhab::greent
{
  archive {'greent':
    ensure       => present,
    path         => "/tmp/distribution-${openhabb::version}-greent.zip",
    source       => "https://bintray.com/artifact/download/openhab/bin/distribution-${openhab::version}-greent.zip",
    creates      => "${openhab::install_dir}/webapps/greent",
    extract      => true,
    cleanup      => false,
    extract_path => "${openhab::install_dir}/webapps/",
    notify       => Service['openhab'],
  }

  #habmin comes packages with ancient zwave binding
  #file {"${openhab::install_dir}/addons/org.openhab.binding.zwave-1.5.0-SNAPSHOT.jar":
  #  ensure => absent,
  #}
}
