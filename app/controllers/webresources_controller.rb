class WebresourcesController < ApplicationController
  before_action :redirect_if_not_admin, :except => [] end

