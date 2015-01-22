require 'rails_helper'

RSpec.describe "Analysis", type: :request, js: true do

  before(:each) do
    @companies = FactoryGirl.create_list :company_with_investors, 5
    visit root_path
  end

  it 'loads the scatter plot' do
    click_link 'Scatter Plot'
    expect(page).to have_content('Money Raised (1,000,000 USD)') # makes sure the page has loaded
    expect_graph
  end

  it 'loads the line chart (time alive)' do
    click_link 'Line Chart (Time Alive)'
    expect(page).to have_content('Money Raised (1,000,000 USD)')# makes sure the page has loaded
    expect_graph
  end

  it 'loads the line chart (since 2005)' do
    click_link 'Line Chart (Since 2005)'
    expect(page).to have_content('Money Raised (1,000,000 USD)') # makes sure the page has loaded
    expect_graph
  end

  def expect_graph
    # TODO - poltergeist throws an error due to some js error 
    # to debug set the js errors to true in spec/rails_helper.rb
    # Capybara::Poltergesit::Driver.new(app, js_errors: true)
    expect(page).to have_css('svg') if Capybara.current_driver == :selenium
  end

end
