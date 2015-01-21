#
# Cookbook Name:: ssl_certificates
# Definition:: ssl_certificate
#
# Copyright 2011-2012, Binary Marbles Trond Arve Nordheim
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

define :ssl_certificate do
  name = params[:name] =~ /\*\.(.+)/ ? "#{$1}_wildcard" : params[:name]
  Chef::Log.info "Looking for SSL certificate #{name.inspect}"

  cert = get_ssl_certificate(name)

  raise "Could not find a data bag item with 'name:#{name}' in the 'certificates' data bag" if cert.nil?

  # Create the directory where SSL certificates will be stored.
  directory cert['path'] do
    owner 'root'
    group 'root'
    mode '0755'
  end

  # Create the directory where SSL private keys will be stored.
  directory cert['private_path'] do
    owner 'root'
    group 'root'
    mode '0700'
  end

  if cert['crt']
    certfile_content = cert['crt']

    if cert['ca_bundle'] && params[:ca_bundle_combined]
        certfile_content += "\n" + cert['ca_bundle']
    end

    file cert['crt_path'] do
      content certfile_content
      owner 'root'
      group 'root'
      mode '0644'
    end
  end

  file cert['ca_bundle_path'] do
    content cert['ca_bundle']
    owner 'root'
    group 'root'
    mode '0644'
    only_if { cert['ca_bundle'] && ! params[:ca_bundle_combined] }
  end

  file cert['key_path'] do
    content cert['key']
    owner 'root'
    group 'root'
    mode '0600'
    only_if { cert['key'] }
  end

  file cert['pem_path'] do
    content cert['pem']
    owner 'root'
    group 'root'
    mode '0644'
    only_if { cert['pem'] }
  end
end
