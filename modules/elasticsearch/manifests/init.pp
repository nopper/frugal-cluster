class elasticsearch {
  require elasticsearch::params

  Exec { path => "$path" }

  group { "elasticsearch":
    ensure => present,
    gid    => "600",
  }

  user { "elasticsearch":
    ensure   => present,
    comment  => "Elasticsearch",
    password => "!!",
    uid      => "600",
    gid      => "600",
    shell    => "/bin/bash",
    home     => "/home/elasticsearch",
    require  => Group["elasticsearch"],
  }

  file { "/home/elasticsearch":
    ensure  => "directory",
    owner   => "elasticsearch",
    group   => "elasticsearch",
    alias   => "elasticsearch-home",
    require => [ User["elasticsearch"], Group["elasticsearch"] ],
  }

  file { "/home/elasticsearch/.bash_profile":
    ensure  => "present",
    owner   => "elasticsearch",
    group   => "elasticsearch",
    alias   => "elasticsearch-bash_profile",
    content => template("elasticsearch/home/bash_profile.erb"),
    require => User["elasticsearch"]
  }

  file {"$elasticsearch::params::elasticsearch_base":
    ensure => "directory",
    owner  => "elasticsearch",
    group  => "elasticsearch",
    alias  => "elasticsearch-base",
  }

  file { "${elasticsearch::params::elasticsearch_base}/elasticsearch-${elasticsearch::params::version}.tar.gz":
    mode    => 0644,
    owner   => "elasticsearch",
    group   => "elasticsearch",
    source  => "puppet:///modules/elasticsearch/elasticsearch-${elasticsearch::params::version}.tar.gz",
    alias   => "elasticsearch-source-tgz",
    before  => Exec["untar-elasticsearch"],
    require => File["elasticsearch-base"]
  }

  exec { "untar elasticsearch-${elasticsearch::params::version}.tar.gz":
    command     => "tar -zxf elasticsearch-${elasticsearch::params::version}.tar.gz",
    cwd         => "${elasticsearch::params::elasticsearch_base}",
    creates     => "${elasticsearch::params::elasticsearch_base}/elasticsearch-${elasticsearch::params::version}",
    alias       => "untar-elasticsearch",
    refreshonly => true,
    subscribe   => File["elasticsearch-source-tgz"],
    user        => "elasticsearch",
    before      => File["elasticsearch-symlink"]
  }

  file { "${elasticsearch::params::elasticsearch_base}/elasticsearch":
    force   => true,
    ensure  => "${elasticsearch::params::elasticsearch_base}/elasticsearch-${elasticsearch::params::version}",
    alias   => "elasticsearch-symlink",
    owner   => "elasticsearch",
    group   => "elasticsearch",
    require => File["elasticsearch-source-tgz"],
    before  => File["elasticsearch-conf"]
  }

  file { "${elasticsearch::params::elasticsearch_base}/elasticsearch-${elasticsearch::params::version}/config/elasticsearch.yml":
    owner   => "elasticsearch",
    group   => "elasticsearch",
    mode    => "644",
    alias   => "elasticsearch-conf",
    content => template("elasticsearch/conf/elasticsearch.yml.erb"),
  }

  exec { "elasticsearch_head":
    command => "${elasticsearch::params::elasticsearch_base}/elasticsearch/bin/plugin -install mobz/elasticsearch-head",
    creates => "${elasticsearch::params::elasticsearch_base}/elasticsearch/plugins/head",
    path    => "${elasticsearch::params::java_home}/bin/:${path}",
    require => File["elasticsearch-symlink"],
    user    => "elasticsearch",
  }

  exec { "elasticsearch_paramedic":
    command => "${elasticsearch::params::elasticsearch_base}/elasticsearch/bin/plugin -install karmi/elasticsearch-paramedic",
    creates => "${elasticsearch::params::elasticsearch_base}/elasticsearch/plugins/paramedic",
    path    => "${elasticsearch::params::java_home}/bin/:${path}",
    require => File["elasticsearch-symlink"],
    user    => "elasticsearch",
  }
}
