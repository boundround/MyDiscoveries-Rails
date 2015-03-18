class SessionsController < Devise::SessionsController

  def new
    @set_body_class = 'passport-page'
    super
  end

  def create
    @set_body_class = 'passport-page'
    super
  end

end
