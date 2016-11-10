class SystemCommand < Command
  def self.sudo(command)
    run("sudo #{command}")
  end
end
