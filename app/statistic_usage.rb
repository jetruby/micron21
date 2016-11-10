require 'redis'

class StatisticUsage
  def self.register_usage(service)
    $redis.set(service, Time.now.to_i)
  end

  def self.get_last_usage(service)
    $redis.get(service)
  end
end
