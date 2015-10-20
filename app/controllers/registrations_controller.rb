class RegistrationsController < Devise::RegistrationsController
  before_filter :update_sanitized_params, if: :devise_controller?

  def update_sanitized_params
    devise_parameter_sanitizer.for(:sign_up) {|u| u.permit(:name, :email, :username, :country, :promo_code, :password, :password_confirmation, :avatar, :date_of_birth)}
    devise_parameter_sanitizer.for(:account_update) {|u| u.permit(:name, :email, :password, :password_confirmation, :current_password, :avatar, :date_of_birth)}
  end

  def edit
    @set_body_class = 'passport-page'
    super
  end

  def update
    super
    flash.delete(:notice)
  end

  def new
    @set_body_class = 'passport-page'
    super
  end

  def create
    @set_body_class = 'passport-page'
    super
  end

  protected

  def after_sign_up_path_for(resource)
    user_path(resource)
  end

  def after_inactive_sign_up_path_for(resource)
    user_path(resource)
  end

end
