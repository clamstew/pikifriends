class Admin::AnalyzeController < ApplicationController
  
  before_filter :admin_required
  layout "admin"
  protect_from_forgery
  
  def index
    @schools = School.all :order => 'created_at DESC'
  end
end
