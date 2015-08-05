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
  $group = "jenkins"
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

  class { 'openstack_project::jenkins':
    project_config_repo     => 'https://git.openstack.org/openstack-infra/project-config',
    jenkins_password        => hiera('jenkins_jobs_password', 'password'),
    jenkins_ssh_private_key => hiera('jenkins_ssh_private_key_contents', ''),
    ssl_cert_file           => '/etc/ssl/certs/ssl-cert-snakeoil.pem',
    ssl_key_file            => '/etc/ssl/private/ssl-cert-snakeoil.key',
    ssl_chain_file          => '',
  }
}

node 'osci-zuul.lab.100percentit.com' {
  class { 'openstack_project::zuul_prod':
    project_config_repo            => 'https://git.openstack.org/openstack-infra/project-config',
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
MIIEpQIBAAKCAQEA0yPrHFQWtkAhmnhClTtKcsi6Kqmj9i/mR8UPLiY90Su7+xy6
n9kQQlJO94kQ2otQQtrp+Xyxd2EULI0HSCfFxLGgj8sXMqbcIftnUbCCCV4UiO/L
p81gFnOOe/EU+2pFcHr+8f4njhrW4id+tTNTUbBv4RcKOiF/CnMcuwVx8qgWTKgx
FbUgxPJIVgiW2dgm8NlRpsH4DtjzNe3XDnpMTl+8FbTQviIlY4OmDT/c2bgDSGfY
CI/tg0t3CDRNObZUCc9wqjaXL3O6DNptOEEYB5//i5midajL+FUOvIz7o8j+h6Hg
XWEs4ZEY0Cd34mEh65gQIOFRIzc6pCIj3NxyuwIDAQABAoIBAQCkWTAYM+gd4tuF
RpjlWmp/4Hjw3m1PI0fHk79WN9Qkbjt7ooguBqMeTL1E9v8Ubh6Ce65mUcY922X9
q6UAaF0L1wvZAcfD2Jg/J1bsAk2mBwJK+QT4T+e8ciR1m1muvbDhdgvex+t4NLIR
BZceap4vVvwvJGUEjLA7rRCvDvT8YKm1/UGxbOQBvQ4FJhx3nhO19WBq4mhAiJGC
r0pSnWPFOyrW8qcTBb6sVb8knFm9N9z2EYCmhqtPNJzvxx+xyYqlgdBZ0WqWFc+H
LYmhjfxgv6fwiJSsWLVlV6ObyeTtRlpKcYwbDCjtnUSF6pPFuGdYaD5jZA/BYN1z
n+8YMivBAoGBAPZk0EFULGhN3yR/QO5VGHx8olYK52cRvZQv7Zw5Z5zA6Q/ci9o4
JPEeL3mchsBYPD/dr1qILJTraPM2xZSZtpoAgUfVPh+5ry+0isuqrDRi3EhBb8vs
kSlRBSC1UTKY6el+C1pMJl8CyB/r8d0bNUBMMJpyjStd8VzRbJXDTqXhAoGBANtf
P/FomznaxMFCBqUuxufXzt7nFFOertWlOnuHcicKeG8PLypf2H3aqsmc0loOyVnP
v1ELQ4Fu3tNjAkcbF6MJf6vJfBr8GfRNUMlHFga2iMRpY88Iki3hvtcSgI7UObXZ
zy2JNirYkPywfCdhSx6/MoMoMlF5F3Favn5/R3QbAoGANSopmX8NGfB7jod6vjJU
V0AZUxGFPsMgMeJplcT5K2SgpVCESLDGn9RQkCALH2OqlGlEFfe+DuAAxEH0Pg0w
zmf/fT1w6y2ItHVzYWDRSXhvaZPdCJZh+BVIUvdsrss55azRzEkUGnoiLmkdxgTB
577I2fqPpWTe2JVDpcj/pmECgYEAoze+QqZ6/9O2mre+a/5evbcC0zQJGqIxIQJ7
fddr5oJS0wbwJ84CLLmaYsFMfPcNdsYsaWdBBbdxEMRUuIT+1C5IEI+ryAQUZ4Fy
/x7l037SSZjESxDsejjBHhJFFn/upE/3ZsD1TXGuhmPlLAOmuay2L4Gj1pyLBarn
mwSmLEsCgYEAl2g44NPOv+efG5/ITcdxmVCMZYoO1s1PhTrKBuGbFC/WGKmT4kXd
PBDTCp1o55dwAzFE9OHcu+xuCV0Xz6CjbSDpAWZDY76sxEhAUfVNFhdL4eRxvGIA
GPip8GYreJOS1G8S0Pw3wOD5DWJPqvJQSpAYQctrKNra7OOZNkf5yRc=
-----END RSA PRIVATE KEY-----
'),
    ssh_project_rsa_pubkey_contents     => hiera('gerrit_project_ssh_rsa_pubkey_contents', '
ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQDTI+scVBa2QCGaeEKVO0pyyLoqqaP2L+ZHxQ8uJj3RK7v7HLqf2RBCUk73iRDai1BC2un5fLF3YRQsjQdIJ8XEsaCPyxcyptwh+2dRsIIJXhSI78unzWAWc4578RT7akVwev7x/ieOGtbiJ361M1NRsG/hFwo6IX8Kcxy7BXHyqBZMqDEVtSDE8khWCJbZ2Cbw2VGmwfgO2PM17dcOekxOX7wVtNC+IiVjg6YNP9zZuANIZ9gIj+2DS3cINE05tlQJz3CqNpcvc7oM2m04QRgHn/+LmaJ1qMv4VQ68jPujyP6HoeBdYSzhkRjQJ3fiYSHrmBAg4VEjNzqkIiPc3HK7 root@osci-master
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
  
