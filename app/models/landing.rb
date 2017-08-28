class Landing < ActiveRecord::Base
  after_save :reload_routes
  validates_uniqueness_of :from_url

  after_destroy :reload_routes

  has_paper_trail

  def reload_routes
    DynamicRouter.reload  		
  end

  def unique_routes(new_routes)
  	all_routes = Rails.application.routes.routes
  	paths  = all_routes.collect {|r| r.path.spec.to_s if r.path.spec.to_s.split('/').size.eql?(2) }.compact

  	return paths.include?('/'+new_routes+'(.:format)')
  end
end
