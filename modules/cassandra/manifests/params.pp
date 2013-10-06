class cassandra::params {
  include java::params

  $java_home = $::hostname ? {
    default => "${java::params::java_base}/jdk${java::params::java_version}",
  }

  $version = $::hostname ? {
    default => "2.0.1",
  }

  $cassandra_base = $::hostname ? {
    default => "/opt/cassandra",
  }

  $data_path = $::hostname ? {
    default => "/home/cassandra/data",
  }

  $commitlog_directory = $::hostname ? {
    default => "/home/cassandra/commitlog",
  }

  $saved_caches = $::hostname ? {
    default => "/home/cassandra/saved_caches",
  }

  $cluster_name = $::hostname ? {
    default => "Frugal Cluster",
  }

  $seeds = $::hostname ? {
    default => "node0, node1, node2, node3",
  }

  $cassandra_log_path = $::hostname ? {
    default => "/var/log/cassandra",
  }
}
