# Filters added to this controller apply to all controllers in the application.
# Likewise, all the methods added will be available for all controllers.

class ApplicationController < ActionController::Base
  
  helper :all # include all helpers, all the time

  # See ActionController::RequestForgeryProtection for details
  # Uncomment the :secret if you're not using the cookie session store
  # protect_from_forgery # :secret => '5573f03012baec0f2fa0d045e67711db'
  
  # See ActionController::Base for details 
  # Uncomment this to filter the contents of submitted sensitive data parameters
  # from your application log (in this case, all fields with names like "password"). 
  # filter_parameter_logging :password
  
  def admin_required
    if cookies[:admin_token]
      @admin = Administrator.find :first, :conditions => {:token => cookies[:admin_token].to_s}
      unless @admin
        redirect_to :controller => 'login' and return
      end
    else
      redirect_to :controller => 'login' and return
    end    
  end
  
  def token_required
    if params[:token]
      @token = Token.find :first, :conditions => {:data => params[:token].to_s}
      unless @token
        render :text =>'404', :status => 404 and return 
      end
    else
      render :text =>'404', :status => 404 and return
    end    
  end
  
end
