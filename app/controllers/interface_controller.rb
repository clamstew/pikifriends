class InterfaceController < ApplicationController
	
	def index
	  
	end
	
	def login
    
		if params[:username] && params[:password]
			
			#Token.delete_all(["updated_at < ?", 30.day.ago ])
			
			@user = User.find( :first, :conditions => { :username => params[:username], :password => params[:password] } )
			
			unless @user.nil?
			  #hold中は、login不可
			  if @user.hold
			    render :action => 'login_error'
			  else
			    login_count = @user.login.to_i
			    @user.login = login_count + 1
			    @user.save
			    if @user.token.nil?
  					require 'uuidtools'
  					uuid = UUIDTools::UUID.random_create
  					@user.create_token( {:data => uuid.to_s} )
  				end
  				
			  end
			else
				render :action => 'login_error'
			end	
		end
		
	end
	
	def logout
		@user = User.find(:first, :conditions => {:id => params[:id]} )
		@user.token = nil
		@user.save
	end
	
	def add_student
    user_check = User.find( :first, :conditions=>["username = ?",[params[:username]]] )
    unless user_check
      
      school = School.find(params[:school_id])
      role = Role.find_by_name('student')
      
      user = User.new
      user.username = params[:username]
      user.password = params[:password]
      user.firstname = params[:firstname]
      user.lastname = params[:lastname]
      user.school = school
      user.role = role
      if user.save
        render :text => 'OK'
      else
        render :text => 'NG'
      end
    else
      render :text => 'NG'
    end
    
	end
	
	def add_teacher_ticket
	  
    school = School.find(params[:school_id])
    
    teacher_ticket = TeacherTicket.new
    teacher_ticket.firstname = params[:firstname]
    teacher_ticket.lastname = params[:lastname]
    teacher_ticket.email = params[:email]
    teacher_ticket.school = school

    if teacher_ticket.save
      render :text => 'OK'
    else
      render :text => 'NG'
    end

	end
	
	def destroy_teacher_ticket
	  teacher_ticket = TeacherTicket.find(params[:id])
	  if teacher_ticket.destroy
      render :text => 'OK'
    else
      render :text => 'NG'
    end 
	  
  end
  
	def clean_friendships
	  unuser_friendships = []

	  friendships = Friendship.find(:all)
	  friendships.each{|friendship|
  	  begin
  	    request_user = User.find(friendship.request_user_id.to_i)
  	    replay_user = User.find(friendship.replay_user_id.to_i)
  	  rescue
  	    unuser_friendships<<friendship
  	  end
	  }
	  unuser_friendships.each{|d_friendship|
	    #d_friendship.destroy
	  }
	  render :text => 'clean_friendships:'+unuser_friendships.length.to_s 
	end
	
	def countries
	  @countries = Country.find( :all, :order => 'created_at' )
	end
	
	def headlines
	  @headlines = PikiEntry.find :all, :order => 'published_at DESC', :limit => 15
	end
	
	def term_of_use
	  
	end
	
	def privacy_policy
	  
	end
	
	def links
	  
	end
	
	def faq
	  
	end
	
end
