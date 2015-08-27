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
node 'osci-jenkins.lab.100percentit.com' {
  #$group = "jenkins"
  $zmq_event_receivers = ['osci-jenkins.lab.100percentit.com']
  $iptables_rule = regsubst ($zmq_event_receivers,
                             '^(.*)$', '-m state --state NEW -m tcp -p tcp --dport 8888 -s \1 -j ACCEPT')
  class { 'openstack_project::server':
    iptables_public_tcp_ports => [80, 443, 4505, 4506, 8140],
    iptables_rules6           => $iptables_rule,
    iptables_rules4           => $iptables_rule,
    sysadmins                 => hiera('sysadmins', []),
    puppetmaster_server       => 'osci-master.lab.100percentit.com',
    pin_puppet                => '3.6.',
  }

  #class { 'jenkins::slave':
  #  user => false,
  #  ssh_key => '',
  #}

  #class { 'openstack_project::slave_common':
  #  project_config_repo     => 'https://github.com/anbangr/osci-project-config.git',
  #} 

  class { 'openstack_project::jenkins':
    project_config_repo     => 'https://github.com/anbangr/osci-project-config.git',
    jenkins_password        => hiera('jenkins_jobs_password', 'password'),
    jenkins_ssh_private_key => hiera('jenkins_ssh_private_key_contents', '
    -----BEGIN RSA PRIVATE KEY-----
    MIIEpAIBAAKCAQEAz/1DwPldYSV0bfppWHLrRv5IYtKJSyaCwBje3m2ipPUokwfH
    3Vw/ZM+F/eK7x7TmDunOGb4u2q45ADUjLapu0YAmwMB2c6fNZhBRqXAThK3SbGet
    kEFcfkcf1EgQkeXCz/iqnrYJWxJ9Q6HaBAjHpcAJySx6Y4nX1P1KtXVBfzVOXA1u
    CabUzJM+Py4OQ1dPw7JnxAbaMAqnd4f4LYg2G//t4jP3imRPom+BAjygBPvlljeD
    Eb792/+wyCXqcDkQ5UrjAHNY0b8/Q3I+mYYIOQbEk1TyMfRGj/ob1lQ3gBAPi52n
    pMqLx00YEfeH1WaE8AwP7bY83oZJ+tJXmer+QQIDAQABAoIBAGQ3amAfR2k5vOIJ
    GJ1vsgIhIAvN2i2FvtaEpU6TkRzeq9A8nYcBneIbRDrS9xwBBCEHczFgO/9Ol1SM
    RgkI6CC2GPYjRm/v2L5m+pIj2KPDhXKKekzZ0ZFe/+0vVByYksfWz49tsxBY1lay
    M/RhrqEk6RIwBkDT+FU+PrM0bny1+ja19KHuySawV5xn3sg8QXT0xvRPy5PSBRsc
    CdVM3GxSJZW5FSakwQw6aWHJryXvscSohWY1v+8SVUafRVPf1tZigehtbQc6fBPm
    XIasfZ1FM85BcYEUGDeK3DrAh3/uh5LjeCfWdDB7z9TgzYbmaHxMFHuv5Rxck/OA
    DGti6YECgYEA7Z6XXjiZG6f0gefrYB/30kV//OL3kKdjH8vQkdMdOhdVKYpqJqH3
    8pNy7QQ+jlCDxrBgXCO6v7x4mpDALcMTUxg0e4QTQ+J7FaAOcBTiSs6bH8lPF0h/
    LEhc1dxMkT0VqDcPQWM/rgiHglVqFtpMLCA1PXo7hklZyML/99B72kkCgYEA4BPt
    mGtAco1l2u4mhf3tSFWQLsgqWVhr66LSa607gzteLHPyQy9kVxV5/sIv726Y17M3
    8rcfnEUoZS+os1PyHF/gZMVDB/Eqz1L7YuHkrIXY/0hqaklZZiGE9Ffei55b5r5D
    C5w0hwKHhA7Q9/acuiuOX1W5UxOQJwD0RyV8RDkCgYAp2DTFxefIhAI94i6EBf0p
    TU3lpb58/c0p60V2eJv7/+HiZ9qbpQg58pdZf9bYTvt1wNenQi9/1lvStEzzghfk
    GS4c1jxiRv7v5vjD6hmTnOCab2P7MKwciz21946QQRaQQenw1N6A8kWSwSHmlli1
    qJJXmi/jTQV/oj9bT56P6QKBgQDNx19FvxDjYhjs0hHMsWHsMK+FVssVW89YCSIG
    QoNJxAZ6+ku8CVSzaIStQXW2AzIXvH0fx64e25/6NKdPcEMCbcXrpQAm1gIDfWhg
    6aQQD6c04TLgwtV3pkasAdndDCPHpmh5zAytA9ShoN2lKfPKQF+yC05zDZ8vQoAS
    qkkReQKBgQDhrZrUuwZcJy/HWc3Y+H69iQf8gsg6IC80mmaGjZkyFslgNeH0cDh8
    84G73tM6a3Ej9w5Y/xQK29HWw/y9FoWPFwElyNc4Dg8B4S7BHjR6kZZKbzJlj3Jt
    7e2mViXE0Go4QoIMDv+NVx2aDxCIj5mnVPmITRVNfyKx6Pg52KiVIg==
    -----END RSA PRIVATE KEY-----
    '),
    ssl_cert_file           => '/etc/ssl/certs/ssl-cert-snakeoil.pem',
    ssl_key_file            => '/etc/ssl/private/ssl-cert-snakeoil.key',
    ssl_chain_file          => '',
  }

  package { 'tox':
    ensure   => 'latest',
    provider => pip,
    require  => Class[pip],
  }

  file { '/usr/local/jenkins':
    ensure => directory,
    owner  => 'root',
    group  => 'root',
    mode   => '0755',
  }

  file { '/usr/local/jenkins/common_data':
    ensure  => directory,
    owner   => 'root',
    group   => 'root',
    mode    => '0755',
    recurse => true,
    purge   => true,
    force   => true,
    require => [File['/usr/local/jenkins'],
                $::project_config::config_dir],
    source  => $::project_config::jenkins_data_dir,
  }

  file { '/usr/local/jenkins/slave_scripts':
    ensure  => directory,
    owner   => 'root',
    group   => 'root',
    mode    => '0755',
    recurse => true,
    purge   => true,
    force   => true,
    require => [File['/usr/local/jenkins'],
                $::project_config::config_dir],
    source  => $::project_config::jenkins_scripts_dir,
  }

}

node 'osci-js01.lab.100percentit.com' {
  class { 'openstack_project::single_use_slave':
    project_config_repo     => 'https://github.com/anbangr/osci-project-config.git',
  }
}

node 'osci-zuul.lab.100percentit.com' {
  class { 'openstack_project::zuul_prod':
    project_config_repo     => 'https://github.com/anbangr/osci-project-config.git',
    gerrit_server                  => 'osci-gerrit.lab.100percentit.com',
    gerrit_user                    => 'zuul',
    gerrit_ssh_host_key            => hiera('gerrit_ssh_rsa_pubkey_contents', '
ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQDC0iVO8nHXS0LbsMbTh7hiMc1i1GpaORyYM/X12JeTPj9/ypRiqNaFZFoLegL7e0oqEgp5e87hih/SxUSBqKZDkhYGhtsN18FXYByZhmlksLjZYXEYeUIuU5Mkr2XG1vJTb2Tc65EtOpu9oyNehFBuAVkDMxT17AH5iosdypHuQ4BpB3alxMHmarGPSL0fqXtDnmBOob5llvNKMvctnbwHjYGT8cZ0WSHghMqSIOnPHUyEoIqUcth48G+bBUNEV9GKRIpisUv/pUM/AHMoSp3zsCslITKpJ5Bly0XI8S2cBfYCvocxrj5Hknly+4lersA3uSMtzuwkBLgthp3bOLSx root@osci-master
    '),
    zuul_ssh_private_key           => hiera('zuul_ssh_private_key_contents', '
    -----BEGIN RSA PRIVATE KEY-----
    MIIEpAIBAAKCAQEAq2sidhRxdhc7HfpKQ4V79Sd3yQPLEkDVr1m7vAFS7iz5ynOr
    IZ11Syok8PFhfTZKqnp7Wuue9FJsq38wowwqp1H13WEcMzK0eeIv5vslLLFeelz7
    JfeSgdCeEApR8PwP8OUu8ppGIAc6Dwh+0ExU5GPtwNa34Ta+MjlcepYMLfC74tZ+
    DlKV2IraIuPMZLiI9flcIAyw7yTPCSpQbHaIjOEUP0bh3L7MFvcFmwZS8RJfMSKP
    fLvv3npAm6OkDBkQpMxzC+ceA70ElraDVIuaGTA7o8NUeTs6C8zYbU1iy6CGZPzN
    o0L/EG0vjlqLOSvpSPl225uzrdhPUMyQWbB7SQIDAQABAoIBAQCjkQP+Fj25yCsB
    zN1mFo4UfIehSLxR+4mq2332xHCkkkf79Wk7FytgAKPlQP6cYtzWVS81r5UqXygQ
    cLoxKp/crqljh5FIDT8G+lxpFAYB4nFbYzPGo7ippC3e8moEABEZ9SZaGfmGAD9X
    Lu0Kx3tNv0iTdI9bGEheVju3QUv33KkVaY/OI0pXVThZKpa/EsUMB4DBWLD4dzet
    yTWT+UdizQS+SV8OqQ9nFGbrQfwoqzOkGFW3V6CQ5X1YQIKzjDSVcWVX0eQsz6LT
    PuqsaCObyCWiJVMifno+xtLbcwoJHt8kEvrsLNv3wLfI6j8Q/GHNeHQ1wAGcjKDV
    RWtX5fmdAoGBANalQhSVKjNb2VUeoklz7GjnCi9GPK0DZKDhaPPMU6PEkWeMD6qp
    SgsNd3CeJAKWP5i+eQr6gyAuBFOvb6vTg38mhAgUjfCIq9IbHcj3GQKaaUHhiAge
    2vDi3w/dmhWetvFeh29/uCiCV5wMDXw/8rpz7GG6H0hU3oSQyHiG6crjAoGBAMxx
    1VEc46hX+YRV4nsDMkulFcrCDhECAeZr1pYRU/FpRi7kGBXuaktb2zteqaKCO2N8
    QxPTnJI7f8UVcZBQdpYsgMKqMXsir09ZF3+HaK0/39S2q9Ii2cSCq7qXrOSQbkuC
    uf+uFBEYvD/SpNxDiehZ+hGOYLQVEHL4Fy8AKFzjAoGAckLgrWJGZ7aiN9yp2V4b
    YDB1THsgO52NyNKVcwq3D3vJR4zYnimmH8IYbdvRIYtn6WCjwMNgYBX++alvUdGz
    s1EGgeKnOH8YsCz9KwjWyHr4QzjSmDgMpqSux5xYtN+bVVvTzvf3SaExEAGegCDu
    jnC9SbyxgGilV35XKUnwVK8CgYBNA9TH6YoZMIrePzxB+sJHnLjI2LFT1t3AX39G
    qOBmYLH/mA06tcV0/fVoOBDPFyAoKfda0Kx6qc9H/vv40Vba24jlzBc3u6kuyvD/
    KZNVMGqxRt8TGe3PCSqH7/tBXuctquFGX91PU3IW2NMh5o9c6Ag79NaZABZiOPMC
    0Zxi4QKBgQCkWJ30WDcEwV4GeL8faD3/2nHJftQ7XuCHvSoV2KTw+fnE4WNnM+qA
    Njhb4h7vYrJPexkZy4vWeqCk5gl8n+M/WU6qUxBp6TjE3tfsxrrlzCKo6+d46OEe
    6TYZb9J2XYDSkc5Olb8614cKRTc2H9DSYKEulze+bT6bCt9IfaZUBQ==
    -----END RSA PRIVATE KEY-----
    '),
    url_pattern                    => 'http://logs.openstack.org/{build.parameters[LOG_PATH]}',
    #swift_authurl                  => 'https://identity.api.rackspacecloud.com/v2.0/',
    #swift_user                     => 'infra-files-rw',
    #swift_key                      => hiera('infra_files_rw_password', 'password'),
    #swift_tenant_name              => hiera('infra_files_tenant_name', 'tenantname'),
    #swift_region_name              => 'DFW',
    #swift_default_container        => 'infra-files',
    #swift_default_logserver_prefix => 'http://logs.openstack.org/',
    #swift_default_expiry           => 14400,
    proxy_ssl_cert_file_contents   => hiera('zuul_ssl_cert_file_contents', ''),
    proxy_ssl_key_file_contents    => hiera('zuul_ssl_key_file_contents', ''),
    proxy_ssl_chain_file_contents  => hiera('zuul_ssl_chain_file_contents', ''),
    zuul_url                       => 'http://osc-zuul.lab.100percentit.com./p',
    sysadmins                      => hiera('sysadmins', []),
    #statsd_host                    => 'osci-statsd.lab.100percentit.com.',
    gearman_workers                => ['osci-jenkins.lab.100percentit.com'],
  }
}

node 'osci-gerrit.lab.100percentit.com' {
  class { 'gerrit::mysql' :
    mysql_root_password => 'password',
    database_name => 'reviewdb',
    database_user => 'gerrit2',
    database_password => 'password',
  }

  class { 'openstack_project::review':
    project_config_repo                 => 'https://github.com/anbangr/osci-project-config.git',
    github_oauth_token                  => hiera('gerrit_github_token', ''),
    github_project_username             => hiera('github_project_username', 'username'),
    github_project_password             => hiera('github_project_password', 'password'),
    mysql_host                          => hiera('gerrit_mysql_host', 'localhost'),
    mysql_password                      => hiera('gerrit_mysql_password', 'password'),
    email_private_key                   => hiera('gerrit_email_private_key', ' kvLed7ddvADDGX9j1NjHPyJazd7WaVcCZMit7T7Sab/swI/N'),
    token_private_key                   => hiera('gerrit_rest_token_private_key', ''),
    gerritbot_password                  => hiera('gerrit_gerritbot_password', 'password'),
    gerritbot_ssh_rsa_key_contents      => hiera('gerritbot_ssh_rsa_key_contents', ''),
    gerritbot_ssh_rsa_pubkey_contents   => hiera('gerritbot_ssh_rsa_pubkey_contents', ''),
    ssl_cert_file          		          => '/etc/ssl/certs/gerrit.crt',
    ssl_cert_file_contents              => hiera('gerrit_ssl_cert_file_contents', '
-----BEGIN CERTIFICATE-----
MIIDXTCCAkWgAwIBAgIJAIgJ/liadTM+MA0GCSqGSIb3DQEBCwUAMEUxCzAJBgNV
BAYTAkFVMRMwEQYDVQQIDApTb21lLVN0YXRlMSEwHwYDVQQKDBhJbnRlcm5ldCBX
aWRnaXRzIFB0eSBMdGQwHhcNMTUwODA1MTMzMTA5WhcNMTgwNDMwMTMzMTA5WjBF
MQswCQYDVQQGEwJBVTETMBEGA1UECAwKU29tZS1TdGF0ZTEhMB8GA1UECgwYSW50
ZXJuZXQgV2lkZ2l0cyBQdHkgTHRkMIIBIjANBgkqhkiG9w0BAQEFAAOCAQ8AMIIB
CgKCAQEA2DzyQK5L4xmkosrF8pyT+SuGOv+O1ofnYfw/GUEe1OeqjcptcKgNn3TJ
Sk+8BQ7LKyoECYGXLrvp+fRkQ6ba2FwriGQg38mgo7EdM/fw0QUqvs/TZpJ4qzma
eiIDLzydc8C3kwldZl5UZM+1luB7zsA/vN57apdDDqNHgNEWdUBbGsSl1g2NI/p3
Uf8aDWQUTseSoOh2+Rgh5QEZAP7hboX9cdHqM/W3h/ilygunvoWr1C+yVluQ7zsS
h5eOyWinTbIsrl+jEJFygcPkBHhiTwIOqmuDaRVE2MJ2/kGHGnYmWGjhmrUi5pXg
KzGjj3kthH4fonJsQ9xKGe93eLfzHwIDAQABo1AwTjAdBgNVHQ4EFgQUF7kOMbLa
Z3nkN+8vhlAem79q7SQwHwYDVR0jBBgwFoAUF7kOMbLaZ3nkN+8vhlAem79q7SQw
DAYDVR0TBAUwAwEB/zANBgkqhkiG9w0BAQsFAAOCAQEAYvSQg+4wfri1FuKhEaqm
5DxW5T0YDwpJr5DlQ8Kja0Z9B0CHl8l+B/vWnQrNNPspnKQRNIM6Zo23u+rnHBpH
o0tpD7I5eH5Mk3p1X6kn/NOsTQnVR/SfrEEAhqR/1iQa7heXTF2u5kh6LepOvJcy
uD3xWFN8v/AWxO9D/uX3sglSITewHrhyk/9Zx8ce+UgRcUV64fh48pqR7cMkYgE6
J8OCpIxQhXMeEYzYmZDSfjO5CUBk67ukDUSZduOX8C0vDz9KOuxjNRm+9O6WT6/L
dmf++0LLngvHVnag+xcXg8kksOvZ6pihU9PaNpoeQxa27cl1Q/c6HOlLdCz/avpH
sw==
-----END CERTIFICATE-----
'),
    ssl_key_file            		        => '/etc/ssl/private/gerrit.key',
    ssl_key_file_contents               => hiera('gerrit_ssl_key_file_contents', '
-----BEGIN PRIVATE KEY-----
MIIEvwIBADANBgkqhkiG9w0BAQEFAASCBKkwggSlAgEAAoIBAQDYPPJArkvjGaSi
ysXynJP5K4Y6/47Wh+dh/D8ZQR7U56qNym1wqA2fdMlKT7wFDssrKgQJgZcuu+n5
9GRDptrYXCuIZCDfyaCjsR0z9/DRBSq+z9NmknirOZp6IgMvPJ1zwLeTCV1mXlRk
z7WW4HvOwD+83ntql0MOo0eA0RZ1QFsaxKXWDY0j+ndR/xoNZBROx5Kg6Hb5GCHl
ARkA/uFuhf1x0eoz9beH+KXKC6e+havUL7JWW5DvOxKHl47JaKdNsiyuX6MQkXKB
w+QEeGJPAg6qa4NpFUTYwnb+QYcadiZYaOGatSLmleArMaOPeS2Efh+icmxD3EoZ
73d4t/MfAgMBAAECggEAEd3fSlbccFRDFSxZ9LTZSSI+ggtxmuo5xQ/ZitWlnYPS
xMpwBnnsPjuhEiHKcESLpvJeyQZLHpJqP7vguPJFbNEYy7kyOitnuX694fhfjnW1
1XRIjFYX4FXvHJ5I0xNYEyNeR6jjbbznjjjXUTMVJ70cxxc+7Uy4PrJhCxS7nU5g
BvJ/rTHaufHrlBM9AnOr4DXDZntSuFbZXfEgR5nwAMbLs+7XWEd6h07EvhjkpiIo
bqqlhXXgYQwjmrK8/ZJQXYKXt1awIh9advtDAf9h3mNMeCtOMDXWSWaX1JYrQpJN
QghCmR+vNZ0JgUSJmR/LcoG3gfMOMsov7+cMuMFfkQKBgQD5IOArjiAq8aQSbcDC
v21E8ve4URbev34Mh6wNqEhaUNloIJbejsaXJNrTvEFz5jr76/eGX+B8osnX0PMd
b6fND+ELyhH/sAEb8PYAIHPECmHyFvu0ARs8pz3MkDDDfdQ9wG7bZ6vTjXaMO+rm
le2hPMjfVyUI5YUu3nDOTfwHhwKBgQDeM9P+/9p6FJ4WUaYnwmuRAdC44EKfSPyr
ANY9SHCT8PXixLNNfsHJOF1njBTdC3QfG9dXZ4vesO1AQKADd2GMAgPAHvQrZkLf
RbILiwaoTSyrkF/cei1BexXjDuYUv/fpbcgqWPA85XkxsT+C43LXxAlOro4yWbx6
rbbjzGntqQKBgQCbu7lmgMoLDlMKUiGVnCSqXVgNmGM7i2k4W/dp8jCIhNHjDbxC
E+6AvUEt6xjfYqSspq1tCrJCN2EF0FCprgqvXaXIwODPfS60UMT2/1Je0j64HzXp
KGfmWoV/QwO4sQfkMk8aSIxZCq14rFwDGOYbTOwk8Uztasz+p37M+GL8MQKBgQCy
SROIPvGlknVlow2WSUDVkIdQT2AlPgK9kmZTtZPeoDAqS3kybMpAEaGgO51h3pbF
fylBUCvB+mPicffx0A/MrrEjrbJsQBjX3KwG5v3ofEOjRKwl00IMkB33mTSy4XSh
Lxy0HbhkpBqh7H3xH14+EWUGZLhjXe0E4e0kyhcUQQKBgQCaJ2QVurbwXzSF+pl/
KBbafJMbgbNCO+u5hT7ftS2SUR+GkkyGWdrykirpqflYGBCNLYiY3bwLOK09l3mO
AzwobIUWSOnZiFPB1df2xSO5b4190u+GZ/L3Se/mthNgyZAB+O3XayKZrie/OdYs
tHVwSXi3prXiU9OfceMBUYK7kQ==
-----END PRIVATE KEY-----
'),
    ssl_chain_file_contents             => hiera('gerrit_ssl_chain_file_contents', ''),
    ssh_dsa_key_contents                => hiera('gerrit_ssh_dsa_key_contents', '
-----BEGIN DSA PRIVATE KEY-----
MIIBugIBAAKBgQCKIXVLaAsvZwMuQmJ9vnyyWc5m82043Wxpxmj6fb1QRxAg+3nA
Ar2wP7nlJzL488j7e/VGx9GjT1rwqdqrwdqWgWej6lBvz2vI0q6sN3wzinZzaK75
q2S3hZxhUS4nR3ctdZ5G5JG27w01Am7Sl868FtHFTFsL8Kft8CAlmX985wIVAIG/
SHqplQjGMiaSv7tzksKEQHIdAoGAJvmBsYOG5gI3YVWjy7hGsWc3I49Kas+hvETn
VIhFfzZkQJXKEOKyJ7p5k8mA4Jl2tVgZDqdm5ys7XRlg2Bu9+KcohyL2SXD4X+Nm
aLwSxsE6vs5W8Oe9tEK39TM8ZvSZqqknvVNuj6uq/joTXPE8Ih3tOP3IhzNdmSBo
xHPg8HECgYAWPjmbrCTzieFNk1hE6kHPJHSz3x+uFtNFnpjNzk+9NMfXeh98pAJL
YLnDB3xW6olpkF0UcaxLc4qoJudIKEwYF2+CVEIojEJV84qzEX6dL3MgZ18ocusV
3iGs2DpnaVihsNYVTsR59QmqTkCxw5Lwq9437OWKcZn3FRKHcT8CpQIUGXCedQLv
Imb2KKA5JIeV21fOy4Q=
-----END DSA PRIVATE KEY-----
'),
    ssh_dsa_pubkey_contents             => hiera('gerrit_ssh_dsa_pubkey_contents', '
ssh-dss AAAAB3NzaC1kc3MAAACBAIohdUtoCy9nAy5CYn2+fLJZzmbzbTjdbGnGaPp9vVBHECD7ecACvbA/ueUnMvjzyPt79UbH0aNPWvCp2qvB2paBZ6PqUG/Pa8jSrqw3fDOKdnNorvmrZLeFnGFRLidHdy11nkbkkbbvDTUCbtKXzrwW0cVMWwvwp+3wICWZf3znAAAAFQCBv0h6qZUIxjImkr+7c5LChEByHQAAAIAm+YGxg4bmAjdhVaPLuEaxZzcjj0pqz6G8ROdUiEV/NmRAlcoQ4rInunmTyYDgmXa1WBkOp2bnKztdGWDYG734pyiHIvZJcPhf42ZovBLGwTq+zlbw5720Qrf1Mzxm9JmqqSe9U26Pq6r+OhNc8TwiHe04/ciHM12ZIGjEc+DwcQAAAIAWPjmbrCTzieFNk1hE6kHPJHSz3x+uFtNFnpjNzk+9NMfXeh98pAJLYLnDB3xW6olpkF0UcaxLc4qoJudIKEwYF2+CVEIojEJV84qzEX6dL3MgZ18ocusV3iGs2DpnaVihsNYVTsR59QmqTkCxw5Lwq9437OWKcZn3FRKHcT8CpQ== root@osci-master
'),
    ssh_rsa_key_contents                => hiera('gerrit_ssh_rsa_key_contents', '
-----BEGIN RSA PRIVATE KEY-----
MIIEowIBAAKCAQEAwtIlTvJx10tC27DG04e4YjHNYtRqWjkcmDP19diXkz4/f8qU
YqjWhWRaC3oC+3tKKhIKeXvO4Yof0sVEgaimQ5IWBobbDdfBV2AcmYZpZLC42WFx
GHlCLlOTJK9lxtbyU29k3OuRLTqbvaMjXoRQbgFZAzMU9ewB+YqLHcqR7kOAaQd2
pcTB5mqxj0i9H6l7Q55gTqG+ZZbzSjL3LZ28B42Bk/HGdFkh4ITKkiDpzx1MhKCK
lHLYePBvmwVDRFfRikSKYrFL/6VDPwBzKEqd87ArJSEyqSeQZctFyPEtnAX2Ar6H
Ma4+R5J5cvuJXq7AN7kjLc7sJAS4LYad2zi0sQIDAQABAoIBAAlED2wy0cFInhRu
0vYKlXVuIvOZYLmLz9VZW1BnDcZ+Bm0giHAs0Y8kl7fGBNBLK9rWYtMmVU+azyqq
ITj9eXLrRsrmrRJ6eYKbWqDeqLKWSSRlowhj9AbaCLyM7w1G+d2IBccQGSaKjA+3
6526M00YGVCypEOSBwIEWdt/3/LyA5armaoUPuYVYBzxCa4cQI/Lcygcd6x53Lbu
GlO8DLBWHqcWMZakPmVf0ZdkWygd0LqYYmut1UTWMYNdPK9yGxtEP4D70zdj1aUS
zseBWFwlcmDw8mGVNTOIDhZVIK1PXSH57nby7v5HCYQm7nq+p/B98lQOvOj/dPFh
t6gQMbECgYEA9vBPb73XuJO7E3Qx+iexaNd9bEU9S5mxsKixHzt7g+fkH9eOtbWi
Rr62UmLFrJq8Jkf2ki66AxwT0bAVOByYZ0J6BHRfiIO9eU+3pvQracfeaBtm3h+l
ZdqhyBf5eOtWPJ7zn69hUZmE6V8u8VP1Dtmz2RrOEkXY7lSlVDIu/40CgYEAyfhA
aveJviWS8CC+VqBsejstmvYfZQDTVxkvnCsZ46l9747ROpAT/RVOGkr03BZ8gu2l
NJf3AqTFGVBOkkkcGEiqWNKISBtQ6aUAXvHVIiTvskBmXdtDBpeK7cRqMdIcLo/P
I45XRxaFKVEdHKBwDEX3QoSVgmu7xIWguu+ZnrUCgYEAzsqbmzXdywJb7YSmvZgz
51pd/CdXl1HUDd6WxVLosqOk1E2NgvniNWBMCl4Qr+S8n0owYGak+ymuJzFP87du
oTp4N/bEcevw5gAuCa/8Ew9/Xqtjz6ustMkMJiZ9khdyFj3+QsF5u/3V4iEFjK8E
TzVcePkLjR3U9nEIKqQD25kCgYBHumXOV2lQ4XFE3Kwcgc7kvh2dOim+KkPkW+p/
sQL5ypkSOgtum/qtWCKrzdEWVNoVeabBffLYuoHRUqcE5vgWW8A72VFTInhi8hmm
noZOIQYLrTltvdAZCDrr5GS+mtstYh9zhjrS4VmbadZH82a3xSViN0oNzosZ6UdC
/JL3PQKBgBGBQqQYx9MFlJRkiOnAXpwhovn/w4YfvRDVJbAGguT9RDLQVZYLkdJl
ZRW3mZPPkSLm8znY33QUzXha28mv71vdDgjp3apfJNEXrKF9vHJT0qRGh8KC0giV
eRZ1/HOIQNR3lhYOAT3013o7HWWVzh+68L/Sw29zHLvYht1Q6BjI
-----END RSA PRIVATE KEY-----
'),
    ssh_rsa_pubkey_contents             => hiera('gerrit_ssh_rsa_pubkey_contents', '
ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQDC0iVO8nHXS0LbsMbTh7hiMc1i1GpaORyYM/X12JeTPj9/ypRiqNaFZFoLegL7e0oqEgp5e87hih/SxUSBqKZDkhYGhtsN18FXYByZhmlksLjZYXEYeUIuU5Mkr2XG1vJTb2Tc65EtOpu9oyNehFBuAVkDMxT17AH5iosdypHuQ4BpB3alxMHmarGPSL0fqXtDnmBOob5llvNKMvctnbwHjYGT8cZ0WSHghMqSIOnPHUyEoIqUcth48G+bBUNEV9GKRIpisUv/pUM/AHMoSp3zsCslITKpJ5Bly0XI8S2cBfYCvocxrj5Hknly+4lersA3uSMtzuwkBLgthp3bOLSx root@osci-master
'),
    ssh_project_rsa_key_contents        => hiera('gerrit_project_ssh_rsa_key_contents', '
-----BEGIN RSA PRIVATE KEY-----
MIIEpAIBAAKCAQEAo5JpWdy0jI8MM78Q2V/jl+sAWLT9TOvynqjV7xWEwX6sd2cg
IYdzOgr6RG1YiqR5EtvduZ2hu2w/j7MmYrpFTIIi8/oqDldCB9+cLNOX0K+x8EUb
Uq7aurZ//oGeVZq2zJ+pWCRalk1M7FsXYcxDCLp0clnHQRqZuvHj7QxdlSY996fv
hviAdd5wrbHEDkyRIWWglgLcgHaCPnddEFVyEhajEnfP5hDjt76QqL0o/OvBFjid
Nu2IFZzbCR1endtMrs4QJYZkUOgBYVvo1dVBsRBw4VDFZfS80SZRz0A905rsI+Lh
glzd/cN8igHLKtRonaCQn9LvqMKk0vJGt/C54wIDAQABAoIBADNdcr/JUtkgwpAt
W7knJ205Wq6Ah1p0bYftNOETPNEWWkpUk/5zbne3oseCHt/KrkqByKrVGUilwX/6
nf86xzAzXY6H7FT8ibu3OG/LMk1SHup4iQ/54K3pSWA+i94N64FuUdtf7yJru9As
+ra3UgWXp6GRF8UV+Vh/RTfXPjvredf+Wrz5kSNrWDfBycDKD1T6FmYtapXwfSFU
6yY5rGWnRQjeztyRZ43MYH5BKju1HM0uVzlZnoXoSPh6Da/CVHDFYtqL10LPwH9j
ARumeG2E3Mbaa4sVY/H69AsjZXvQnwyN8J5oz+3dd1g29fKhB+IMNwu93FSvjc2N
MJ7vkUECgYEA0EJ7lvsVfyLIefXlLfOz9vwbMVbzJ+R51YggKJ9LWuu/SfbPZVC4
rZO61KkJA+A5+2YwSFPKbtWI+u/JV0JDB6BeSPvGhj/zICTDlQLwSOftVndnH2Nu
pSlH31zuFicGUeoKcznRmN/u6D08O0gBbZIGFrsIlIHX6Zrl3nZz/MsCgYEAyRF4
VzYaD1gBd+X/nkggScAROMJSnoZ0JyRHOhMjPCCsTLd/t+ng5H/RM9SxZvrErG6p
ltG2LpoaW5YhjFX42H9pg2UTfI8nF+FyQdQYBYYMb2b8rPUHLJx8/2HbubiLtcbY
N5iV1tJU4z5QQf8ZTkziKZYdAGnKtOLTwbeobEkCgYEAvyKFM0g1rn1J6UUYlVf5
b1Bp1Jqsh4xVlPheK2onSsbaxRNTvPScyhGvgsWwlHISRPzAi2D7hUVNdqDj9MXH
pxQz9F+/EC9Y/8M+DWCpDwBs/tKPPmuPfN2qLQGpMYOXdU6LUL1b9CZxqYup3+5y
ARHnrKzzbvjMJIYZOlcUlIkCgYEAkvqtUHsg86Rudlnv0KGC0MaRED+kq3M3x0ES
vBYvRI3RxcbBmwxhNEdnAw9wmwmm6TF/0Nr95PULXXXSkkZqQMBqvf0OEJiIiEFq
B0rmQGtr/ad3/2qiUu8VxI2hVBLeNgPkHEfzCHT6Tp9HhebXddBn5uRv0NSEtFO3
Xb1GZdkCgYAZQZhQq12xyZfuwPC65lDQwF0i6nnMceA/nZEeIflwiTFwK/EMetIS
jjn6xRLp38fvrn8OcDIZ4u08zTeH0FnSlfgkoPWjbHSLHWVm1bUaB/UYvySbRLJ1
lae55VAtCBmn2qsGSYfddpPckESHP5EpX0vMoKT/FmienW2LmnywFQ==
-----END RSA PRIVATE KEY-----
'),
    ssh_project_rsa_pubkey_contents     => hiera('gerrit_project_ssh_rsa_pubkey_contents', '
    ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQCjkmlZ3LSMjwwzvxDZX+OX6wBYtP1M6/KeqNXvFYTBfqx3ZyAhh3M6CvpEbViKpHkS2925naG7bD+PsyZiukVMgiLz+ioOV0IH35ws05fQr7HwRRtSrtq6tn/+gZ5VmrbMn6lYJFqWTUzsWxdhzEMIunRyWcdBGpm68ePtDF2VJj33p++G+IB13nCtscQOTJEhZaCWAtyAdoI+d10QVXISFqMSd8/mEOO3vpCovSj868EWOJ027YgVnNsJHV6d20yuzhAlhmRQ6AFhW+jV1UGxEHDhUMVl9LzRJlHPQD3Tmuwj4uGCXN39w3yKAcsq1GidoJCf0u+owqTS8ka38Lnj aruan@foreman
'),
    ssh_welcome_rsa_key_contents        => hiera('welcome_message_gerrit_ssh_private_key', ''),
    ssh_welcome_rsa_pubkey_contents     => hiera('welcome_message_gerrit_ssh_public_key', ''),
    ssh_replication_rsa_key_contents    => hiera('gerrit_replication_ssh_rsa_key_contents', ''),
    ssh_replication_rsa_pubkey_contents => hiera('gerrit_replication_ssh_rsa_pubkey_contents', ''),
    lp_sync_consumer_key                => hiera('gerrit_lp_consumer_key', ''),
    lp_sync_token                       => hiera('gerrit_lp_access_token', ''),
    lp_sync_secret                      => hiera('gerrit_lp_access_secret', ''),
    contactstore                        => false,
    contactstore_appsec                 => hiera('gerrit_contactstore_appsec', ''),
    contactstore_pubkey                 => hiera('gerrit_contactstore_pubkey', ''),
    sysadmins                           => hiera('sysadmins', []),
    swift_username                      => hiera('swift_store_user', 'username'),
    swift_password                      => hiera('swift_store_key', ''),
  }
}
  

node 'osci-zm.lab.100percentit.com' {
  $group = "zuul-merger"
  class { 'openstack_project::zuul_merger':
    gearman_server       => 'osci-zuul.lab.100percentit.com',
    gerrit_server                  => 'osci-gerrit.lab.100percentit.com',
    gerrit_user                    => 'zuul',
    gerrit_ssh_host_key            => hiera('gerrit_ssh_rsa_pubkey_contents', '
ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQDC0iVO8nHXS0LbsMbTh7hiMc1i1GpaORyYM/X12JeTPj9/ypRiqNaFZFoLegL7e0oqEgp5e87hih/SxUSBqKZDkhYGhtsN18FXYByZhmlksLjZYXEYeUIuU5Mkr2XG1vJTb2Tc65EtOpu9oyNehFBuAVkDMxT17AH5iosdypHuQ4BpB3alxMHmarGPSL0fqXtDnmBOob5llvNKMvctnbwHjYGT8cZ0WSHghMqSIOnPHUyEoIqUcth48G+bBUNEV9GKRIpisUv/pUM/AHMoSp3zsCslITKpJ5Bly0XI8S2cBfYCvocxrj5Hknly+4lersA3uSMtzuwkBLgthp3bOLSx root@osci-master
    '),
    zuul_ssh_private_key           => hiera('zuul_ssh_private_key_contents', '
    -----BEGIN RSA PRIVATE KEY-----
    MIIEpAIBAAKCAQEAq2sidhRxdhc7HfpKQ4V79Sd3yQPLEkDVr1m7vAFS7iz5ynOr
    IZ11Syok8PFhfTZKqnp7Wuue9FJsq38wowwqp1H13WEcMzK0eeIv5vslLLFeelz7
    JfeSgdCeEApR8PwP8OUu8ppGIAc6Dwh+0ExU5GPtwNa34Ta+MjlcepYMLfC74tZ+
    DlKV2IraIuPMZLiI9flcIAyw7yTPCSpQbHaIjOEUP0bh3L7MFvcFmwZS8RJfMSKP
    fLvv3npAm6OkDBkQpMxzC+ceA70ElraDVIuaGTA7o8NUeTs6C8zYbU1iy6CGZPzN
    o0L/EG0vjlqLOSvpSPl225uzrdhPUMyQWbB7SQIDAQABAoIBAQCjkQP+Fj25yCsB
    zN1mFo4UfIehSLxR+4mq2332xHCkkkf79Wk7FytgAKPlQP6cYtzWVS81r5UqXygQ
    cLoxKp/crqljh5FIDT8G+lxpFAYB4nFbYzPGo7ippC3e8moEABEZ9SZaGfmGAD9X
    Lu0Kx3tNv0iTdI9bGEheVju3QUv33KkVaY/OI0pXVThZKpa/EsUMB4DBWLD4dzet
    yTWT+UdizQS+SV8OqQ9nFGbrQfwoqzOkGFW3V6CQ5X1YQIKzjDSVcWVX0eQsz6LT
    PuqsaCObyCWiJVMifno+xtLbcwoJHt8kEvrsLNv3wLfI6j8Q/GHNeHQ1wAGcjKDV
    RWtX5fmdAoGBANalQhSVKjNb2VUeoklz7GjnCi9GPK0DZKDhaPPMU6PEkWeMD6qp
    SgsNd3CeJAKWP5i+eQr6gyAuBFOvb6vTg38mhAgUjfCIq9IbHcj3GQKaaUHhiAge
    2vDi3w/dmhWetvFeh29/uCiCV5wMDXw/8rpz7GG6H0hU3oSQyHiG6crjAoGBAMxx
    1VEc46hX+YRV4nsDMkulFcrCDhECAeZr1pYRU/FpRi7kGBXuaktb2zteqaKCO2N8
    QxPTnJI7f8UVcZBQdpYsgMKqMXsir09ZF3+HaK0/39S2q9Ii2cSCq7qXrOSQbkuC
    uf+uFBEYvD/SpNxDiehZ+hGOYLQVEHL4Fy8AKFzjAoGAckLgrWJGZ7aiN9yp2V4b
    YDB1THsgO52NyNKVcwq3D3vJR4zYnimmH8IYbdvRIYtn6WCjwMNgYBX++alvUdGz
    s1EGgeKnOH8YsCz9KwjWyHr4QzjSmDgMpqSux5xYtN+bVVvTzvf3SaExEAGegCDu
    jnC9SbyxgGilV35XKUnwVK8CgYBNA9TH6YoZMIrePzxB+sJHnLjI2LFT1t3AX39G
    qOBmYLH/mA06tcV0/fVoOBDPFyAoKfda0Kx6qc9H/vv40Vba24jlzBc3u6kuyvD/
    KZNVMGqxRt8TGe3PCSqH7/tBXuctquFGX91PU3IW2NMh5o9c6Ag79NaZABZiOPMC
    0Zxi4QKBgQCkWJ30WDcEwV4GeL8faD3/2nHJftQ7XuCHvSoV2KTw+fnE4WNnM+qA
    Njhb4h7vYrJPexkZy4vWeqCk5gl8n+M/WU6qUxBp6TjE3tfsxrrlzCKo6+d46OEe
    6TYZb9J2XYDSkc5Olb8614cKRTc2H9DSYKEulze+bT6bCt9IfaZUBQ==
    -----END RSA PRIVATE KEY-----
    '),
    sysadmins            => hiera('sysadmins', []),
  }
}


