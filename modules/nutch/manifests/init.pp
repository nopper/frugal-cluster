class nutch {
  require hadoop
  require nutch::params

  Exec { path => "$path" }

  file {"$nutch::params::nutch_base":
    ensure => "directory",
    owner  => "hadoop",
    group  => "hadoop",
    alias  => "nutch-base",
  }

  file { "${nutch::params::nutch_base}/apache-nutch-${nutch::params::version}-src.tar.gz":
    mode    => 0644,
    owner   => "hadoop",
    group   => "hadoop",
    source  => "puppet:///modules/nutch/apache-nutch-${nutch::params::version}-src.tar.gz",
    alias   => "nutch-source-tgz",
    before  => Exec["untar-nutch"],
    require => File["nutch-base"]
  }

  file { "${nutch::params::nutch_base}/apache-nutch-1.7-src.tar.gz":
    mode    => 0644,
    owner   => "hadoop",
    group   => "hadoop",
    source  => "puppet:///modules/nutch/apache-nutch-1.7-src.tar.gz",
    before  => Exec["untar-nutch"],
    require => File["nutch-base"]
  }

  exec { "untar apache-nutch-${nutch::params::version}-src.tar.gz":
    command     => "tar -zxf apache-nutch-${nutch::params::version}-src.tar.gz && mv apache-nutch-${nutch::params::version} nutch-${nutch::params::version}",
    cwd         => "${nutch::params::nutch_base}",
    creates     => "${nutch::params::nutch_base}/nutch-${nutch::params::version}",
    alias       => "untar-nutch",
    refreshonly => true,
    subscribe   => File["nutch-source-tgz"],
    user        => "hadoop",
    before      => File["nutch-symlink"]
  }

  file { "${nutch::params::nutch_base}/nutch":
    force   => true,
    ensure  => "${nutch::params::nutch_base}/nutch-${nutch::params::version}",
    alias   => "nutch-symlink",
    owner   => "hadoop",
    group   => "hadoop",
    require => File["nutch-source-tgz"],
    before  => [ File["nutch-core-site-xml"], File["nutch-hdfs-site-xml"],
                 File["nutch-mapred-site-xml"], File["nutch-hadoop-env-sh"],
                 File["nutch-slaves"], File["nutch-masters"],
                 File["nutch-site-xml"], File["gora-cassandra-mapping-xml"],
                 File["gora-properties"], File["ivy-xml"] ],
  }

  exec { "patch_nutch":
    command => "sed -i 's/failed/isFailed/g' src/java/org/apache/nutch/indexer/elastic/ElasticWriter.java",
    onlyif  => "grep elasticsearch ivy/ivy.xml | grep 0.90.5",
    user    => "hadoop",
    cwd     => "${nutch::params::nutch_base}/nutch-${nutch::params::version}",
    #before  => Exec["build_nutch"],
    require => File["ivy-xml"],
  }

  # exec { "build_nutch":
  #   command => "ant runtime",
  #   user    => "hadoop",
  #   cwd     => "${nutch::params::nutch_base}/nutch-${nutch::params::version}",
  #   require => [ File["nutch-core-site-xml"], File["nutch-hdfs-site-xml"],
  #                File["nutch-mapred-site-xml"], File["nutch-hadoop-env-sh"],
  #                File["nutch-slaves"], File["nutch-masters"],
  #                File["nutch-site-xml"], File["gora-cassandra-mapping-xml"],
  #                File["gora-properties"], File["ivy-xml"] ],
  # }

  # Files in common with hadoop

  file { "${nutch::params::nutch_base}/nutch-${nutch::params::version}/conf/core-site.xml":
    owner   => "hadoop",
    group   => "hadoop",
    mode    => "644",
    alias   => "nutch-core-site-xml",
    content => template("hadoop/conf/core-site.xml.erb"),
  }

  file { "${nutch::params::nutch_base}/nutch-${nutch::params::version}/conf/hdfs-site.xml":
    owner   => "hadoop",
    group   => "hadoop",
    mode    => "644",
    alias   => "nutch-hdfs-site-xml",
    content => template("hadoop/conf/hdfs-site.xml.erb"),
  }

  file { "${nutch::params::nutch_base}/nutch-${nutch::params::version}/conf/hadoop-env.sh":
    owner   => "hadoop",
    group   => "hadoop",
    mode    => "644",
    alias   => "nutch-hadoop-env-sh",
    content => template("hadoop/conf/hadoop-env.sh.erb"),
  }

  file { "${nutch::params::nutch_base}/nutch-${nutch::params::version}/conf/mapred-site.xml":
    owner   => "hadoop",
    group   => "hadoop",
    mode    => "644",
    alias   => "nutch-mapred-site-xml",
    content => template("hadoop/conf/mapred-site.xml.erb"),
  }

  file { "${nutch::params::nutch_base}/nutch-${nutch::params::version}/conf/slaves":
    owner   => "hadoop",
    group   => "hadoop",
    mode    => "644",
    alias   => "nutch-slaves",
    content => template("hadoop/conf/slaves.erb"),
  }

  file { "${nutch::params::nutch_base}/nutch-${nutch::params::version}/conf/masters":
    owner   => "hadoop",
    group   => "hadoop",
    mode    => "644",
    alias   => "nutch-masters",
    content => template("hadoop/conf/masters.erb"),
  }

  # Configuration file

  file { "${nutch::params::nutch_base}/nutch-${nutch::params::version}/conf/nutch-site.xml":
    mode    => 644,
    owner   => "hadoop",
    group   => "hadoop",
    alias   => "nutch-site-xml",
    content => template("nutch/conf/nutch-site.xml.erb"),
  }

  # Cassandra backend

  file { "${nutch::params::nutch_base}/nutch-${nutch::params::version}/conf/gora-cassandra-mapping.xml":
    mode    => 644,
    owner   => "hadoop",
    group   => "hadoop",
    alias   => "gora-cassandra-mapping-xml",
    content => template("nutch/conf/gora-cassandra-mapping.xml.erb"),
  }

  file { "${nutch::params::nutch_base}/nutch-${nutch::params::version}/conf/gora.properties":
    mode    => 644,
    owner   => "hadoop",
    group   => "hadoop",
    alias   => "gora-properties",
    content => template("nutch/conf/gora.properties.erb"),
  }

  file { "${nutch::params::nutch_base}/nutch-${nutch::params::version}/ivy/ivy.xml":
    mode    => 644,
    owner   => "hadoop",
    group   => "hadoop",
    alias   => "ivy-xml",
    content => template("nutch/ivy/ivy.xml.erb"),
  }
}
