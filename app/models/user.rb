require 'mixpanel-ruby'

class User < ActiveRecord::Base

  ratyrate_rater

  attr_accessor :crop_x, :crop_y, :crop_w, :crop_h
  before_update :crop_avatar

  has_many :photos_users
  has_many :photos, through: :photos_users
  has_many :videos_users
  has_many :videos, through: :videos_users
  has_many :places_users
  has_many :favorite_places, through: :places_users, source: :place
  has_many :attractions_users
  has_many :favorite_attractions, through: :attractions_users, source: :attraction
  has_many :regions_users
  has_many :favorite_regions, through: :regions_users, source: :region
  has_many :countries_users
  has_many :favorite_countries, through: :countries_users, source: :country

  has_many :offers_users
  has_many :favorite_offers, through: :offers_users, source: :offer
  has_many :products_users, class_name: Spree::ProductsUser
  has_many :favorite_products,
    through: :products_users,
    class_name: Spree::Product,
    source: :product

  has_many :fun_facts_users
  has_many :fun_facts, through: :fun_facts_users
  has_many :posts_users
  has_many :posts, through: :posts_users

  has_many :places
  has_many :attractions

  has_many :identities

  has_many :reviews
  has_many :stories_users
  has_many :favourite_stories, through: :stories_users, :source => :story
  has_many :stories
  has_many :user_photos

  has_one :points_balance
  has_many :transactions

  # has_many :orders
  has_many :orders, class_name: Spree::Order

  has_many :customers

  mount_uploader :avatar, UserAvatarUploader
  process_in_background :avatar

  TEMP_EMAIL_PREFIX = 'change@me'
  TEMP_EMAIL_REGEX = /\Achange@me/

  rolify
  # Include default devise modules. Others available are:
  devise :database_authenticatable, :registerable, :confirmable,
         :recoverable, :rememberable, :trackable, :validatable, :timeoutable, :omniauthable, :authentication_keys => [:email],
         :omniauth_providers => [:facebook, :twitter, :google_oauth2]

  validates_format_of :email, :without => TEMP_EMAIL_REGEX, on: :update
  validates :password, confirmation: true
  
  before_update :update_hubspot_info

  after_create :store_to_hubspot
  after_commit :set_ax_cust_account!, on: :create
  after_commit :unset_guest_user,
    on: :update,
    if: -> (user) { user.guest? && user.encrypted_password? && !user.confirmed? }

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

  def crop_avatar
    if self.crop_x.to_i > 0 or  self.crop_y.to_i > 0 or  self.crop_w.to_i > 0 or  self.crop_h.to_i > 0
      self.avatar.recreate_versions!
      url_crop = self.avatar.url
      self.crop_x = nil
      self.crop_y = nil
      self.crop_w = nil
      self.crop_h = nil
      self.remote_avatar_url = url_crop
      self.save!
    end

    # self.avatar.recreate_versions!
  end

  def email_required?
    true
  end

  # def email_changed?
  #   true
  # end

  def timeout_in
    if self.admin?
      3.months
    else
      1.month
    end
  end

  def user_stories
    stories = self.posts
    stories += self.favourite_stories
  end

  def unset_guest_user
    update(guest: false, confirmed_at: DateTime.now)
  end

  def set_ax_cust_account!
    update_column(:ax_cust_account, "M#{1000000 + id}") unless created_from_ax
  end

  def store_to_hubspot
    Hubspot::Contact.create_or_update!([
      { email: self.email, 
        firstname: self.first_name.blank? ? self.email : self.first_name, 
        lastname: self.last_name, 
        phone: self.mobile.blank? ? self.home_phone : self.mobile 
      }
    ])
  end

  def update_hubspot_info
    if first_name_changed? || last_name_changed? || home_phone_changed? || mobile_changed?
      Hubspot::Contact.create_or_update!([
        { email: self.email, 
          firstname: self.first_name.blank? ? self.email : self.first_name, 
          lastname: self.last_name, 
          phone: self.mobile.blank? ? self.home_phone : self.mobile 
        }
      ])
    end
  end
end
