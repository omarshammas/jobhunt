require 'rails_helper'

RSpec.describe "Analysis", type: :request, js: true do

  before(:each) do
    @company1 = FactoryGirl.create :company
    FactoryGirl.create(:funding_round, money_raised_usd: 500000, company: @company1)
    @company1.reload
    @company1.save!

    @company2 = FactoryGirl.create :company
    FactoryGirl.create(:funding_round, money_raised_usd: 20000000, company: @company2)
    @company2.reload
    @company2.save!

    @company3 = FactoryGirl.create :company
    FactoryGirl.create(:funding_round, money_raised_usd: 50000000, company: @company3)
    @company3.reload
    @company3.save!

    visit root_path
  end

  it 'loads the scatter plot' do
    click_link 'Scatter Plot'
    expect(page).to have_content('Money Raised (1,000,000 USD)') # makes sure the page has loaded
    expect(page).to have_text('2 Companies')
    expect_graph

    move_slider_to 0, 50000000
    expect(page).to have_content('Money Raised (1,000,000 USD)') # makes sure the page has loaded
    expect(page).to have_text('3 Companies')
    expect_graph
  end

  it 'loads the line chart (time alive)' do
    click_link 'Line Chart (Time Alive)'
    expect(page).to have_content('Money Raised (1,000,000 USD)')# makes sure the page has loaded
    expect(page).to have_text('2 Companies')
    expect_graph

    move_slider_to 0, 50000000
    expect(page).to have_content('Money Raised (1,000,000 USD)') # makes sure the page has loaded
    expect(page).to have_text('3 Companies')
    expect_graph
  end

  it 'loads the line chart (since 2005)' do
    click_link 'Line Chart (Since 2005)'
    expect(page).to have_content('Money Raised (1,000,000 USD)') # makes sure the page has loaded
    expect(page).to have_text('2 Companies')
    expect_graph

    move_slider_to 0, 50000000
    expect(page).to have_content('Money Raised (1,000,000 USD)') # makes sure the page has loaded
    expect(page).to have_text('3 Companies')
    expect_graph
  end

  def expect_graph
    # TODO - poltergeist throws an error due to some js error 
    # to debug set the js errors to true in spec/rails_helper.rb
    # Capybara::Poltergesit::Driver.new(app, js_errors: true)
    expect(page).to have_css('svg') if Capybara.current_driver == :selenium
  end

  def move_slider_to min, max
    page.execute_script("$('#slider-range').slider({values: [#{min},#{max}]});")
    page.execute_script("$('#slider-range').slider('option', 'slide')(null, {values: $('#slider-range').slider('option', 'values')});")
    click_button 'Go'
  end

end
