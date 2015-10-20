class tuned::install (
  $enabled,
  $packages
) {
  $_ensure = $enabled ? {
    true  => present,
    false => absent
  }

  package { $packages:
    ensure => $_ensure,
    notify => Class['tuned::service'],
  }
}
