class Users::OmniauthCallbacksController < Devise::OmniauthCallbacksController
  # def facebook
  #   @user = User.find_for_facebook_oauth(request.env["omniauth.auth"])

  #   if @user.persisted?
  #     sign_in_and_redirect @user, :event => :authentication #this will throw if @user is not activated
  #     set_flash_message(:notice, :success, :kind => "Facebook") if is_navigational_format?
  #   else
  #     session["devise.facebook_data"] = request.env["omniauth.auth"]
  #     redirect_to new_user_registration_url
  #   end
  # end

  def self.provides_callback_for(provider)
    class_eval %Q{
      def #{provider}
        auth = env["omniauth.auth"]
        @user = User.find_for_oauth(auth, current_user)
        session["access_token"] = auth.credentials.token
        if @user.persisted?
          sign_in_and_redirect @user, event: :authentication
          set_flash_message(:notice, :success, kind: "#{provider}".capitalize) if is_navigational_format?
          flash[:recently_signed_in_with_instagram] = 'Recently signed in with instagram'
        else
          session["devise.#{provider}_data"] = env["omniauth.auth"]
          flash[:recently_failed_signed_in_with_instagram] = 'Recently failed signed in with instagram'
          redirect_to new_user_registration_url
        end
      end
    }
  end

  [:instagram, :facebook].each do |provider|
    provides_callback_for provider
  end

  # def after_sign_in_path_for(resource)
  #   if resource.email_verified?
  #     super resource
  #   else
  #     finish_signup_path(resource)
  #   end
  # end

end
