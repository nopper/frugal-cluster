class hadoop {
  require hadoop::params

  Exec { path => "$path" }

  group { "hadoop":
    ensure => present,
    gid    => "800",
  }

  user { "hadoop":
    ensure   => present,
    comment  => "Hadoop",
    password => "!!",
    uid      => "800",
    gid      => "800",
    shell    => "/bin/bash",
    home     => "/home/hadoop",
    require  => Group["hadoop"],
  }

  file { "/home/hadoop":
    ensure  => "directory",
    owner   => "hadoop",
    group   => "hadoop",
    alias   => "hadoop-home",
    require => [ User["hadoop"], Group["hadoop"] ],
  }

  file { "/home/hadoop/.bash_profile":
    ensure  => "present",
    owner   => "hadoop",
    group   => "hadoop",
    alias   => "hadoop-bash_profile",
    content => template("hadoop/home/bash_profile.erb"),
    require => User["hadoop"]
  }

  file {"$hadoop::params::hdfs_path":
    ensure  => "directory",
    owner   => "hadoop",
    group   => "hadoop",
    alias   => "hdfs-dir",
    require => File["hadoop-home"]
  }

  file {"$hadoop::params::hdfs_data_path":
    ensure  => "directory",
    owner   => "hadoop",
    group   => "hadoop",
    alias   => "hdfs-data-dir",
    require => File["hadoop-home"]
  }

  file {"$hadoop::params::hdfs_name_path":
    ensure  => "directory",
    owner   => "hadoop",
    group   => "hadoop",
    alias   => "hdfs-name-dir",
    require => File["hadoop-home"]
  }

  file {"$hadoop::params::hadoop_base":
    ensure => "directory",
    owner  => "hadoop",
    group  => "hadoop",
    alias  => "hadoop-base",
  }

  file { "${hadoop::params::hadoop_base}/hadoop-${hadoop::params::version}-bin.tar.gz":
    mode    => 0644,
    owner   => hadoop,
    group   => hadoop,
    source  => "puppet:///modules/hadoop/hadoop-${hadoop::params::version}-bin.tar.gz",
    alias   => "hadoop-source-tgz",
    before  => Exec["untar-hadoop"],
    require => File["hadoop-base"]
  }

  exec { "untar hadoop-${hadoop::params::version}-bin.tar.gz":
    command     => "tar -zxf hadoop-${hadoop::params::version}-bin.tar.gz",
    cwd         => "${hadoop::params::hadoop_base}",
    creates     => "${hadoop::params::hadoop_base}/hadoop-${hadoop::params::version}",
    alias       => "untar-hadoop",
    refreshonly => true,
    subscribe   => File["hadoop-source-tgz"],
    user        => "hadoop",
    before      => File["hadoop-symlink"]
  }

  file { "${hadoop::params::hadoop_base}/hadoop":
    force   => true,
    ensure  => "${hadoop::params::hadoop_base}/hadoop-${hadoop::params::version}",
    alias   => "hadoop-symlink",
    owner   => "hadoop",
    group   => "hadoop",
    require => File["hadoop-source-tgz"],
    before  => [ File["core-site-xml"], File["hdfs-site-xml"],
                 File["mapred-site-xml"], File["hadoop-env-sh"],
                 File["masters"], File["slaves"] ]
  }

  file { "${hadoop::params::hadoop_base}/hadoop-${hadoop::params::version}/conf/core-site.xml":
    owner   => "hadoop",
    group   => "hadoop",
    mode    => "644",
    alias   => "core-site-xml",
    content => template("hadoop/conf/core-site.xml.erb"),
  }

  file { "${hadoop::params::hadoop_base}/hadoop-${hadoop::params::version}/conf/hdfs-site.xml":
    owner   => "hadoop",
    group   => "hadoop",
    mode    => "644",
    alias   => "hdfs-site-xml",
    content => template("hadoop/conf/hdfs-site.xml.erb"),
  }

  file { "${hadoop::params::hadoop_base}/hadoop-${hadoop::params::version}/conf/hadoop-env.sh":
    owner   => "hadoop",
    group   => "hadoop",
    mode    => "644",
    alias   => "hadoop-env-sh",
    content => template("hadoop/conf/hadoop-env.sh.erb"),
  }

  file { "${hadoop::params::hadoop_base}/hadoop-${hadoop::params::version}/conf/mapred-site.xml":
    owner   => "hadoop",
    group   => "hadoop",
    mode    => "644",
    alias   => "mapred-site-xml",
    content => template("hadoop/conf/mapred-site.xml.erb"),
  }

  # Master and slaves configuration files

  file { "${hadoop::params::hadoop_base}/hadoop-${hadoop::params::version}/conf/slaves":
    owner   => "hadoop",
    group   => "hadoop",
    mode    => "644",
    alias   => "slaves",
    content => template("hadoop/conf/slaves.erb"),
  }

  file { "${hadoop::params::hadoop_base}/hadoop-${hadoop::params::version}/conf/masters":
    owner   => "hadoop",
    group   => "hadoop",
    mode    => "644",
    alias   => "masters",
    content => template("hadoop/conf/masters.erb"),
  }

  # Passwordless SSH

  file { "/home/hadoop/.ssh":
    ensure => "directory",
    owner  => "hadoop",
    group  => "hadoop",
    mode   => 600,
  }

  file { "/home/hadoop/.ssh/id_rsa":
    source  => "puppet:///modules/hadoop/id_rsa",
    mode    => 600,
    owner   => "hadoop",
    group   => "hadoop",
  }

  file { "/home/hadoop/.ssh/id_rsa.pub":
    source  => "puppet:///modules/hadoop/id_rsa.pub",
    mode    => 644,
    owner   => "hadoop",
    group   => "hadoop",
  }

  ssh_authorized_key { "ssh_key":
    ensure => "present",
    key    => "AAAAB3NzaC1yc2EAAAADAQABAAABAQCjUcbrZU8n7NNvUdcc1kkMBtVQYpZtT7ojpGtwE34Qc6NYtfM3mVYxgABxueTtC4qL9aenrOFQ2WkTFoHbPd+LDPHuCUjhSwLrp4I0A/kH+dAyggrMxlUbkPYuBTXD80NUj4A9sBJE6NHtKT8e2VZ56ryAF6RHF19biBk49LrA3skw2Y3OvsMOGD1Ap0hL7f5lYanrLLNlZrwqsNGKCRhCzEzC7hLjF8pAL0/IcnzM4LVS64UCafYO/fKbsai5FWfYn1S4m7ZTxn/a0IM+BfD6P5Ev6D5VZH3gsgeRmDV9o6XgjaXJSCNJlsvcvQcBphjrZCZYbbG/J23C3EHn9xxL",
    type   => "ssh-rsa",
    user   => "hadoop",
    require => File['/home/hadoop/.ssh/id_rsa.pub']
  }
}
