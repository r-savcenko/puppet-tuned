class tuned::install {
  $_ensure = $tuned::enabled ? {
    true  => present,
    false => absent
  }

  package { $tuned::packages:
    ensure => $_ensure,
  }
}
