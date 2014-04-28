class quickstack::pacemaker::stonith::ipmilan (
  $address         = "10.10.10.1",
  $username        = "",
  $password        = "",
  $interval        = "60s",
  $ensure          = "present",
  $lanplus         = false,
  $lanplus_options = '',
  $pcmk_host_list ="",
  ) {

  if($ensure == absent) {
    exec { "Removing stonith::ipmilan ${address}":
      command => "/usr/sbin/pcs stonith delete stonith-ipmilan-${address}",
      onlyif  => "/usr/sbin/pcs stonith show stonith-ipmilan-${address} > /dev/null 2>&1",
      require => Class['pacemaker::corosync'],
    }
  } else {
    $username_chunk = $username ? {
      ''      => '',
      default => "login=${username}",
    }
    $password_chunk = $password ? {
      ''      => '',
      default => "passwd=${password}",
    }
    $pcmk_host_list_chunk = $pcmk_host_list ? {
      ''      => 'pcmk_host_list="$(/usr/sbin/crm_node -n)"',
      default => "pcmk_host_list=\"${pcmk_host_list}\"",
    }
    $lanplus_chunk = $lanplus ? {
      false   => '',
      ''      => '',
      default => "lanplus=\"${lanplus_options}\"",
    }

    package { "ipmitool":
      ensure => installed,
    } ->
    exec { "Creating stonith::ipmilan ${address}":
      command => "/usr/sbin/pcs stonith create stonith-ipmilan-${address} fence_ipmilan ${pcmk_host_list_chunk} ipaddr=${address} ${username_chunk} ${password_chunk} ${lanplus_chunk} op monitor interval=${interval}",
      unless  => "/usr/sbin/pcs stonith show stonith-ipmilan-${address} > /dev/null 2>&1",
      require => Class['pacemaker::corosync'],
    }
  }
}
