module SidekiqHelpers

  def get_redis key
    Sidekiq.redis do |conn|
      return conn.get(key)
    end
  end

  def set_redis key, value
    Sidekiq.redis do |conn|
      return conn.set(key, value)
    end
  end

end
