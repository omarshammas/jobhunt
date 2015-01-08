module CapybaraHelpers

  def accept_dialog_box
    page.driver.browser.switch_to.alert.accept if Capybara.current_driver == :selenium
  end

  def refresh_page
    visit current_path
  end

end
