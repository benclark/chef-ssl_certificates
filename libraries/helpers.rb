#
# Cookbook Name:: ssl_certificates
# Libraries:: helpers
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

class Chef
  class Recipe

    def get_ssl_certificate(name, environment = nil)
      environment ||= node.chef_environment
      cache = get_ssl_certificate_cache(environment)
      cache[name] || node.run_state['ssl_certificates'][environment][name] = fetch_ssl_certificate(name, environment)
    end

    def fetch_ssl_certificate(name, environment = nil)
      environment ||= node.chef_environment
      Chef::Log.info("Fetching ssl certificate for #{name} in #{environment} environment")
      if Chef::Config[:solo]
        begin
          cert_data = data_bag_item(:certificates, name).to_hash
        rescue Chef::Exceptions::ValidationFailed
          Chef::Log.warn("Could not load certificate #{name} from data bag!")
        end
      else
        cert_secret = Chef::EncryptedDataBagItem.load_secret(node['ssl_certificates']['secretfile'])
        cert_data = Chef::EncryptedDataBagItem.load(:certificates, name, cert_secret).to_hash
      end
      cert_data = prep_ssl_certificate(cert_data, environment)
      prep_ssl_certificate_paths(cert_data)
    end

    def prep_ssl_certificate(cert_data, environment = nil)
      environment ||= node.chef_environment
      if !cert_data['environments'].nil? && !cert_data['environments'][environment].nil?
        cert_data.merge(cert_data['environments'][environment])
      else
        cert_data
      end
    end

    def prep_ssl_certificate_paths(cert_data)
      cert_data['path'] ||= node[:ssl_certificates][:path]
      cert_data['private_path'] ||= node[:ssl_certificates][:private_path]

      cert_data['crt_path'] ||= "#{node[:ssl_certificates][:path]}/#{cert_data['id']}.crt"
      cert_data['ca_bundle_path'] ||= "#{node[:ssl_certificates][:path]}/#{cert_data['id']}.ca-bundle"
      cert_data['key_path'] ||= "#{node[:ssl_certificates][:private_path]}/#{cert_data['id']}.key"
      cert_data['pem_path'] ||= "#{node[:ssl_certificates][:path]}/#{cert_data['id']}.pem"

      cert_data
    end

    def get_ssl_certificate_cache(environment)
      node.run_state['ssl_certificates'] ||= {}
      node.run_state['ssl_certificates'][environment] ||= {}
    end
  end
end
