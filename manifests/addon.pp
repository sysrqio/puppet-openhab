#class open:addons
# == Define: define_name
#
define openhab::addon ($addon_version = $openhab::version, $sourceurl = $openhab::sourceurl) {

    file {"org.openhab.${name}-${addon_version}.jar":
      ensure  => present,
      path    => "${openhab::install_dir}/addons/org.openhab.${name}-${addon_version}.jar",
      source  => "${openhab::install_dir}/addons_repo/org.openhab.${name}-${addon_version}.jar",
      require => Archive["openhab-addons-${addon_version}"],
    }

    #because my marantz sr7005 doesnt work with the 1.7.1 version of the denon module,
    # you can now install an addon with a different version.
    if !defined(Archive["openhab-addons-${addon_version}"])
    {
      archive {"openhab-addons-${addon_version}":
        ensure       => present,
        path         => "/tmp/distribution-${addon_version}-addons.zip",
        source       => "${sourceurl}/distribution-${addon_version}-addons.zip",
        creates      => "${openhab::install_dir}/addons_repo/org.openhab.io.myopenhab-${addon_version}.jar",
        extract      => true,
        cleanup      => false,
        extract_path => "${openhab::install_dir}/addons_repo",
      }
    }

    #
    $splitter = split($name, '[.]')
    #notify { "addonsplit - ${addontype} - ${name}":  }
    if $splitter[0] == 'persistence'
    {
      file {"${splitter[1]}.persist":
        ensure => present,
        path   => "${openhab::install_dir}/configurations/persistence/${splitter[1]}.persist",
        source => "puppet:///modules/openhab/persistence/${splitter[1]}.persist",
      }


    }

  }
