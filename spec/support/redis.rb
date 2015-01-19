require 'fakeredis/rspec'

RSpec.configure do |config|

  config.before(:each) do | example |
    # clears out redis before each test
    Redis.new.flushall
  end

end

# https://github.com/guilleiguaran/fakeredis/issues/66
redis_opts = { url: 'redis://127.0.0.1:6379/1' }
# If fakeredis is loaded, use it explicitly
redis_opts.merge!(driver: Redis::Connection::Memory) if defined?(Redis::Connection::Memory)

Sidekiq.configure_client do |config|
  config.redis = redis_opts
end

Sidekiq.configure_server do |config|
  config.redis = redis_opts
end
