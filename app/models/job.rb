class Job < ActiveRecord::Base
  belongs_to :company

  def angellist_url
    "https://angel.co/angellist/jobs/#{angellist_job_id}" if angellist_job_id
  end
end
