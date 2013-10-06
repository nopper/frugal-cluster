class nutch::params {
  include java::params
  include hadoop::params

  $version = $::hostname ? {
    default => "2.2.1",
  }

  $elasticsearch_version = $::hostname ? {
    default => "0.90.5",
  }

  $agent_name = $::hostname ? {
    default => "FrugalBot"
  }

  $cassandra_nodes = $::hostname ? {
    default => "node0:9160"
  }

  $java_home = $::hostname ? {
    default => "${java::params::java_base}/jdk${java::params::java_version}",
  }

  $nutch_base = $::hostname ? {
    default => "/opt/nutch",
  }
}
