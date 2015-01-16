require 'fakeredis/rspec'
RSpec.configure do |config|

  config.before(:each) do | example |
    # clears out redis before each test
    Redis.new.flushall
  end

end
