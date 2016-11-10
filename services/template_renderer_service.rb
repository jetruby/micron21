require 'erb'

class TemplateRendererService
  def self.perform(config, template_path)
    config.each do |key, value|
      instance_variable_set("@#{key}", value)
    end

    file_contents = File.read(template_path)

    ERB.new(file_contents).result(binding)
  end
end
