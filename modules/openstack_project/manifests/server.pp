# == Class: openstack_project::server
#
# A server that we expect to run for some time
class openstack_project::server (
  $iptables_public_tcp_ports = [],
  $iptables_public_udp_ports = [],
  $iptables_rules4           = [],
  $iptables_rules6           = [],
  $sysadmins                 = [],
  $certname                  = $::fqdn,
  $pin_puppet                = '3.',
  $ca_server                 = undef,
  $afs                       = false,
  $puppetmaster_server       = 'osci-master.lab.100percentit.com',
  $manage_exim               = true,
  $pypi_index_url            = 'https://pypi.python.org/simple',
  $pypi_trusted_hosts        = [
      'pypi.dwf.openstack.org',
      'pypi.iad.openstack.org',
      'pypi.ord.openstack.org',
      'pypi.region-b.geo-1.openstack.org',
  ],
) {
  class { 'openstack_project::template':
    iptables_public_tcp_ports => $iptables_public_tcp_ports,
    iptables_public_udp_ports => $iptables_public_udp_ports,
    iptables_rules4           => $iptables_rules4,
    iptables_rules6           => $iptables_rules6,
    certname                  => $certname,
    pin_puppet                => $pin_puppet,
    ca_server                 => $ca_server,
    puppetmaster_server       => $puppetmaster_server,
    afs                       => $afs,
    manage_exim               => $manage_exim,
    sysadmins                 => $sysadmins,
    pypi_index_url            => $pypi_index_url,
    pypi_trusted_hosts        => $pypi_trusted_hosts,
  }
}
