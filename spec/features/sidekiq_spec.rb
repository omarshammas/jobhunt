require 'rails_helper'

RSpec.describe 'Sidekiq', type: :request do

  it 'does not allow anonymous users' do
    visit root_path
    expect(page).to_not have_link('Sidekiq')
    requires_sign_in sidekiq_path
  end

  it 'allows access for admins' do
    @admin = FactoryGirl.create :admin
    sign_in @admin
    click_link 'Sidekiq'
    expect(current_path).to eq(sidekiq_path)
  end

end
