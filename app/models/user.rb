require 'mixpanel-ruby'

class User < ActiveRecord::Base

  ratyrate_rater

  has_many :photos_users
  has_many :photos, through: :photos_users
  has_many :videos_users
  has_many :videos, through: :videos_users
  has_many :places_users
  has_many :favorite_places, through: :places_users, source: :place
  has_many :attractions_users
  has_many :favorite_attractions, through: :attractions_users, source: :attraction
  has_many :fun_facts_users
  has_many :fun_facts, through: :fun_facts_users
  has_many :posts_users
  has_many :posts, through: :posts_users

  has_many :customers_places
  has_many :owned_places, through: :customers_places, :source => :place

  has_many :places
  has_many :attractions

  has_many :identities

  has_many :reviews
  has_many :stories_users
  has_many :stories, through: :stories_users
  has_many :user_photos

  has_one :points_balance
  has_many :transactions

  mount_uploader :avatar, UserAvatarUploader
  process_in_background :avatar

  TEMP_EMAIL_PREFIX = 'change@me'
  TEMP_EMAIL_REGEX = /\Achange@me/

  rolify
  # Include default devise modules. Others available are:
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable, :timeoutable, :omniauthable, :authentication_keys => [:email],
         :omniauth_providers => [:facebook, :twitter, :google_oauth2]

  validates_format_of :email, :without => TEMP_EMAIL_REGEX, on: :update
  validates :password, confirmation: true

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
      email = auth.info.email # if email_is_verified
      user = User.where(:email => email).first if email

      # Create the user if it's a new registration
      if user.nil?
        puts auth.info.name
        puts auth.info
        user = User.new(
          name: auth.info.name,
          username: auth.info.nickname || auth.uid,
          email: email ? email : "#{TEMP_EMAIL_PREFIX}-#{auth.uid}-#{auth.provider}.com",
          password: Devise.friendly_token[0,20]
        )
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

  def email_required?
    true
  end

  def email_changed?
    true
  end

  def timeout_in
    if self.admin?
      3.months
    else
      1.month
    end
  end

  def user_stories
    stories = self.posts
    stories += self.stories
  end

end
