FactoryGirl.define do
  factory :company do
    transient do
      sequence(:n) { |n| n }
    end
    name { "Company #{n}" }
    homepage_url { "http://example.com/company-#{n}" }
    short_description { "Short description of #{name}" }
    description { "Long Description of Company #{name}" }
    founded_on { (rand(10) + 1).years.ago.to_date }
    headquarters "Ottawa, Canada"
  end

  factory :funding_round do
    company
    funding_type 'venture'
    money_raised_usd 1000000
    announced_on { (rand(10) + 1).months.ago.to_date }
    series 'A'
  end
end
