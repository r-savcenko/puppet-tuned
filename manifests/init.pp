class tuned (
  $enabled             = $tuned::params::enabled,
  $profile             = $tuned::params::profile,
  $dynamic_tuning      = $tuned::params::dynamic_tuning,
  $sleep_interval      = $tuned::params::sleep_interval,
  $update_interval     = $tuned::params::update_interval,
  $majversion          = $tuned::params::majversion,
  $main_conf           = $tuned::params::main_conf,
  $profiles_path       = $tuned::params::profiles_path,
  $active_profile_conf = $tuned::params::active_profile_conf,
  $packages            = $tuned::params::packages,
  $services            = $tuned::params::services
) inherits tuned::params {

  validate_bool($enabled, $dynamic_tuning)
  validate_array($packages, $services)
  validate_string($profile, $active_profile_conf)
  validate_integer($sleep_interval, $update_interval)
  validate_absolute_path($profiles_path)

  if !empty($main_conf) {
    validate_absolute_path($main_conf)
  }

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
