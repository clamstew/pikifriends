class Admin::DashboardController < ApplicationController
  
  before_filter :admin_required
  layout "admin"
  protect_from_forgery
  
  
end
