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
7. [Release notes - whats in the updates](#release-notes)    

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

I am using plugin sync, not tested it without.


### Beginning with openhab

Get an Rpi with raspbian and use it :-) also normal debian should work,
java is auto installed by using puppetlabs-java, disable it by setting $install_java  to false.

## Usage

### Hiera
My hiera file currenty looks like this:
```
---
openhab::personalconfigmodule             : openhab-personal
openhab::security_netmask                 : 10.0.1.0/24
openhab::binding_denon_id                 : sr7005
openhab::binding_denon_host               : 10.0.1.125
openhab::binding_denon_update             : telnet
openhab::binding_mqtt_id                  : raspi
openhab::binding_mqtt_url                 : tcp://localhost:1883
openhab::persistence_mysql_user           : openhab
openhab::persistence_mysql_password       : openhab
openhab::persistence_mysql_url            : jdbc:mysql://127.0.0.1:3306/openhab
openhab::persistence_mysql_waitTimeout    : 30
openhab::persistence_mysql_reconnectCnt   : 5

openhab_addons:
    binding.mqtt:
        addon_version: "1.7.1"
    binding.denon:
        addon_version: "1.8.0-SNAPSHOT"
        sourceurl:     "https://openhab.ci.cloudbees.com/job/openHAB/lastSuccessfulBuild/artifact/distribution/target/"
    binding.zwave: {}
    io.myopenhab: {}
...
```
### Using your own items/rules/sitemaps/etc
To use your own item/rules/sitemaps/etc files, you need to set the variable openhab::personalconfigmodule. In this
variable you place the name of the folder name of the module that contains the files. In my case that is openhab-personal.
In the module directory, you need a directory named files with subdirectories items, rules and sitemaps.

## Reference

I use it with the profiles and roles pattern, will post examples in the future

## Limitations

Currently you can use plugins from a different version but you are limited to a single
source for a version, you cant have by example 2 different 1.7.1 versions

## Development

Currently working on getting all the basics working. For lots of addons I do accept pull requests ;-)
If you prefer to have me writing the support for an addon, please create an issue on github.

### Todo
* habmin support
* fixing the custom facts for myopenhab uuid/secret (can use some help)
* java is now in a seperate profile for me, but need to mention it somewhere
* test on centos/etc
