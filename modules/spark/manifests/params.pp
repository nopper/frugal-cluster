class spark::params {
  include java::params

  $version = $::hostname ? {
    default => "0.8.0-incubating-bin-hadoop1",
  }

  $java_home = $::hostname ? {
    default => "${java::params::java_base}/jdk${java::params::java_version}",
  }

  $spark_base = $::hostname ? {
    default => "/opt/spark",
  }
}
