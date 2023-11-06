define tuned::profile::script (
  Enum['present', 'absent'] $ensure,
  Stdlib::Absolutepath $profile_dir,
  Hash[String, String] $scripts,
  Pattern[/^[\w\-\.]+$/] $script_name = $title,
) {
  unless ($script_name in $scripts) {
    fail("Missing content for script ${script_name}")
  }

  $_ensure = $ensure ? {
    present => file,
    absent  => absent,
  }

  file { "${profile_dir}/${script_name}":
    ensure  => $_ensure,
    content => $scripts[$script_name],
    mode    => '0755',
  }
}
