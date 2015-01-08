module CapybaraHelpers

  def accept_dialog_box
    page.driver.browser.switch_to.alert.accept if Capybara.current_driver == :selenium
  end

  def refresh_page
    visit current_path
  end

  def click_link_in_row resource, link_text, expecting_dialog=false
    within get_html_id(resource) do
      click_link link_text
    end
    accept_dialog_box if expecting_dialog
  end

  def get_html_id resource
    "##{resource.class.to_s.underscore}_#{resource.id}"
  end

end
