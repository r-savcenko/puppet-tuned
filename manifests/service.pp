class tuned::service {
  $_ensure = $tuned::enabled ? {
    true  => running,
    false => stopped,
  }

  service { $tuned::services:
    ensure => $_ensure,
    enable => $tuned::enabled,
  }
}
