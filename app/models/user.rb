class User < ActiveRecord::Base
  has_many :photos_users
  has_many :photos, through: :photos_users
  has_many :videos_users
  has_many :videos, through: :videos_users
  has_many :games_users
  has_many :games, through: :games_users
  has_many :areas_users
  has_many :areas, through: :areas_users
  has_many :places_users
  has_many :places, through: :places_users
  has_many :fun_facts_users
  has_many :fun_facts, through: :fun_facts_users

  mount_uploader :avatar, UserPhotoUploader
  process_in_background :avatar

  TEMP_EMAIL_PREFIX = 'change@me'
  TEMP_EMAIL_REGEX = /\Achange@me/

  rolify
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable
  devise :omniauthable, :omniauth_providers => [:facebook, :instagram]

  validates_format_of :email, :without => TEMP_EMAIL_REGEX, on: :update

  # def self.find_for_facebook_oauth(auth)
  #   where(auth.slice(:provider, :uid)).first_or_create do |user|
  #       user.provider = auth.provider
  #       user.uid = auth.uid
  #       user.email = auth.info.email
  #       user.password = Devise.friendly_token[0,20]
  #       # user.name = auth.info.name   # assuming the user model has a name
  #       # user.image = auth.info.image # assuming the user model has an image
  #   end
  # end

  # def self.new_with_session(params, session)
  #   super.tap do |user|
  #     if data = session["devise.facebook_data"] && session["devise.facebook_data"]["extra"]["raw_info"]
  #       user.email = data["email"] if user.email.blank?
  #     end
  #   end
  # end

  def self.find_for_oauth(auth, signed_in_resource = nil)

    # Get the identity and user if they exist
    identity = Identity.find_for_oauth(auth)

    # If a signed_in_resource is provided it always overrides the existing user
    # to prevent the identity being locked with accidentally created accounts.
    # Note that this may leave zombie accounts (with no associated identity) which
    # can be cleaned up at a later date.
    user = signed_in_resource ? signed_in_resource : identity.user

    # Create the user if needed
    if user.nil?

      # Get the existing user by email if the provider gives us a verified email.
      # If no verified email was provided we assign a temporary email and ask the
      # user to verify it on the next step via UsersController.finish_signup
      # email_is_verified = auth.info.email && (auth.info.verified || auth.info.verified_email)
      email = auth.info.email # if email_is_verified
      user = User.where(:email => email).first if email

      # Create the user if it's a new registration
      if user.nil?
        puts auth.info.name
        puts auth.info
        user = User.new(
          name: auth.info.name,
          #username: auth.info.nickname || auth.uid,
          email: email ? email : "#{TEMP_EMAIL_PREFIX}-#{auth.uid}-#{auth.provider}.com",
          password: Devise.friendly_token[0,20]
        )
        # user.skip_confirmation!
        user.save!
      end
    end

    # Associate the identity with the user if needed
    if identity.user != user
      identity.user = user
      identity.save!
    end
    user
  end

end
