class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception, unless: :json_request?
  protect_from_forgery with: :null_session, if: :json_request?

  before_action :configure_permitted_parameters, if: :devise_controller?

  protected

  def json_request?
    request.format.json?
  end

  def configure_permitted_parameters
    permitted_parameters = devise_parameter_sanitizer.instance_values['permitted']
    attributes = [:username, :email, :password, :password_confirmation, :remember_me, :current_password]
    attributes.each do |attribute|
      permitted_parameters[:sign_up] << attribute
      permitted_parameters[:sign_in] << attribute
      permitted_parameters[:account_update] << attribute
    end
  end

  def current_user?(user)
    current_user.id == user.id
  end

  helper_method :current_user?
end
