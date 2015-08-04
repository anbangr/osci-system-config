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
    jenkins_password        => hiera('jenkins_jobs_password', 'password'),
    jenkins_ssh_private_key => hiera('jenkins_ssh_private_key_contents', ''),
    ssl_cert_file           => '/etc/ssl/certs/ssl-cert-snakeoil.pem',
    ssl_key_file            => '/etc/ssl/private/ssl-cert-snakeoil.key',
    ssl_chain_file          => '',
  }

  class { 'openstack_project::puppetmaster':
    root_rsa_key => hiera('puppetmaster_root_rsa_key', ''),
  }


  class { 'openstack_project::graphite':
    sysadmins               => hiera('sysadmins', []),
    graphite_admin_user     => hiera('graphite_admin_user', 'username'),
    graphite_admin_email    => hiera('graphite_admin_email', 'email@example.com'),
    graphite_admin_password => hiera('graphite_admin_password', 'password'),
    statsd_hosts            => ['jenkins-salt.lab.100percentit.com',
                                'jenkins.lab.100percentit.com'
                               ],
  }

  class { 'openstack_project::zuul_prod':
    project_config_repo            => 'https://git.openstack.org/openstack-infra/project-config',
    gerrit_server                  => 'jenkins-salt.lab.100percentit.com',
    gerrit_user                    => 'jenkins',
    gerrit_ssh_host_key            => hiera('gerrit_ssh_rsa_pubkey_contents', ''),
    zuul_ssh_private_key           => hiera('zuul_ssh_private_key_contents', ''),
    url_pattern                    => 'http://logs.openstack.org/{build.parameters[LOG_PATH]}',
    swift_authurl                  => 'https://identity.api.rackspacecloud.com/v2.0/',
    swift_user                     => 'infra-files-rw',
    swift_key                      => hiera('infra_files_rw_password', 'password'),
    swift_tenant_name              => hiera('infra_files_tenant_name', 'tenantname'),
    swift_region_name              => 'DFW',
    swift_default_container        => 'infra-files',
    swift_default_logserver_prefix => 'http://logs.openstack.org/',
    swift_default_expiry           => 14400,
    proxy_ssl_cert_file_contents   => hiera('zuul_ssl_cert_file_contents', ''),
    proxy_ssl_key_file_contents    => hiera('zuul_ssl_key_file_contents', ''),
    proxy_ssl_chain_file_contents  => hiera('zuul_ssl_chain_file_contents', ''),
    zuul_url                       => 'http://jenkins.lab.100percentit.com./p',
    sysadmins                      => hiera('sysadmins', []),
    statsd_host                    => 'jenkins.lab.100percentit.com.',
    gearman_workers                => ['jenkins.lab.100percentit.com'],
  }
}

node 'jenkins-salt.lab.100percentit.com' {
  class { 'openstack_project::review':
    project_config_repo                 => 'https://git.openstack.org/openstack-infra/project-config',
    github_oauth_token                  => hiera('gerrit_github_token', ''),
    github_project_username             => hiera('github_project_username', 'username'),
    github_project_password             => hiera('github_project_password', 'password'),
    mysql_host                          => hiera('gerrit_mysql_host', 'localhost'),
    mysql_password                      => hiera('gerrit_mysql_password', 'password'),
    email_private_key                   => hiera('gerrit_email_private_key', ''),
    token_private_key                   => hiera('gerrit_rest_token_private_key', ''),
    gerritbot_password                  => hiera('gerrit_gerritbot_password', 'password'),
    gerritbot_ssh_rsa_key_contents      => hiera('gerritbot_ssh_rsa_key_contents', ''),
    gerritbot_ssh_rsa_pubkey_contents   => hiera('gerritbot_ssh_rsa_pubkey_contents', ''),
    ssl_cert_file          		 => '/etc/ssl/certs/ssl-cert-snakeoil.pem',
    ssl_cert_file_contents              => hiera('gerrit_ssl_cert_file_contents', ''),
    ssl_key_file            		=> '/etc/ssl/private/ssl-cert-snakeoil.key',
    ssl_key_file_contents               => hiera('gerrit_ssl_key_file_contents', ''),
    ssl_chain_file_contents             => hiera('gerrit_ssl_chain_file_contents', ''),
    ssh_dsa_key_contents                => hiera('gerrit_ssh_dsa_key_contents', ''),
    ssh_dsa_pubkey_contents             => hiera('gerrit_ssh_dsa_pubkey_contents', ''),
    ssh_rsa_key_contents                => hiera('gerrit_ssh_rsa_key_contents', ''),
    ssh_rsa_pubkey_contents             => hiera('gerrit_ssh_rsa_pubkey_contents', ''),
    ssh_project_rsa_key_contents        => hiera('gerrit_project_ssh_rsa_key_contents', ''),
    ssh_project_rsa_pubkey_contents     => hiera('gerrit_project_ssh_rsa_pubkey_contents', ''),
    ssh_welcome_rsa_key_contents        => hiera('welcome_message_gerrit_ssh_private_key', ''),
    ssh_welcome_rsa_pubkey_contents     => hiera('welcome_message_gerrit_ssh_public_key', ''),
    ssh_replication_rsa_key_contents    => hiera('gerrit_replication_ssh_rsa_key_contents', ''),
    ssh_replication_rsa_pubkey_contents => hiera('gerrit_replication_ssh_rsa_pubkey_contents', ''),
    lp_sync_consumer_key                => hiera('gerrit_lp_consumer_key', ''),
    lp_sync_token                       => hiera('gerrit_lp_access_token', ''),
    lp_sync_secret                      => hiera('gerrit_lp_access_secret', ''),
    contactstore_appsec                 => hiera('gerrit_contactstore_appsec', ''),
    contactstore_pubkey                 => hiera('gerrit_contactstore_pubkey', ''),
    sysadmins                           => hiera('sysadmins', []),
    swift_username                      => hiera('swift_store_user', 'username'),
    swift_password                      => hiera('swift_store_key', ''),
  }
}
  
