# openhab

#### Table of Contents

1. [Overview](#overview)
2. [Module Description - What the module does and why it is useful](#module-description)
3. [Setup - The basics of getting started with openhab](#setup)
    * [What openhab affects](#what-openhab-affects)
    * [Setup requirements](#setup-requirements)
    * [Beginning with openhab](#beginning-with-openhab)
4. [Usage - Configuration options and additional functionality](#usage)
    * [Hiera](#hiera)
    * [Using your own items/rules/sitemaps/etc](#Using-your-own-items/rules/sitemaps/etc)
5. [Reference - An under-the-hood peek at what the module is doing and how](#reference)
5. [Limitations - OS compatibility, etc.](#limitations)
6. [Development - Guide for contributing to the module](#development)
    * [Todo - my todo list](#todo)   

## Overview

Installing openhab & addons, currently developing for RPi/raspbian and debian, but should also work
on other Linux based system. Not using the OS version but the stock.

## Module Description

This module has as goal to simplify the installation and configuration of openhab.
The reason to build this: I expect my microsd card to fail once in a while and I am
too lazy to do a complete reinstall by hand.

## Setup

### What openhab affects
your household ;-)

### Setup Requirements

I am using plugin sync, not tested it without. Hiera is REQUIRED!


### Beginning with openhab

Get an Rpi with raspbian and use it :-) also normal debian should work,
java is auto installed by using puppetlabs-java, disable it by setting $install_java  to false.
The plugin does not support oracle java on RaspberryPi. Oracle java is recommended for Openhab.

## Usage

### Hiera
My hiera file currenty looks like this:
```
---

openhab::personalconfigmodule     : 'openhab-personal'
openhab::version                  : '1.8.3'
openhab::install_java             : false
openhab::install_repository       : true
openhab::install_habmin           : true
openhab::install_greent           : false
openhab::install_dir              : '/etc/openhab'
openhab::install_dir              : '/etc/openhab'
openhab::configuration:
    security_netmask              : '10.0.1.0/24'
    persistence_default           : 'rrd4j'


openhab_addons:
  binding-zwave:
      configuration:
          port                    : '/dev/ttyUSB0'
          healtime                : 2
          mastercontroller        : true
          setsuc                  : false
          softreset               : false
  io-myopenhab: {}
  binding-http:
      configuration:
          timeout                 : 500
          caches: []
  binding-sonos:
      configuration:
          pollingperiod           : 1000
          hosts:
              - host              : 'kueche'
                rinconuid         : 'RINCON_1234567890'
  persistence-mysql:
      configuration:
          url                     : 'jdbc:mysql://127.0.0.1:3306/openhab'
          user                    : 'openhab'
          password                : 'openhab'
          waittimeout             : '30'
          reconnectcnt            : '5'
  binding-denon:
      configuration:
        update                    : 5000
        hosts:
            - host                : 'sr7005'
              ip                  : '10.0.1.125'
              update              : 'telnet'
...
```
### Using your own items/rules/sitemaps/etc
To use your own item/rules/sitemaps/etc files, you need to set the variable openhab::personalconfigmodule. In this
variable you place the name of the folder name of the module that contains the files. In my case that is openhab-personal.
In the module directory, you need a directory named files with subdirectories items, rules and sitemaps.

## Reference

### Working plugins

#### Action pushover
Currently only implemented defaultuser and defaulttoken vars.
Hiera:
```
openhab_addons:
  action-pushover:
      configuration:
          defaulttimeout          : 10000
          defaulttoken            : 'findyourtokenonpushoverwebsite'
          defaultuser             : 'findyouruseronpushoverwebsite'
          defaulttitle            : 'OpenHAB'
          defaultpriority         : 0
          defaulturl              : ''
          defaulturltitle         : ''
          defaulturltitle         : ''
          defaultretry            : 300
          defaultexpire           : 3600
```
in rules you can send a message through pushover with the following code:
```
pushover("Laundry machine is finished")
```

#### Action mqtt
(I am using it with mqttwarn for sending messages, in the example beneath I use
it to signal me, the laundrymachine is fisnished)
Hiera
```
openhab_addons:
  action-pushover:
      configuration:
          id                    : 'raspi'
          url                   : 'tcp://localhost:1883'
```

Items file for sending a message:
```
String mqWas {mqtt=">[raspi:wasmachine/1:state:*:default]"}
```

in a rule:
```
postUpdate(mqWas, "was is klaar")
```

#### Binding zwave
Hiera
```
openhab_addons:
   binding-zwave:
       configuration:
           port                    : '/dev/ttyUSB0'
           healtime                : 2
           mastercontroller        : true
           setsuc                  : false
           softreset               : false
```

#### Binding http
Hiera
```
openhab_addons:
   binding-http:
       configuration:
           timeout                 : 500
           caches: []
```

#### Binding weather
Hiera
```
openhab_addons:
   binding-weather:
       configuration:
           locations:
               - id                : 'home'
                 name              : 'home'
                 latitude          : '0.0000'
                 longitude         : '0.0000'
                 woeid             : '123456'
                 provider          : 'Yahoo'
                 language          : 'de'
                 updateinterval    : '60'
           apikeys: []
```

#### Binding hue
Hiera
```
openhab_addons:
   binding-hue:
       configuration:
           ip                      : 'huebridge-ip-or-hostname'
           secret                  : 'openHABRuntime'
           refresh                 : '1000'
```

#### Binding astro
Hiera
```
openhab_addons:
   binding-astro:
       configuration:
           latitude                : '0.0000'
           longitude               : '0.0000'
           interval                : '600'
```

#### Binding sonos
Hiera
```
openhab_addons:
   binding-sonos:
       configuration:
           pollingperiod           : 1000
           hosts:
               - host              : 'kueche'
                 rinconuid         : 'RINCON_1234567'
               - host              : 'kind'
                 rinconuid         : 'RINCON_1234568'
```

#### Binding denon
Hiera
```
openhab_addons:
   binding-denon:
       configuration:
         update                    : 5000
         hosts:
             - host                : 'denon1'
               ip                  : '127.0.0.1'
               update              : 'telnet'
```

#### Persistence mysql
Hiera
```
openhab_addons:
   persistence-mysql:
       configuration:
           url                     : 'jdbc:mysql://127.0.0.1:3306/openhab'
           user                    : 'openhab'
           password                : 'openhab'
           waittimeout             : '30'
           reconnectcnt            : '5'
```

#### Persistence mongodb
Hiera
```
openhab_addons:
   persistence-mongodb:
       configuration:
           url                     : 'mongodb://127.0.0.1:27017'
           database                : 'openhab'
           collection              : 'openhab'
```

## Limitations

Currently you can use plugins from a different version but you are limited to a single
source for a version, you cant have by example 2 different 1.7.1 versions

## Development

Currently working on getting all the basics working. For lots of addons I do accept pull requests ;-)
If you prefer to have me writing the support for an addon, please create an issue on github.

### How to add new addons

In order to add new addons you need to create a template snippet like openhab-addon-[binding|action|io|persistence]-ADDONNAME-VERSION.cfg.erb
This is automatically concated when configuration data is set using hiera.
Hiera
```
openhab_addons:
   persistence-mypersistence:
       configuration:
           host                    : 'localhost'
           database                : 'openhab'
           my_array:
             - id                  : '1'
               name                : 'name1'
             - id                  : '2'
               name                : 'name2'
```
In the template you can use @configuration to access the data.

```
mypersistence:url=mypersistence://<%= @configuration['host'] -%>/<%= @configuration['database'] %>
# Creates:
#mypersistence:url=mypersistence://localhost/openhab

# Array Example
<% @configuration['my_array'].each do |data| -%>
mypersistence:<%= data['id'] -%>.name=<%= data['name'] %>
<% end -%>

# Creates:
mypersistence:1.name=name1
mypersistence:2.name=name2

```

### Todo
* test on centos/etc
* habmin is installed, but requires zwave addon, without it doesnt work, need to ensure a zwave addon is available
* lots of modules need their config in the openhab.cfg, so lots of work on the template. Please make issues for requests
* updating the documentation
* travis-ci and other testing
