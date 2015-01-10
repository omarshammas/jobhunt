require 'rails_helper'

RSpec.describe "Companies", type: :request, js: true do

  describe 'Rest actions' do
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
      @new_company = FactoryGirl.build :company

      click_link_in_row @company, 'Edit'
      fill_in_company_form @new_company

      expect(page).to have_content('Company was successfully updated.')
      expect(current_path).to eq(company_path(@company))
      validate_last_company_in_db @new_company
    end

    it 'shows a company' do
      click_link_in_row @company, 'Show'
      company_attributes.each do |attribute|
        expect(page).to have_content(@company.send(attribute))
      end
      expect(current_path).to eq(company_path(@company))
    end

    it 'destroys a company' do
      click_link_in_row @company, 'Destroy'
      expect(page).to have_content('Company was successfully destroyed.')
      expect(current_path).to eq(companies_path)
      expect{@company.reload}.to raise_error(ActiveRecord::RecordNotFound)
    end
  end

  def fill_in_company_form company
    attributes = company_attributes - %w{founded_on}
    attributes.each do |attribute|
      fill_in "company[#{attribute}]", with: company.send(attribute)
    end

    if company.founded_on
      year, month, day = %w{year month day}.map { |attribute| company.founded_on.send(attribute)}
      select year, from: "company[founded_on(1i)]"
      select Date::MONTHNAMES[month], from: "company[founded_on(2i)]"
      select day, from: "company[founded_on(3i)]"
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
