require 'tempfile'
require_relative '../default_service_interface'

module Nginx
  class ServiceInterface
    include DefaultServiceInterface

    CONFIG_FILE_PATH = '/etc/nginx/nginx.conf'

    def self.reboot
      SystemCommand.sudo('service nginx restart')
    end

    def self.update_config(config)
      success, new_config_file_path = ConfigGenerator.perform(config)
      return false unless success

      SystemCommand.sudo("mv -f #{new_config_file_path} #{CONFIG_FILE_PATH}")
      reboot

      true
    end
  end
end
