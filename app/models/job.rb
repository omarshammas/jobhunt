class Job < ActiveRecord::Base
  include ActionView::Helpers::NumberHelper
  belongs_to :company

  def angellist_url
    "https://angel.co/#{company.permaname}/jobs/#{angellist_job_id}" if angellist_job_id
  end

  def compensation_summary
    summary =  ""
    if salary_min && salary_max
      summary += "$ #{number_in_k(salary_min)} - #{number_in_k(salary_max)}"
    end
    if equity_min && equity_max
      summary += "  ·  " unless summary.blank?
      summary += "#{equity_min} - #{equity_max} %"
    end
    summary
  end

  def tags= value
    if value.is_a? Array
      write_attribute(:tags, value)
    elsif value.is_a? String
      write_attribute(:tags, value.split(',').map(&:strip))
    end
  end

private

  def number_in_k number
    number_to_human(number, units: {thousand: 'K'})
  end
end
