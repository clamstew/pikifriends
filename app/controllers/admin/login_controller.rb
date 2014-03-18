class Admin::LoginController < ApplicationController
  
  layout "admin"
  protect_from_forgery
  
  def index
    @administrator = Administrator.new()
  end
  
  def authorize
    
    @admin = Administrator.find :first, :conditions => { 
      :email => params[:administrator][:email],
      :password => params[:administrator][:password]
    }
    
    if @admin
      #トークン設定
      @admin.token = UUIDTools::UUID.timestamp_create().to_s
      @admin.save
      #クッキーにトークンを設定
      cookies[:admin_token] = {:value=>@admin.token, :expires => 1.year.from_now}
      redirect_to :controller => :dashboard and return
    else
      flash[:notice] = 'Login Error.'
      redirect_to :controller => :login and return
    end
  end
  
  def disable
    cookies[:admin_token] = nil
    redirect_to :controller => :login and return
  end
end
