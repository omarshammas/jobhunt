class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

private

  def require_admin
    not_authorized unless current_user.try(:admin?)
  end

  def not_authorized
    redirect_to root_path, alert: 'You are not authorized to access this page.'
  end

end
