require 'rails_helper'

RSpec.describe "Investors", type: :request, js: true do

  describe 'Rest actions' do
    before(:each) do
      @investor = FactoryGirl.create :investor
      visit investors_path
      expect(page).to have_selector(get_html_id(@investor))
    end

    it 'lists all investors' do
      @investors = FactoryGirl.create_list :investor, 5
      refresh_page # because we created 5 investors that weren't on the page

      @investors.each do |investor|
        validate_investor_in_table investor
      end
    end

    it 'create a investor' do
      @new_investor = FactoryGirl.build :investor

      click_link 'New Investor'
      fill_in_investor_form @new_investor

      expect(page).to have_content('Investor was successfully created.')
      expect(current_path).to eq(investor_path(Investor.last))
      validate_last_investor_in_db @new_investor
    end

    it 'edits a investor' do
      @new_investor = FactoryGirl.build :investor

      click_link_in_row @investor, 'Edit'
      fill_in_investor_form @new_investor

      expect(page).to have_content('Investor was successfully updated.')
      expect(current_path).to eq(investor_path(@investor))
      validate_last_investor_in_db @new_investor
    end

    it 'shows a investor' do
      click_link_in_row @investor, 'Show'
      investor_attributes.each do |attribute|
        expect(page).to have_content(@investor.send(attribute))
      end
      expect(current_path).to eq(investor_path(@investor))
    end

    it 'destroys a investor' do
      click_link_in_row @investor, 'Destroy'
      expect(page).to have_content('Investor was successfully destroyed.')
      expect(current_path).to eq(investors_path)
      expect{@investor.reload}.to raise_error(ActiveRecord::RecordNotFound)
    end
  end

  def fill_in_investor_form investor
    attributes = investor_attributes
    attributes.each do |attribute|
      fill_in "investor[#{attribute}]", with: investor.send(attribute)
    end

    click_button 'Save'
  end

  def validate_investor_in_table investor
    within get_html_id(investor) do
      %w{name}.each do |attribute|
        expect(page).to have_content(investor.send(attribute))
      end
    end
  end

  def validate_last_investor_in_db investor
    investor_in_db = Investor.last
    investor_attributes.each do |attribute|
      expect(investor_in_db.send(attribute)).to eq(investor.send(attribute))
    end
  end

  def investor_attributes
    @investor.attributes.keys - %w{id created_at updated_at}
  end

end