#
# Top-level variables
#
# There must not be any whitespace between this comment and the variables or
# in between any two variables in order for them to be correctly parsed and
# passed around in test.sh
#
#
# Default: should at least behave like an openstack server
#
node default {
  class { 'openstack_project::server':
    sysadmins => hiera('sysadmins', []),
  }
}

# Node-OS: precise
node 'jenkins.lab.100percentit.com' {
  $group = "jenkins"
  $zmq_event_receivers = ['jenkins.lab.100percentit.com']
  $iptables_rule = regsubst ($zmq_event_receivers,
                             '^(.*)$', '-m state --state NEW -m tcp -p tcp --dport 8888 -s \1 -j ACCEPT')
  class { 'openstack_project::server':
    iptables_public_tcp_ports => [80, 443, 4505, 4506, 8140],
    iptables_rules6           => $iptables_rule,
    iptables_rules4           => $iptables_rule,
    sysadmins                 => hiera('sysadmins', []),
    puppetmaster_server       => 'jenkins.lab.100percentit.com',
    pin_puppet                => '3.6.',
  }

  class { 'openstack_project::jenkins':
    project_config_repo     => 'https://git.openstack.org/openstack-infra/project-config',
    jenkins_password        => hiera('jenkins_jobs_password', 'XXX'),
    jenkins_ssh_private_key => hiera('jenkins_ssh_private_key_contents', 'XXX'),
    ssl_cert_file           => '/etc/ssl/certs/ssl-cert-snakeoil.pem',
    ssl_key_file            => '/etc/ssl/private/ssl-cert-snakeoil.key',
    ssl_chain_file          => '',
  }

  class { 'openstack_project::puppetmaster':
    root_rsa_key => hiera('puppetmaster_root_rsa_key', 'XXX'),
  }
}

node 'jenkins-salt.lab.100percentit.com' {
  class { 'openstack_project::server':
    iptables_public_tcp_ports => [4505, 4506, 8140, 8081, 80],
    sysadmins                 => hiera('sysadmins', []),
    pin_puppet                => '3.6.',
  }

  class { 'openstack_project::review':
    project_config_repo                 => 'https://git.openstack.org/openstack-infra/project-config',
    github_oauth_token                  => hiera('gerrit_github_token', 'XXX'),
    github_project_username             => hiera('github_project_username', 'username'),
    github_project_password             => hiera('github_project_password', 'XXX'),
    mysql_host                          => hiera('gerrit_mysql_host', 'localhost'),
    mysql_password                      => hiera('gerrit_mysql_password', 'XXX'),
    email_private_key                   => hiera('gerrit_email_private_key', 'XXX'),
    token_private_key                   => hiera('gerrit_rest_token_private_key', 'XXX'),
    gerritbot_password                  => hiera('gerrit_gerritbot_password', 'XXX'),
    gerritbot_ssh_rsa_key_contents      => hiera('gerritbot_ssh_rsa_key_contents', 'XXX'),
    gerritbot_ssh_rsa_pubkey_contents   => hiera('gerritbot_ssh_rsa_pubkey_contents', 'XXX'),
    ssl_cert_file_contents              => hiera('gerrit_ssl_cert_file_contents', 'XXX'),
    ssl_key_file_contents               => hiera('gerrit_ssl_key_file_contents', 'XXX'),
    ssl_chain_file_contents             => hiera('gerrit_ssl_chain_file_contents', 'XXX'),
    ssh_dsa_key_contents                => hiera('gerrit_ssh_dsa_key_contents', 'XXX'),
    ssh_dsa_pubkey_contents             => hiera('gerrit_ssh_dsa_pubkey_contents', 'XXX'),
    ssh_rsa_key_contents                => hiera('gerrit_ssh_rsa_key_contents', 'XXX'),
    ssh_rsa_pubkey_contents             => hiera('gerrit_ssh_rsa_pubkey_contents', 'XXX'),
    ssh_project_rsa_key_contents        => hiera('gerrit_project_ssh_rsa_key_contents', 'XXX'),
    ssh_project_rsa_pubkey_contents     => hiera('gerrit_project_ssh_rsa_pubkey_contents', 'XXX'),
    ssh_welcome_rsa_key_contents        => hiera('welcome_message_gerrit_ssh_private_key', 'XXX'),
    ssh_welcome_rsa_pubkey_contents     => hiera('welcome_message_gerrit_ssh_public_key', 'XXX'),
    ssh_replication_rsa_key_contents    => hiera('gerrit_replication_ssh_rsa_key_contents', 'XXX'),
    ssh_replication_rsa_pubkey_contents => hiera('gerrit_replication_ssh_rsa_pubkey_contents', 'XXX'),
    lp_sync_consumer_key                => hiera('gerrit_lp_consumer_key', 'XXX'),
    lp_sync_token                       => hiera('gerrit_lp_access_token', 'XXX'),
    lp_sync_secret                      => hiera('gerrit_lp_access_secret', 'XXX'),
    contactstore_appsec                 => hiera('gerrit_contactstore_appsec', 'XXX'),
    contactstore_pubkey                 => hiera('gerrit_contactstore_pubkey', 'XXX'),
    sysadmins                           => hiera('sysadmins', []),
    swift_username                      => hiera('swift_store_user', 'username'),
    swift_password                      => hiera('swift_store_key', 'XXX'),
  }
}
  
