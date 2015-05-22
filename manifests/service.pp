class tuned::service (
  $enabled,
  $services
) {
  $_ensure = $enabled ? {
    true  => running,
    false => stopped,
  }

  service { $services:
    ensure => $_ensure,
    enable => $enabled,
  }
}
