class Users::AccountsController < ApplicationController

  def forgot_username;end
  
  def send_username
    debugger

      @user = User.find_by_email(params[:user][:email])
      if @user.blank?
          redirect_to(users_username_new_path, notice: 'Username can not be blank')
      else
        @username = @user.username
        @email = params[:user][:email]
        ForgotUsername.send_username(@email,@username).deliver
        redirect_to(new_user_session_path, notice: 'Username has been sent')
      end
  end

end
