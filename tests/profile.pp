$data = {
  'main' => {
    'include' => 'balanced'
  },
  'sysctl' => {
    'net.ipv4.tcp_rmem' => '4096 87380 16777216',
    'net.ipv4.tcp_wmem' => '4096 16384 16777216',
    'net.ipv4.udp_mem' => '3145728 4194304 16777216',
    'kernel.sched_min_granularity_ns' => 10000000,
    'kernel.sched_wakeup_granularity_ns' => 15000000,
    'vm.dirty_ratio' => 40,
    'vm.dirty_background_ratio' => 10,
    'vm.swappiness' => 10,
  },
  'disk' => {
    'readahead' => '>4096',
  },
  'vm' => {
    'transparent_hugepages' => 'always',
  },
  'cpu' => {
    'governor' => 'performance',
    'energy_perf_bias' => 'performance',
    'min_perf_pct' => 100,
  },
  'script1' => {
    'type'   => 'script',
    'script' => 'script1.sh',
  },
  'script2' => {
    'type'   => 'script',
    'script' => 'script2.sh',
  },
}

$scripts = {
  'script1.sh' => "#!/bin/bash\n/bin/true",
  'script2.sh' => "#!/bin/bash\n/bin/true",
}

###

class { 'tuned':
  profile => 'smoke-test',
}

tuned::profile { 'smoke-test':
  data    => $data,
  scripts => $scripts,
}
