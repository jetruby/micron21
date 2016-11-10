require_relative 'nginx.rb'

class InterfaceManager
  INTERFACES = {
    'nginx' => Nginx::ServiceInterface
  }

  def self.resolve(service)
    INTERFACES[service]
  end
end
