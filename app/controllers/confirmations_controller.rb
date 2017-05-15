class ConfirmationsController < Devise::ConfirmationsController
  def create
    user = User.find_by(email: params[:user][:email])
    if user.try(:guest?)
      user.send_reset_password_instructions
      flash[:notice] = 'Please check your email and click the "Set my password" link to complete your registration.'
      redirect_to sign_in_path
    else
      super
    end
  end
end
