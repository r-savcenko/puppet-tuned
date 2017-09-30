class tuned::config (
  $profile,
  $dynamic_tuning,
  $sleep_interval,
  $update_interval,
  $main_conf,
  Stdlib::Compat::Absolute_path $profiles_path,
  $active_profile_conf,
) {
  $_active_profile_fn = "${profiles_path}/${active_profile_conf}"

  # if no profile specified, tuned will detect suitable
  if ! empty($profile) {
    exec { 'tuned-adm_profile':
      command => shellquote('tuned-adm', 'profile', $profile),
      unless  => shellquote('grep', '-Fqx', $profile, $_active_profile_fn),
      path    => '/bin:/usr/bin:/sbin:/usr/sbin',
    }
  }

  if ! empty($main_conf) {
    Ini_setting {
      path    => $main_conf,
      section => '',
      notify  => Class['tuned::service'],
    }

    if ! empty($profile) {
      Ini_setting {
        before => Exec['tuned-adm_profile'],
      }
    }

    $_dynamic_tuning = bool2num($dynamic_tuning)
    ini_setting { 'tuned-dynamic_tuning':
      setting => 'dynamic_tuning',
      value   => $_dynamic_tuning,
    }

    ini_setting { 'tuned-sleep_interval':
      setting => 'sleep_interval',
      value   => $sleep_interval,
    }

    ini_setting { 'tuned-update_interval':
      setting => 'update_interval',
      value   => $update_interval,
    }
  }
}
