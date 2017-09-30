class tuned (
  Boolean $enabled                                               = $tuned::params::enabled,
  String $profile                                                = $tuned::params::profile,
  Boolean $dynamic_tuning                                        = $tuned::params::dynamic_tuning,
  Integer $sleep_interval                                        = $tuned::params::sleep_interval,
  Integer $update_interval                                       = $tuned::params::update_interval,
  String $majversion                                             = $tuned::params::majversion,
  Variant[Stdlib::Compat::Absolute_path, String[0,0]] $main_conf = $tuned::params::main_conf,
  Stdlib::Compat::Absolute_path $profiles_path                   = $tuned::params::profiles_path,
  String $active_profile_conf                                    = $tuned::params::active_profile_conf,
  Array $packages                                                = $tuned::params::packages,
  Array $services                                                = $tuned::params::services
) inherits tuned::params {

  class { 'tuned::install':
    enabled  => $enabled,
    packages => $packages,
  }

  class { 'tuned::service':
    enabled  => $enabled,
    services => $services,
  }

  if $enabled {
    class { 'tuned::config':
      profile             => $profile,
      dynamic_tuning      => $dynamic_tuning,
      sleep_interval      => $sleep_interval,
      update_interval     => $update_interval,
      main_conf           => $main_conf,
      profiles_path       => $profiles_path,
      active_profile_conf => $active_profile_conf,
    }

    anchor { 'tuned::begin': ; }
      -> Class['tuned::install']
      -> Class['tuned::config']
      -> Class['tuned::service']
      -> anchor { 'tuned::end': ; }

    Class['tuned::install']
      ~> Class['tuned::service']
  } else {
    anchor { 'tuned::begin': ; }
      -> Class['tuned::service']
      -> Class['tuned::install']
      -> anchor { 'tuned::end': ; }
  }
}
