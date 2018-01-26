# Class: duo
# ===========================
#
# Main class that includes all other classes for the duo module.
#
# @param package_ensure Whether to install the duo package, and/or what version. Values: 'present', 'latest', or a specific version number. Default value: present.
# @param package_name Specifies the name of the package to install. Default value: 'duo'.
# @param service_enable Whether to enable the duo service at boot. Default value: true.
# @param service_ensure Whether the duo service should be running. Default value: 'running'.
# @param service_name Specifies the name of the service to manage. Default value: 'duo'.
#
class duo (
  Boolean                    $manage_prereqs  = true,
  Boolean                    $manage_repo     = true,
  String                     $package_ensure  = 'present',
  String                     $package_name    = 'duo_unix',
  Array                      $package_prereqs = [ 'openssl-devel', 'zlib-devel', ],
  String                     $repo_baseurl    = 'http://pkg.duosecurity.com/CentOS/$releasever/$basearch',
  String                     $repo_descr      = 'Duo Security Repository',
  Boolean                    $repo_enabled    = true,
  Enum['present', 'absent']  $repo_ensure     = 'present',
  Boolean                    $repo_gpgcheck   = true,
  String                     $repo_gpgkey     = 'https://duo.com/RPM-GPG-KEY-DUO',
  Boolean                    $service_enable  = true,
  Enum['running', 'stopped'] $service_ensure  = 'running',
  String                     $service_name    = 'duo',
  ) {
  case $::operatingsystem {
    'RedHat', 'CentOS': {
      case $::operatingsystemmajrelease {
        '7': {
          contain duo::repo
          contain duo::prereqs
          contain duo::install
          contain duo::config
          contain duo::service

          Class['duo::repo']
          -> Class['duo::prereqs']
          -> Class['duo::install']
          -> Class['duo::config']
          ~> Class['duo::service']
        }
        default: {
          fail("${::operatingsystem} ${::operatingsystemmajrelease} not supported")
        }
      }
    }
    default: {
      fail("${::operatingsystem} not supported")
    }
  }
}
