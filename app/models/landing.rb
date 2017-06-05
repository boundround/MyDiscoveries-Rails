class Landing < ActiveRecord::Base
  belongs_to :user
  after_save :reload_routes

  def reload_routes
    DynamicRouter.reload
  end
end
