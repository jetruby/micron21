module Nginx
  class ConfigGenerator
    REQUIRED_CONFIG_PARAMS = %w(user worker_processes)

    def self.perform(config)
      new.perform(config)
    end

    def perform(config)
      return [false, nil] unless ensure_config_values(config)

      nginx_config_text = ::TemplateRendererService.perform(config, template_path)

      return [false, nil] unless nginx_config_text.present?

      temp_file = generate_temporary_config(nginx_config_text)

      return [false, nil] unless valid_config_file?(temp_file)

      [true, temp_file.path]
    end

    def ensure_config_values(config)
      REQUIRED_CONFIG_PARAMS.all? { |setting| config[setting.to_sym].present? }
    end

    def generate_temporary_config(nginx_config_text)
      temp_file = Tempfile.new('nginx.temp.config')
      temp_file.write nginx_config_text
      temp_file.close

      temp_file
    end

    def valid_config_file?(config_file)
      SystemCommand.sudo("nginx -t -c #{config_file.path}").success?
    end

    def template_path
      File.join APP_ROOT, 'config_templates', 'nginx.conf.erb'
    end
  end
end
