## DESCRIPTION

[![Build Status](https://travis-ci.org/TYPO3-cookbooks/ssl_certificates.png)](https://travis-ci.org/TYPO3-cookbooks/ssl_certificates)

Installs and configures SSL certificates for a node.

This cookbook is inspired by the 37 Signals SSL certificates cookbook.

## REQUIREMENTS

Only tested on Debian 6.0.

## USAGE

SSL certificates are defined in the "certificates" cookbook.

````javascript
{
  "id": "my_ssl_cert",
  "name": "ssl.example.com",
  "key": "[raw SSL key]",
  "crt": "[raw SSL crt]",
  "pem": "[raw SSL pem]",
  "ca_bundle": "[raw SSL ca-bundle]"
}
````

To install a SSL certificate on a node, use the SSL certificate definition in
your recipe, like this:

````
ssl_certificate 'ssl.example.com'
````
To create a certificate file combined of the `crt` and the `ca-bundle` (e.g. for nginx), set the attribute `ca_bundle_combined`:

````
ssl_certificate `ssl.example.com` do
  ca_bundle_combined true
end
````
