require 'rails_helper'

RSpec.describe "Investors", type: :request, js: true do

  describe 'Ananonymous User' do
    before(:each) do
      @investor = FactoryGirl.create :investor
      visit investors_path
      expect(page).to have_selector(get_html_id(@investor))
      expect(page).to_not have_link('New Investor')
    end

    describe 'permissions' do
      it 'requires authentication to create or edit a investor' do
        requires_sign_in new_investor_path
        requires_sign_in edit_investor_path(@investor)
      end
    end

    it 'searches for an investor' do
       @investors = FactoryGirl.create_list :investor, 5
       @investor1 = FactoryGirl.create :investor, name: 'Home Ventures'
       @investor2 = FactoryGirl.create :investor, name: 'Venture Time'

       visit investors_path
       fill_in 'search', with: 'venture'
       click_button 'Search'

       expect(page).to have_text('2 Investors')

       [@investor1, @investor2].each do |investor|
         validate_investor_in_table investor
       end
       @investors.each do |investor|
         expect(page).to_not have_text(investor.name, wait: false)
       end
    end

    describe 'Rest actions' do
      it 'lists all investors' do
        @investors = FactoryGirl.create_list :investor, 5
        refresh_page # because we created 5 investors that weren't on the page

        @investors.each do |investor|
          validate_investor_in_table investor
        end
      end

      it 'shows a investor' do
        click_link_in_row @investor, 'Show'
        expect(page).to_not have_link('Edit', href: edit_investor_path(@investor))
        investor_attributes.each do |attribute|
          expect(page).to have_content(@investor.send(attribute))
        end
        expect(current_path).to eq(investor_path(@investor))
      end
    end
  end

  describe 'Admin' do
    before(:each) do
      @admin = FactoryGirl.create :admin
      sign_in @admin
    end

    it 'searches for an investor' do
       @investors = FactoryGirl.create_list :investor, 5
       @investor1 = FactoryGirl.create :investor, name: 'Home Ventures'
       @investor2 = FactoryGirl.create :investor, name: 'Venture Time'

       visit investors_path
       fill_in 'search', with: 'venture'
       click_button 'Search'

       expect(page).to have_text('2 Investors')

       [@investor1, @investor2].each do |investor|
         validate_investor_in_table investor
       end
       @investors.each do |investor|
         expect(page).to_not have_text(investor.name, wait: false)
       end
    end


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
        expect(page).to have_link('Edit', href: edit_investor_path(@investor))
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
