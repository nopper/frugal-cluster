class elasticsearch::params {
  include java::params

  $version = $::hostname ? {
    default => "0.90.5",
  }

  $java_home = $::hostname ? {
    default => "${java::params::java_base}/jdk${java::params::java_version}",
  }

  $elasticsearch_base = $::hostname ? {
    default => "/opt/elasticsearch",
  }

  $cluster_name = $::hostname ? {
    default => "elasticsearch",
  }

  $seeds = $::hostname ? {
    default => ["node0", "node1", "node2", "node3"],
  }
}
