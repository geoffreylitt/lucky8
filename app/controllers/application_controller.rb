class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  before_action :send_flash_to_gon

  # Put flash messages in gon so that we can display them using JS
  def send_flash_to_gon
    gon.flash = flash.to_hash.values
  end

  def saved(school)
    current_user && current_user.schools.include?(school)
  end
  helper_method :saved

  def after_sign_in_path_for(user)
    schools_path
  end
end
