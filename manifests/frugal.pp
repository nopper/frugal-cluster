include java
include hadoop
include cassandra
include nutch
include elasticsearch
include spark

group { "puppet":
  ensure => "present",
}

exec { 'apt-get update':
  command => '/usr/bin/apt-get update',
}

package { "tmux":
  ensure  => present,
  require => Exec['apt-get update'],
}

#package { "ant":
#  ensure => present,
#  require => Exec['apt-get update']
#}

package { "vim-nox":
  ensure  => present,
  require => Exec['apt-get update'],
}

# Host configurations

file { "/etc/hosts":
  source => "puppet:///modules/hadoop/hosts",
  owner  => "root",
  group  => "root",
  mode   => 644,
  require => Exec['apt-get update']
}
