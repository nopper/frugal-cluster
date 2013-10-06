class hadoop::params {
  include java::params

  $version = $::hostname ? {
    default => "1.2.1",
  }

  $master = $::hostname ? {
    default => "10.31.33.70",
  }

  $hdfsport = $::hostname ? {
    default => "9000",
  }

  $replication = $::hostname ? {
    default => "2",
  }

  $jobtrackerport = $::hostname ? {
    default => "9001",
  }

  $java_home = $::hostname ? {
    default => "${java::params::java_base}/jdk${java::params::java_version}",
  }

  $hadoop_base = $::hostname ? {
    default => "/opt/hadoop",
  }

  $hdfs_path = $::hostname ? {
    default => "/home/hadoop/hdfs",
  }

  $hdfs_name_path = $::hostname ? {
    default => "/home/hadoop/hdfs/name",
  }

  $hdfs_data_path = $::hostname ? {
    default => "/home/hadoop/hdfs/data",
  }

  # Secondary name nodes, this might be misleading
  $masters = $::hostname ? {
    default => "",
  }

  $slaves = $::hostname ? {
    default => ["10.31.33.70", "10.31.33.71", "10.31.33.72", "10.31.33.73"]
  }
}
