FactoryGirl.define do
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
end
