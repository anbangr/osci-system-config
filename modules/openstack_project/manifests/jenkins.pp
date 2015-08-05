# == Class: openstack_project::jenkins
#
class openstack_project::jenkins (
  $vhost_name = $::fqdn,
  $jenkins_password = 'password',
  $jenkins_username = 'jenkins', # This is not a typo, well it isn't anymore.
  $ssl_cert_file = '/etc/ssl/certs/jenkins_server_key.crt',
  $ssl_key_file = '/etc/ssl/private/jenkins_server_key',
  $ssl_chain_file = '',
  $ssl_cert_file_contents = '
 -----BEGIN CERTIFICATE-----
 MIIDXTCCAkWgAwIBAgIJAPhWjeOd/j6QMA0GCSqGSIb3DQEBCwUAMEUxCzAJBgNV
 BAYTAkFVMRMwEQYDVQQIDApTb21lLVN0YXRlMSEwHwYDVQQKDBhJbnRlcm5ldCBX
 aWRnaXRzIFB0eSBMdGQwHhcNMTUwODA1MTUzMzE3WhcNMTYwODA0MTUzMzE3WjBF
 MQswCQYDVQQGEwJBVTETMBEGA1UECAwKU29tZS1TdGF0ZTEhMB8GA1UECgwYSW50
 ZXJuZXQgV2lkZ2l0cyBQdHkgTHRkMIIBIjANBgkqhkiG9w0BAQEFAAOCAQ8AMIIB
 CgKCAQEApcfQ0XXp3JuCH9SfF6IoSSe87Cr7XLEP6VXKJ7FkHjlkWOwpWh5lyQKi
 SSHOPBuE27KkNIKzfpE1nHGvXOQbRdC8kAI6c2GNsMC62UV8PAqRtIlg39iG2SDf
 rgjgSH3/mHQaeK+vyU6W33X+DamazZpn8a0n8D49kbguW1cF3STdUgGNjI9CBQDt
 65xeRpVMudWR3YmPA/ky9lLBIRuQ3pdooB+jS1ih1PSw26leBODD7JAbsm7zeo8K
 tg3woEHBpYRl5LgDO9EQidNJcmJ5npFAFE4evQfzXel/7/JVUfb0tfCoEZkQy76/
 t9iEIGeSGPD4s0WC9KnfubJXAjsjswIDAQABo1AwTjAdBgNVHQ4EFgQUHGu1AV4q
 3XrC35RZN/Nvjl9kBJIwHwYDVR0jBBgwFoAUHGu1AV4q3XrC35RZN/Nvjl9kBJIw
 DAYDVR0TBAUwAwEB/zANBgkqhkiG9w0BAQsFAAOCAQEAD+yV6HLsY5Uu8J9Sqbt/
 A5IC5i92NHgkMLMNgptjrvHSOPkJR++JrFb1xJfArA/XbMFySMj6gR+vJzg8r3/t
 RDItYKkQXpjvFVdZet3iAzN5h3+9AHo7ESxObudbPE5Ms/WyyrDUg3qU+MHBewKP
 x3xQ6jZpDhqVlWYC0bhNLYrukiFjS+ktop3W8W6gj1HxbQrP2OM9Hqa1p7Z7qmcZ
 7UJyKz7zWUzkHiWsu4KqgEEINfv+Y5Dqeg42WhJxCLVG7xL1fQBa12Bh980UimKR
 QYQEfAFNe18oy4zE0/OYz/MIF0DJge7kfmuWhfUCEzdeKubwhN/zY5HRPIFgM4cl
 TA==
 -----END CERTIFICATE-----
  ',
  $ssl_key_file_contents = '
  -----BEGIN RSA PRIVATE KEY-----
  MIIEowIBAAKCAQEApcfQ0XXp3JuCH9SfF6IoSSe87Cr7XLEP6VXKJ7FkHjlkWOwp
  Wh5lyQKiSSHOPBuE27KkNIKzfpE1nHGvXOQbRdC8kAI6c2GNsMC62UV8PAqRtIlg
  39iG2SDfrgjgSH3/mHQaeK+vyU6W33X+DamazZpn8a0n8D49kbguW1cF3STdUgGN
  jI9CBQDt65xeRpVMudWR3YmPA/ky9lLBIRuQ3pdooB+jS1ih1PSw26leBODD7JAb
  sm7zeo8Ktg3woEHBpYRl5LgDO9EQidNJcmJ5npFAFE4evQfzXel/7/JVUfb0tfCo
  EZkQy76/t9iEIGeSGPD4s0WC9KnfubJXAjsjswIDAQABAoIBAGXX1BPpsUqiihUN
  5NJ6/u66J9iaKyNtbw30cyVhV9UtgtUR9/Fx/Su4n4P37Z+FdGAXZcMQjD5z7JB4
  UrfpNkv0iPKbO9dIFeiA7giuJD0qbQqQ3t+FQIpBJMjgkRBXv16j7OM5Yu9zhUIw
  VWuFRyGJ+tNAgemYAvDzSh843dRVZNoCoy5Pe9mVErfZwrQ/TrIZBgJm+hL5Hau3
  4/ANc89ErtjCv87G3FcKR2UqzkQshZKyMzDPixYZciNT9BC/itD3XgHkWhb13tS0
  4xuImAWqYCb6r8OX7bMB2O8eVui4P+9bi/m2cFRs2wT/NpxiY6eaXNFYTzpQI2Ur
  iaVopjkCgYEA2WHsj+NGYgmUyLggzGgMO2ur8snhyoCy0ypF4mRaYVslnsI3mb4U
  wKEVbxhY4wrSR8K81WZHx1Gj2BTu+nTLAgCcoWUXp2u0Vc2IAvEJLe7+PEMQL4qf
  X9Z5mR+ytY0DWeoHIHG5V1QYRlFR6lbVaMU9MNiKfiwLnSImsTNBABcCgYEAwzsl
  wCy/vwtrwwuWG1CWhCZxWD8iioRi7Rpyd/ItJcsGhQ1czsh6S4sBVFITCqxC9QFn
  2smnExjL6ZJPt1Y9dHBWnzxrx72FK1dQ+uzixpz/oDPh7agHulrCPQQZtuhXkApZ
  iGerHSgv0lNAbKG9wVCCm4543HD5/Wcu3zAjvsUCgYEAgj8VAWV4j1cUSWthY3fY
  FGZAAVmKqs2P18wVUT81k+2LzeKqc7ibMIuTjxv0bhzWv15jzCzbRwaYd+ibA3+k
  /w8kyeMLWCnFRD/AhZqsGFSBCdRYx1N0iHS2KNQAPJ0/68i3+m2JUlS1srQYs6LR
  fVPohPLJkC2Ny9lhe3ytLoMCgYB4TTo18V02nBMLXVhh/IbDZ+zwM/dU478R2/ot
  b03iu/iIhHNr+J1jb4SiMPEK4ptf3j3g0+HgIqeEhmQY1UuJNLAr7097BY3J50Q/
  WzliqdvbHB1cFO6uJr8KWjx+OS271KTXKQqILPtK34ITbpc/SB0zPde7/uINBEgd
  v8xHAQKBgC9f9scLCK0w/VMGw3CXHvkLopMPZBHSp4GcVO8PQ0aavoNryi+ggGAq
  PXGyf3ylEJA6YdiTVmmBHW9UQ8ua6DKxHJMHvbefDWxrEup0xQp10UhBYdpH42v3
  cYT/5bSjfd5+JnBaAb8AHD5ucD8f7pScoQtliyQfsA1SmTfAf9xj
  -----END RSA PRIVATE KEY-----
  ',
  $ssl_chain_file_contents = '',
  $jenkins_ssh_public_key = $openstack_project::jenkins_ssh_key,
  $jenkins_ssh_private_key = '
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
  ',
  $project_config_repo = '',
  $project_config_base = '',
  $serveradmin = 'webmaster@openstack.org',
  $logo = 'openstack.png',
) inherits openstack_project {
  include openstack_project

  # Set defaults here because they evaluate variables which you cannot
  # do in the class parameter list.
  if $ssl_cert_file == '' {
    $prv_ssl_cert_file = "/etc/ssl/certs/${vhost_name}.pem"
  }
  else {
    $prv_ssl_cert_file = $ssl_cert_file
  }
  if $ssl_key_file == '' {
    $prv_ssl_key_file = "/etc/ssl/private/${vhost_name}.key"
  }
  else {
    $prv_ssl_key_file = $ssl_key_file
  }

  class { 'openstackci::jenkins_master':
    vhost_name              => $vhost_name,
    serveradmin             => $serveradmin,
    logo                    => $logo,
    ssl_cert_file           => $prv_ssl_cert_file,
    ssl_key_file            => $prv_ssl_key_file,
    ssl_chain_file          => $ssl_chain_file,
    ssl_cert_file_contents  => $ssl_cert_file_contents,
    ssl_key_file_contents   => $ssl_key_file_contents,
    ssl_chain_file_contents => $ssl_chain_file_contents,
    jenkins_ssh_private_key => $jenkins_ssh_private_key,
    jenkins_ssh_public_key  => $jenkins_ssh_public_key,
    project_config_repo     => $project_config_repo,
    project_config_base     => $project_config_base,
    jenkins_username        => $jenkins_username,
    jenkins_password        => $jenkins_password,
    jenkins_url             => "https://${vhost_name}/",
    manage_jenkins_jobs     => true,
  }
}
