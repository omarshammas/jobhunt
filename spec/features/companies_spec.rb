require 'rails_helper'

RSpec.describe "Companies", type: :request, js: true do

  describe 'Anonymous User' do
    before(:each) do
      @company = FactoryGirl.create :company
      visit companies_path
      expect(page).to have_selector(get_html_id(@company))
      expect(page).to_not have_link('New Company')
    end

    describe 'permissions' do
      it 'requires authentication to create or edit a company' do
        requires_sign_in new_company_path
        requires_sign_in edit_company_path(@company)
      end
    end
    it 'searches for a company' do
       @companies = FactoryGirl.create_list :company, 5
       @company1 = FactoryGirl.create :company, name: 'Happy Home'
       @company2 = FactoryGirl.create :company, name: 'Home Time'

       visit companies_path
       fill_in 'search', with: 'home'
       click_button 'Search'

       expect(page).to have_text('2 Companies')

       [@company1, @company2].each do |company|
         validate_company_in_table company
       end
       @companies.each do |company|
         expect(page).to_not have_text(company.name, wait: false)
       end
    end
    describe 'Rest actions' do
      it 'lists all companies' do
        @companies = FactoryGirl.create_list :company, 5
        refresh_page # because we created 5 companies that weren't on the page

        @companies.each do |company|
          validate_company_in_table company
        end
      end

      it 'shows a company' do
        click_link_in_row @company, 'Show'
        expect(page).to_not have_link('Edit', href: edit_company_path(@company))
        company_attributes.each do |attribute|
          expect(page).to have_content(@company.send(attribute))
        end
        expect(current_path).to eq(company_path(@company))
      end
    end
  end

  describe 'Admin' do
    before(:each) do
      @admin = FactoryGirl.create :admin
      sign_in @admin
    end

    it 'searches for a company' do
       @companies = FactoryGirl.create_list :company, 5
       @company1 = FactoryGirl.create :company, name: 'Happy Home'
       @company2 = FactoryGirl.create :company, name: 'Home Time'

       visit companies_path
       fill_in 'search', with: 'home'
       click_button 'Search'

       expect(page).to have_text('2 Companies')

       [@company1, @company2].each do |company|
         validate_company_in_table company
       end
       @companies.each do |company|
         expect(page).to_not have_text(company.name, wait: false)
       end
    end

    describe 'Rest Actions' do
      before(:each) do
        @company = FactoryGirl.create :company
        visit companies_path
        expect(page).to have_selector(get_html_id(@company))
      end

      it 'lists all companies' do
        @companies = FactoryGirl.create_list :company, 5
        refresh_page # because we created 5 companies that weren't on the page

        @companies.each do |company|
          validate_company_in_table company
        end
      end

      it 'create a company' do
        @new_company = FactoryGirl.build :company

        click_link 'New Company'
        fill_in_company_form @new_company

        expect(page).to have_content('Company was successfully created.')
        expect(current_path).to eq(company_path(Company.last))
        validate_last_company_in_db @new_company
      end

      it 'edits a company' do
        @new_company = FactoryGirl.build :company, :acquired, is_closed: !@company.is_closed

        click_link_in_row @company, 'Edit'
        fill_in_company_form @new_company

        expect(page).to have_content('Company was successfully updated.')
        expect(current_path).to eq(company_path(@company))
        validate_last_company_in_db @new_company
      end

      it 'shows a company' do
        click_link_in_row @company, 'Show'
        expect(page).to have_link('Edit', href: edit_company_path(@company))
        company_attributes.each do |attribute|
          expect(page).to have_content(@company.send(attribute))
        end
        expect(current_path).to eq(company_path(@company))
      end

      it 'destroys a company' do
        click_link_in_row @company, 'Destroy', true
        expect(page).to have_content('Company was successfully destroyed.')
        expect(current_path).to eq(companies_path)
        expect{@company.reload}.to raise_error(ActiveRecord::RecordNotFound)
      end
    end

  end

  def fill_in_company_form company
    ignore = %w{ total_money_raised_usd }
    dates = %w{founded_on acquired_on}
    checkboxes = %w{is_closed is_acquired}
    attributes = company_attributes - ignore - dates - checkboxes
    attributes.each do |attribute|
      fill_in "company[#{attribute}]", with: company.send(attribute)
    end

    checkboxes.each do |checkbox|
      name = "company[#{checkbox}]"
      company.send(checkbox) ? check(name) : uncheck(name)
    end

    dates.each do |date|
      if company.send(date)
        year, month, day = %w{year month day}.map { |attribute| company.send(date).send(attribute)}
        select year, from: "company[#{date}(1i)]"
        select Date::MONTHNAMES[month], from: "company[#{date}(2i)]"
        select day, from: "company[#{date}(3i)]"
      end
    end

    click_button 'Save'
  end

  def validate_company_in_table company
    within get_html_id(company) do
      %w{name headquarters}.each do |attribute|
        expect(page).to have_content(company.send(attribute))
      end
    end
    expect(page).to have_text(company.founded_on.to_s(:simple_date)) if company.founded_on
    expect(page).to have_text(number_to_currency(company.total_money_raised_usd, precision: 0)) if company.total_money_raised_usd
    expect(page).to have_link('Website', href: company.homepage_url) unless company.homepage_url.blank?
  end

  def validate_last_company_in_db company
    company_in_db = Company.last
    company_attributes.each do |attribute|
      expect(company_in_db.send(attribute)).to eq(company.send(attribute))
    end
  end

  def company_attributes
    @company.attributes.keys - %w{id created_at updated_at}
  end

end
