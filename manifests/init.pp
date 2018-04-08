class tuned (
  Boolean $enabled                                               = $tuned::params::enabled,
  String $profile                                                = $tuned::params::profile,
  Boolean $dynamic_tuning                                        = $tuned::params::dynamic_tuning,
  Integer $sleep_interval                                        = $tuned::params::sleep_interval,
  Integer $update_interval                                       = $tuned::params::update_interval,
  String $majversion                                             = $tuned::params::majversion,
  Variant[Stdlib::Compat::Absolute_path, String[0,0]] $main_conf = $tuned::params::main_conf,
  Stdlib::Absolutepath $profiles_path                            = $tuned::params::profiles_path,
  String $active_profile_conf                                    = $tuned::params::active_profile_conf,
  Array[String, 1] $packages                                     = $tuned::params::packages,
  Array[String, 1] $services                                     = $tuned::params::services
) inherits tuned::params {

  contain tuned::install
  contain tuned::service

  if $enabled {
    contain tuned::config

    Class['tuned::install']
      -> Class['tuned::config']
      -> Class['tuned::service']

    Class['tuned::install']
      ~> Class['tuned::service']
  } else {
    Class['tuned::service']
      -> Class['tuned::install']
  }
}
