require 'rails_helper'

RSpec.describe "UserSessions", type: :request, js: true do

  before(:each) do
    visit root_path
    click_link 'Sign in'
  end

  it 'does not recognize the email' do
    fake_email = 'fake.email@example.com'
    fill_in_sign_in_form fake_email, 'test1234'

    expect(page).to have_content('Invalid email or password.')
    # email should be populated with prior data, but password should be blank
    expect(find_field('Email').value).to eq(fake_email)
    expect(find_field('Password').value).to be_empty
  end

  it 'invalid password' do
    user = FactoryGirl.create :user
    fill_in_sign_in_form user.email, 'fake password'

    expect(page).to have_content('Invalid email or password.')
    # email should be populated with prior data, but password should be blank
    expect(find_field('Email').value).to eq(user.email)
    expect(find_field('Password').value).to be_empty
  end

  it 'successfully signs in and out' do
    user = FactoryGirl.create :user

    sign_in user
    expect(page).to_not have_content('Invalid email or password')
    expect(current_path).to eq(root_path)

    sign_out
    expect(page).to have_content('Signed out successfully.')
    expect(current_path).to eq(root_path)
  end

  def fill_in_sign_in_form email, password
    fill_in 'Email', with: email
    fill_in 'Password', with: password
    click_button 'Sign in'
  end

end
