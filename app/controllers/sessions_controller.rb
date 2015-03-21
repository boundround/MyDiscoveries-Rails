class SessionsController < Devise::SessionsController

  def new
    @set_body_class = 'passport-page'
    super
    flash.delete(:notice)
  end

  def create
    @set_body_class = 'passport-page'
    super
    flash.delete(:notice)
  end

end
