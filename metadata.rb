maintainer       'Trond Arve Nordheim'
maintainer_email 't@binarymarbles.com'
license          'Apache 2.0'
description      'Installs and configures SSL certificates.'
long_description IO.read(File.join(File.dirname(__FILE__), 'README.md'))
version          '1.1.1'

supports         'debian'

recipe           'ssl_certificates', 'Installs and configures SSL certificates.'

attribute 'ssl_certificates',
  :display_name => 'SSL certificates',
  :description => 'Hash of SSL certificate attributes.',
  :type => 'hash'

attribute 'ssl_certificates/path',
  :display_name => 'Path',
  :description => 'The path where SSL certificates will be stored.',
  :default => '/etc/ssl_certs'
