module ApplicationHelper

  def get_html_id resource
    "#{resource.class.to_s.underscore}_#{resource.id}"
  end

end
