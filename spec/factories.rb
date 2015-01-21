FactoryGirl.define do

  factory :user do
    transient do
      sequence(:n) { |n| n }
    end
    email { "user#{n}@example.com" }
    password 'test1234'
    admin false

    factory :admin do
      admin true
    end
  end

  factory :company do
    transient do
      sequence(:n) { |n| n }
    end
    name { "Company #{n}" }
    homepage_url { "http://example.com/company-#{n}" }
    is_closed false
    short_description { "Short description of #{name}" }
    description { "Long Description of Company #{name}" }
    founded_on { (rand(10) + 1).years.ago.to_date }
    headquarters "Ottawa, Canada"
    crunchbase_url { "http://crunchbase.com/organization/company-#{n}" }
    logo_url { 'http://placehold.it/350x150&text=logo' }
    thumb_url { 'http://placehold.it/70X50&text=thumbnail' }
    angellist_quality  { rand(11) }

    trait :acquired do
      is_acquired true
      acquired_on Date.today
      acquired_by { "Example bought #{name}" }
    end

    factory :company_with_investors do
      transient do
        funding_rounds_count 3
        investors_count 2
      end
      after(:create) do |company, evaluator|
        create_list(:funding_round, evaluator.funding_rounds_count, company: company, investors_count: evaluator.investors_count)
      end
    end
  end

  factory :funding_round do
    transient do
      investors_count 3
    end
    company
    funding_type 'venture'
    money_raised_usd 1000000
    announced_on { (rand(10) + 1).months.ago.to_date }
    series 'A'

    after(:create) do |funding_round, evaluator|
      funding_round.investors += create_list(:investor, evaluator.investors_count)
    end
  end

  factory :investor do
    transient do
      sequence(:n) { |n| n }
    end
    name { "Investor #{n}" }
  end

  factory :job do
    transient do
      sequence(:n) { |n| n }
    end
    company
    title { "Software Developer #{n}" }
    angellist_job_id { n }
    description { "Description #{n}" }
    job_type "full-time"
    salary_min 100000
    salary_max 120000
    currency_code "USD"
    equity_min 0.1
    equity_max 0.5
    equity_cliff 1.0
    equity_vest 6.0
    remote_ok false
    tags ["coffeescript", "ruby on rails"]
  end
end
