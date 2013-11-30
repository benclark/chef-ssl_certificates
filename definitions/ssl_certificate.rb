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
  cert = search(:certificates, "name:#{name}").first

  raise "Could not find a data bag item with 'name:#{name}' in the 'certificates' data bag" if cert.nil?

  directory node[:ssl_certificates][:path] do
    owner 'root'
    group 'ssl-cert'
    mode '0640'
  end

  if cert['crt']
    certfile_content = cert['crt']

    if cert['ca_bundle'] && params[:ca_bundle_combined]
        certfile_content += "\n" + cert['ca_bundle']
    end

    file "#{node[:ssl_certificates][:path]}/#{name}.crt" do
      content certfile_content
      owner 'root'
      group 'ssl-cert'
      mode '0640'
    end
  end

  if cert['ca_bundle'] && ! params[:ca_bundle_combined]
    file "#{node[:ssl_certificates][:path]}/#{name}.ca-bundle" do
      content cert['ca_bundle']
      owner 'root'
      group 'ssl-cert'
      mode '0640'
    end
  end

  if cert['key']
    file "#{node[:ssl_certificates][:path]}/#{name}.key" do
      content cert['key']
      owner 'root'
      group 'ssl-cert'
      mode '0640'

    end
  end

  if cert['pem']
    file "#{node[:ssl_certificates][:path]}/#{name}.pem" do
      content cert['pem']
      owner 'root'
      group 'ssl-cert'
      mode '0640'
    end
  end
end
