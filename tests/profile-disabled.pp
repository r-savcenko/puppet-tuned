class { 'tuned':
  enabled => false,
  profile => 'smoke-test',
}

tuned::profile { 'smoke-test':
  ensure => absent,
}
