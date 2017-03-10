class PasswordsController < Devise::PasswordsController

  def after_resetting_password_path_for(resource)
    user_path(resource)
  end

end
