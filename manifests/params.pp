class tuned::params {
  $enabled = true
  $packages = ['tuned']
  $sleep_interval = 1
  $update_interval = 10

  if ('tuned_version' in $facts) and $facts['tuned_version'] =~ /^(\d+)\.[\d\.]+$/ {
    $_majversion = $1
  } else {
    $_majversion = undef
  }

  case $facts['os']['name'] {
    'Fedora': {
      $majversion = pick($_majversion, '2')
      $dynamic_tuning = true
      $main_conf = '/etc/tuned/tuned-main.conf'
      $services = ['tuned']
      $profile = '' #autodetect
      $profiles_path = '/etc/tuned'
      $active_profile_conf = 'active_profile'
    }

    'RedHat','CentOS','Scientific','OracleLinux': {
      case $facts['os']['release']['major'] {
        '6': {
          $majversion = pick($_majversion, '0')
          $dynamic_tuning = false
          $main_conf = '' # unsupported
          $services = ['tuned', 'ktune']
          $profile = 'default'
          $profiles_path = '/etc/tune-profiles'
          $active_profile_conf = 'active-profile'
        }

        /7|8/: {
          $majversion = pick($_majversion, '2')
          $dynamic_tuning = false
          $main_conf = '/etc/tuned/tuned-main.conf'
          $services = ['tuned']
          $profile = '' #autodetect
          $profiles_path = '/etc/tuned'
          $active_profile_conf = 'active_profile'
        }

        default: {
          fail("Unsupported OS release: \
${facts['os']['name']} ${facts['os']['release']['major']}")
        }
      }
    }

    default: {
      fail("Unsupported OS: ${facts['os']['name']}")
    }
  }
}
