require 'rails_helper'

RSpec.describe "FundingRounds", type: :request, js: true do

  describe 'Ananonymous User' do
    before(:each) do
      @funding_round = FactoryGirl.create :funding_round
      visit funding_rounds_path
      expect(page).to have_selector(get_html_id(@funding_round))
      expect(page).to_not have_link('New Funding Round')
    end

    describe 'permissions' do
      it 'requires authentication to create or edit a funding round' do
        requires_sign_in new_funding_round_path
        requires_sign_in edit_funding_round_path(@funding_round)
      end
    end

    describe 'Rest actions' do
      it 'lists all funding_rounds' do
        @funding_rounds = FactoryGirl.create_list :funding_round, 5
        refresh_page # because we created 5 funding_rounds that weren't on the page

        @funding_rounds.each do |funding_round|
          validate_funding_round_in_table funding_round
        end
      end

      it 'shows a funding round' do
        click_link_in_row @funding_round, 'Show'
        expect(page).to_not have_link('Edit', href: edit_funding_round_path(@funding_round))
        funding_round_attributes.each do |attribute|
          expect(page).to have_content(@funding_round.send(attribute))
        end
        expect(current_path).to eq(funding_round_path(@funding_round))
      end
    end
  end

  describe 'Admin' do
    before(:each) do
      @admin = FactoryGirl.create :admin
      sign_in @admin
    end

    describe 'Rest actions' do
      before(:each) do
        @funding_round = FactoryGirl.create :funding_round
        visit funding_rounds_path
        expect(page).to have_selector(get_html_id(@funding_round))
      end

      it 'lists all funding_rounds' do
        @funding_rounds = FactoryGirl.create_list :funding_round, 5
        refresh_page # because we created 5 funding_rounds that weren't on the page

        @funding_rounds.each do |funding_round|
          validate_funding_round_in_table funding_round
        end
      end

      it 'create a funding round' do
        @new_funding_round = FactoryGirl.build :funding_round

        click_link 'New Funding Round'
        fill_in_funding_round_form @new_funding_round

        expect(page).to have_content('Funding Round was successfully created.')
        expect(current_path).to eq(funding_round_path(FundingRound.last))
        validate_last_funding_round_in_db @new_funding_round
      end

      it 'edits a funding round' do
        @new_funding_round = FactoryGirl.build :funding_round

        click_link_in_row @funding_round, 'Edit'
        fill_in_funding_round_form @new_funding_round

        expect(page).to have_content('Funding Round was successfully updated.')
        expect(current_path).to eq(funding_round_path(@funding_round))
        validate_last_funding_round_in_db @new_funding_round
      end

      it 'shows a funding round' do
        click_link_in_row @funding_round, 'Show'
        expect(page).to have_link('Edit', href: edit_funding_round_path(@funding_round))
        funding_round_attributes.each do |attribute|
          expect(page).to have_content(@funding_round.send(attribute))
        end
        expect(current_path).to eq(funding_round_path(@funding_round))
      end

      it 'destroys a funding round' do
        click_link_in_row @funding_round, 'Destroy'
        expect(page).to have_content('Funding Round was successfully destroyed.')
        expect(current_path).to eq(funding_rounds_path)
        expect{@funding_round.reload}.to raise_error(ActiveRecord::RecordNotFound)
      end
    end
  end

  def fill_in_funding_round_form funding_round
    attributes = funding_round_attributes - %w{announced_on}
    attributes.each do |attribute|
      fill_in "funding_round[#{attribute}]", with: funding_round.send(attribute)
    end

    if funding_round.announced_on
      year, month, day = %w{year month day}.map { |attribute| funding_round.announced_on.send(attribute)}
      select year, from: "funding_round[announced_on(1i)]"
      select Date::MONTHNAMES[month], from: "funding_round[announced_on(2i)]"
      select day, from: "funding_round[announced_on(3i)]"
    end

    click_button 'Save'
  end

  def validate_funding_round_in_table funding_round
    within get_html_id(funding_round) do
      %w{funding_type series}.each do |attribute|
        expect(page).to have_content(funding_round.send(attribute))
      end
      expect(page).to have_text(funding_round.company.name)
      expect(page).to have_text(funding_round.announced_on.to_s(:simple_date)) if funding_round.announced_on
      expect(page).to have_text(number_to_currency(funding_round.money_raised_usd, precision: 0)) if funding_round.money_raised_usd
    end
  end

  def validate_last_funding_round_in_db funding_round
    funding_round_in_db = FundingRound.last
    funding_round_attributes.each do |attribute|
      byebug if funding_round_in_db.send(attribute) != funding_round.send(attribute)
      expect(funding_round_in_db.send(attribute)).to eq(funding_round.send(attribute))
    end
  end

  def funding_round_attributes
    @funding_round.attributes.keys - %w{id created_at updated_at}
  end

end
