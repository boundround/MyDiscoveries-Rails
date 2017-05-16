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
    flash.delete(:notice)
  end

  def create
    @set_body_class = 'passport-page'
    user = User.find_by(email: params[:user][:email])
    if user.try(:guest?)
      user.send_reset_password_instructions
      flash[:notice] = 'Please check your email and click the "Set my password" link to complete your registration.'
      redirect_to sign_in_path
    else
      super
    end
  end

  protected

  def after_sign_up_path_for(resource)
    if session[:previous_path].blank?
      URI(request.referer || '').path
    else
      session.delete(:previous_path)
    end
  end

  def after_inactive_sign_up_path_for(resource)
    flash[:notice] = 'Please check your email and click the "Confirm my account" link to complete your registration.'
    root_path
  end

end
