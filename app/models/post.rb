class Post < ActiveRecord::Base
  include Bootsy::Container

  belongs_to :user
end
