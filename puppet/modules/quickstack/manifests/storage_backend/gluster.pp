# quickstack storage class
class quickstack::storage_backend::gluster(
  $cinder_gluster_path          = $quickstack::params::cinder_gluster_path,
  $cinder_gluster_peers         = $quickstack::params::cinder_gluster_peers,
  $cinder_gluster_replica_count = $quickstack::params::cinder_gluster_replica_count,
  $cinder_gluster_volume        = $quickstack::params::cinder_gluster_volume,
  $glance_gluster_path          = $quickstack::params::glance_gluster_path,
  $glance_gluster_peers         = $quickstack::params::glance_gluster_peers,
  $glance_gluster_replica_count = $quickstack::params::glance_gluster_replica_count,
  $glance_gluster_volume        = $quickstack::params::glance_gluster_volume,
) inherits quickstack::params {

  class { 'gluster::server': }

  class { 'quickstack::storage_backend::gluster::volume_cinder':
    cinder_gluster_path          => $cinder_gluster_path,
    cinder_gluster_peers         => $cinder_gluster_peers,
    cinder_gluster_replica_count => $cinder_gluster_replica_count,
    cinder_gluster_volume        => $cinder_gluster_volume,
  }

  class { 'quickstack::storage_backend::gluster::volume_glance':
    glance_gluster_path          => $glance_gluster_path,
    glance_gluster_peers         => $glance_gluster_peers,
    glance_gluster_replica_count => $glance_gluster_replica_count,
    glance_gluster_volume        => $glance_gluster_volume,
  }

#  class { 'quickstack::storage_backend::gluster::volume_swift': }

  firewall { '001 RPC and gluster daemon incoming':
    proto  => 'tcp',
    dport  => [ '111', '24007', '24008' ],
    action => 'accept',
  }

  # 1 port per brick
  firewall { '002 gluster bricks incoming':
    proto  => 'tcp',
    #dport  => port_range('24009', '6'),
    dport    => [ '24009', '24010', '24011', '24012', '24013', '24014' ],
    action => 'accept',
  } 
}
