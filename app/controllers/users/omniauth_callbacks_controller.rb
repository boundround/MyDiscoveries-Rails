class Users::OmniauthCallbacksController < Devise::OmniauthCallbacksController

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

  [:instagram, :facebook, :google_oauth2].each do |provider|
    provides_callback_for provider
  end

end
