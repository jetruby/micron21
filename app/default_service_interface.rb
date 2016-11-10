module DefaultServiceInterface
  def self.included(base)
    base.extend(ClassMethods)
  end
  
  module ClassMethods
    def reboot
      raise 'Not implemented'
    end

    def update_config(config)
      raise 'Not implemented'
    end
  end
end
