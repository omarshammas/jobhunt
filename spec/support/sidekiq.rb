require 'sidekiq/testing'

RSpec.configure do |config|

  config.before(:each) do | example |
    # Clears out the jobs for tests using the fake testing
    Sidekiq::Worker.clear_all

    if example.metadata[:sidekiq] == :fake
      Sidekiq::Testing.fake!
    elsif example.metadata[:sidekiq] == :inline
      Sidekiq::Testing.inline!
    elsif example.metadata[:type] == :feature
      Sidekiq::Testing.inline!
    else
      Sidekiq::Testing.fake!
    end
  end

end

RSpec::Sidekiq.configure do |config|

  # rspec-sidekiq features, we don't want warnings
  # we know the jobs are being stored in array instead of redis
  config.warn_when_jobs_not_processed_by_sidekiq = false

end
