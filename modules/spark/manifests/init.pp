class spark {
  require hadoop
  require spark::params

  Exec { path => "${path}" }

  file {"${spark::params::spark_base}":
    owner  => "hadoop",
    group  => "hadoop",
    alias  => "spark-base",
    ensure => "directory",
  }

  file { "${spark::params::spark_base}/spark-${spark::params::version}.tgz":
    mode    => 0644,
    owner   => "hadoop",
    group   => "hadoop",
    source  => "puppet:///modules/spark/spark-${spark::params::version}.tgz",
    alias   => "spark-source-tgz",
    before  => Exec["untar-spark"],
    require => File["spark-base"]
  }

  exec { "untar spark-${spark::params::version}.tgz":
    command     => "tar -zxf spark-${spark::params::version}.tgz",
    cwd         => "${spark::params::spark_base}",
    creates     => "${spark::params::spark_base}/spark-${spark::params::version}",
    alias       => "untar-spark",
    refreshonly => true,
    subscribe   => File["spark-source-tgz"],
    user        => "hadoop",
    before      => File["spark-symlink"]
  }

  file { "${spark::params::spark_base}/spark":
    force   => true,
    ensure  => "${spark::params::spark_base}/spark-${spark::params::version}",
    alias   => "spark-symlink",
    owner   => "hadoop",
    group   => "hadoop",
    require => File["spark-source-tgz"],
    before  => File["spark-slaves"],
  }

  file { "${spark::params::spark_base}/spark-${spark::params::version}/conf/slaves":
    owner   => "hadoop",
    group   => "hadoop",
    mode    => "644",
    alias   => "spark-slaves",
    content => template("hadoop/conf/slaves.erb"),
  }
}
