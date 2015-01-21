module UserHelpers
  
  def sign_in user
    expect(user.is_a? User).to be true
    visit new_user_session_path
    fill_in 'Email', with: user.email
    fill_in 'Password', with: user.password
    click_button 'Sign in'
  end

  def sign_out
    click_link 'Sign out'
  end

  def not_authorized path
    visit path
    expect(page).to have_text('You are not authorized to access this page')
    expect(current_path).to_not eq(path)
  end

  def requires_sign_in path
    visit path
    expect(page).to have_text('You need to sign in or sign up before continuing.')
    expect(current_path).to_not eq(path)
  end
end
