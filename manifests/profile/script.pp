define tuned::profile::script (
  $ensure,
  $profile_dir,
  $scripts,
  $script_name = $title,
) {
  validate_hash($scripts)
  validate_absolute_path($profile_dir)
  validate_re($script_name, '^[\w\-\.]+$')

  $_content = $scripts[$script_name]
  validate_string($_content)

  case $ensure {
    present: { $_ensure = file }
    absent:  { $_ensure = absent }
    default: { fail("Unsupported ensure state '${ensure}'") }
  }

  file { "${profile_dir}/${script_name}":
    ensure  => $_ensure,
    content => $_content,
    mode    => '0755',
  }
}
