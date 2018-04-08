class tuned::config {
  $_active_profile_fn = "${tuned::profiles_path}/${tuned::active_profile_conf}"

  # if no profile specified, tuned will detect suitable
  if ! empty($tuned::profile) {
    exec { 'tuned-adm_profile':
      command => shellquote('tuned-adm', 'profile', $tuned::profile),
      unless  => shellquote('grep', '-Fqx', $tuned::profile, $_active_profile_fn),
      path    => '/bin:/usr/bin:/sbin:/usr/sbin',
    }
  }

  if ! empty($tuned::main_conf) {
    Ini_setting {
      path    => $tuned::main_conf,
      section => '',
      notify  => Class['tuned::service'],
    }

    if ! empty($tuned::profile) {
      Ini_setting {
        before => Exec['tuned-adm_profile'],
      }
    }

    $_dynamic_tuning = bool2num($tuned::dynamic_tuning)
    ini_setting { 'tuned-dynamic_tuning':
      setting => 'dynamic_tuning',
      value   => $_dynamic_tuning,
    }

    ini_setting { 'tuned-sleep_interval':
      setting => 'sleep_interval',
      value   => $tuned::sleep_interval,
    }

    ini_setting { 'tuned-update_interval':
      setting => 'update_interval',
      value   => $tuned::update_interval,
    }
  }
}
