class Users::UserPasswordController < Devise::RegistrationsController

  def update_password 

    user = current_user

    if user.update_with_password(permit_resource_params)
      sign_in user, :bypass => true
      render  json: {success:true}
    else
      clean_up_passwords(user)
      render json: {success:false, messages: "Please check your input: #{user.errors.full_messages.to_sentence}" }
  
    end

  end
  
  end

  private

  def permit_resource_params
    params.require(:user).permit(:password, :password_confirmation, :current_password, :email)
  end