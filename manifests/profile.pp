define tuned::profile (
  Pattern[/^[\w\-]+$/] $profile_name                                = $title,
  Enum['present', 'absent'] $ensure                                 = present,
  Hash[String[1], Hash[String[1],Variant[String[1],Numeric]]] $data = {},
  Hash[Pattern[/^[\w\-\.]+$/], String[1]] $scripts                  = {},
  Stdlib::Absolutepath $profiles_path                               = $tuned::profiles_path
) {
  if $tuned::majversion != '2' {
    fail('Profiles unsupported for this tuned version')
  }

  $_profile_dir = "${profiles_path}/${profile_name}"

  case $ensure {
    present: {
      # if we update current profile, reload daemon
      if $profile_name == $tuned::profile {
        File["${_profile_dir}/tuned.conf"]
          ~> Class['tuned::service']

        Tuned::Profile::Script {
          notify => Class['tuned::service']
        }
      }

      file { $_profile_dir:
        ensure  => directory,
        require => Class['tuned::install'],
      }

      file { "${_profile_dir}/tuned.conf":
        ensure  => file,
        content => template("${module_name}/tuned.conf.erb"),
        before  => Class['tuned::config'],
      }

      $_script_names = keys($scripts)
      if length($_script_names) > 0 {
        tuned::profile::script { $_script_names:
          ensure      => $ensure,
          scripts     => $scripts,
          profile_dir => $_profile_dir,
        }
      }
    }

    absent: {
      file { $_profile_dir:
        ensure  => absent,
        recurse => true,
        force   => true,
      }
    }

    default: {
      fail("Unsupported ensure state ${ensure}")
    }
  }
}
