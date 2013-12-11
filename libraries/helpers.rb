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

    def get_ssl_certificate(name)
      # Require chef-vault.
      unless Chef::Config[:solo]
        begin
          require 'chef-vault'
        rescue LoadError
          Chef::Log.warn("Missing gem 'chef-vault', use chef_gem resource to install it first.")
        end
      end
      if Chef::Config[:solo]
        begin
          cert_data = data_bag_item(:certificates, name).to_hash
        rescue Chef::Exceptions::ValidationFailed
          Chef::Log.warn("Could not load certificate #{name} from data bag!")
        end
      else
        begin
          cert_data = ChefVault::Item.load(:certificates, name).to_hash
        rescue ChefVault::Exceptions::KeysNotFound
          Chef::Log.warn("Could not load certificate #{name} from vault!")
        end
      end
      cert_data
    end

  end
end
