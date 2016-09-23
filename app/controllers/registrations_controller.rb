class RegistrationsController < Devise::RegistrationsController
  before_filter :update_sanitized_params, if: :devise_controller?

  def update_sanitized_params
    devise_parameter_sanitizer.permit(:sign_up) {|u| u.permit({ role_ids: [] }, :name, :email, :username, :country, :promo_code, :password, :password_confirmation, :avatar, :date_of_birth)}
    devise_parameter_sanitizer.permit(:account_update) {|u| u.permit({ role_ids: [] },:name, :email, :password, :password_confirmation, :username, :current_password, :avatar, :date_of_birth)}
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
    unless params[:flag].blank?
      session[:previous_path] = request.referer
    end
    @set_body_class = 'passport-page'
    super
  end

  def create
    @set_body_class = 'passport-page'
    super
  end

  protected

  def after_sign_up_path_for(resource)
    if session[:previous_path].blank?
      edit_user_path(resource)
    else
      session.delete(:previous_path)
    end
  end

  def after_inactive_sign_up_path_for(resource)
    edit_user_path(resource)
  end

end
