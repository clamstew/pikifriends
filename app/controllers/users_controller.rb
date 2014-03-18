class UsersController < ApplicationController
	
	before_filter :token_required
	layout "users", :except => [:friend_list, :profile, :blogs, :images, :friends, :notices, :activities, :messages, :proofread]
	
	def except_show_png
	  
	  if params[:action] == "show" && params[:format] == 'png'
	    
	    if params[:id] == nil 
	      return
      end
	    
	    @user = User.find(params[:id])
	    if ( @user.token != nil && params[:token] == @user.token.data ) 
	      p 'render'
	      render :action =>'show', :format =>'png'
	    else
	      p 'through'
	    end
	  end
  end
  
  # GET /users
  # GET /users.xml
  def index
    @users = User.find(:all)

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @users }
    end
  end

  # GET /users/1
  # GET /users/1.xml
  def show
    @user = User.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @user }
      format.png
    end
  end

  # GET /users/new
  # GET /users/new.xml
  def new
    @user = User.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @user }
    end
  end

  # GET /users/1/edit
  def edit
    @user = User.find(params[:id])
  end

  # POST /users
  # POST /users.xml
  def create
    @user = User.new(params[:user])

    respond_to do |format|
      if @user.save
        flash[:notice] = 'User was successfully created.'
        format.html { redirect_to(@user) }
        format.xml  { render :xml => @user, :status => :created, :location => @user }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @user.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /users/1
  # PUT /users/1.xml
  def update
    @user = User.find(params[:id])

    respond_to do |format|
      if @user.update_attributes(params[:user])
        flash[:notice] = 'User was successfully updated.'
        format.html { redirect_to(@user) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @user.errors, :status => :unprocessable_entity }
      end
    end
  end
  
  def update_params
    @user = User.find(params[:id])
    @user.update_attributes(params[:user])
    render :text => 'OK', :status => 200 and return
  end

  # DELETE /users/1
  # DELETE /users/1.xml
  def destroy
    
    @user = User.find(params[:id])
    
    #friendshipを削除する。
    friendships = Friendship.destroy_all( ["request_user_id = ? OR replay_user_id = ?", @user.id, @user.id ] )
    
    #blog_comment削除
    profile_comments = ProfileComment.destroy_all( ["write_user_id = ?", @user.id] )
    
    #blog_comment削除
    blog_comments = BlogComment.destroy_all( ["write_user_id = ?", @user.id] )
    
    #image_comment削除
    image_comments = ImageComment.destroy_all(["write_user_id = ?", @user.id] )
    
    @user.destroy
    render :text => 'OK', :status => 200 and return
    respond_to do |format|
      format.html { redirect_to(users_url) }
      format.xml  { head :ok }
    end
  end
  
  
  def profile
    @user = User.find(params[:id])
  end
  
  def profile_update
    @user = User.find(params[:id])
		@user.update_attributes(params[:user])
		render :text => 'OK', :status => 200 and return
	end
  
  
  
  def blogs
    @user = User.find(params[:id])
    
    if(params[:first_id])
      @blogs = Array.new
      allblogs = @user.blogs.find :all
      allblogs.each do |blog|
        unless params[:first_id] == blog.id.to_s
          @blogs<<blog
        else
          break
        end
      end
    else
      @blogs = @user.blogs.find :all, :order => 'created_at desc'
    end
  end
  
  def blog_create
    @user = User.find(params[:id])
    @user.blogs.create({:title=>params[:title], :body=>params[:body]})
    render :text => 'OK', :status => 200
  end
  
  def blog_update
    @user = User.find(params[:id])
    
    blog = Blog.find(params[:item_id].to_i)
    if blog
      blog.title = params[:title]
      blog.body = params[:body]
      blog.save
      render :text => 'OK', :status => 200 and return
    else
      render :text => '404', :status => 404 and return
    end
  end
  
  def add_blog_comment
	  @user = User.find(params[:id])
	  blog = @user.blogs.find(params[:item_id].to_i)
	  if blog
  	  blog_comment = BlogComment.new
  	  blog_comment.write_user_id = params[:write_user_id].to_i
  	  blog_comment.body = params[:body]
  	  blog_comment.save
  	  blog.blog_comments<<blog_comment
  	  blog.save
	    render :text => 'OK', :status => 200 and return
	  else
	    render :text => '404', :status => 404 and return
    end
	end
	
	def delete_blog_comment
	  
	  bc = BlogComment.find(params[:comment_id])
	  bc.destroy
	  render :text => "OK"

	end
  
  def blog_delete
    
    blog = Blog.find(params[:item_id].to_i)
    if blog
      blog.destroy
      render :text => 'OK', :status => 200 and return
    else
      render :text => '404', :status => 404 and return
    end
  end
  
  def proofread
    @proofread = Proofread.find(params[:proofread_id])
  end
  
  
  def images
    
    @user = User.find(params[:id])
    
    if(params[:first_id])
      @pictures = Array.new
      allpictures= @user.pictures.find :all
      allpictures.each do |picture|
        unless params[:first_id] == picture.id.to_s
          @pictures<<picture
        else
          break
        end
      end
    else
      @pictures = @user.pictures.find :all
    end
  end
  
  def image_create
    @user = User.find(params[:id])
	  @picture = Picture.new()
	  @picture.update_attributes(params[:picture])
	  @picture.user = @user
	  @picture.save!
	  render :text => 'OK', :status => 200 and return
	  
	end
  
  def image_update
    @user = User.find(params[:id])
    picture = Picture.find(params[:item_id].to_i)
    if picture
      picture.title = params[:title]
      picture.save
      render :text => 'OK', :status => 200 and return
    else
      render :text => '404', :status => 404 and return
    end
  end
  
  def image_delete
    picture = Picture.find(params[:item_id].to_i)
    if picture
      picture.destroy
      render :text => 'OK', :status => 200 and return
    else
      render :text => '404', :status => 404 and return
    end
  end
  
  
  def delete_profileimage
    @user = User.find(params[:id])
	  @user.image = nil
	  @user.save
	  render :text => 'OK', :status => 200 and return
	end
  
  def friends
		@user = User.find(params[:id])
	end
  
  def delete_friend
    @user = User.find(params[:id])
		@friend = User.find(params[:friend_user_id])
		Friendship.destroy_all ["request_user_id=? AND replay_user_id=?", @user.id, @friend.id]
		Friendship.destroy_all ["request_user_id=? AND replay_user_id=?", @friend.id, @user.id]
		render :text => 'OK', :status => 200 and return
  end
  
  def messages
	  @user = User.find(params[:id])
  end
  
  def add_message
	  
		profile_comment = ProfileComment.new
		profile_comment.user_id = params[:id]
		profile_comment.write_user_id = params[:write_user_id]
		profile_comment.body = params[:body]
		profile_comment.save
		render :text => '200', :status => 200 and return
		
	end
	
	def delete_message
	  
		profile_comment = ProfileComment.find(params[:item_id])
		profile_comment.destroy
		render :text => '200', :status => 200 and return
		
	end
  
  def notices
    @user = User.find(params[:id])
  end
  
  def activities
	  
	  @user = User.find(params[:id])
		friends = @user.friends
		
		#　友達のBlog&Imageの新規作成のリストを作成する。
		recentFriendBlogs = Array.new
		recentFriendPictures = Array.new
		friends.each{|friend|
		  friend.blogs.find(:all, :conditions => ["created_at > ?", 1.week.ago.to_s] ).each{|blog|
		    recentFriendBlogs<<blog
		  }
		  
		  friend.pictures.find(:all, :conditions => ["created_at > ?", 1.week.ago.to_s] ).each{|picture|
		    recentFriendPictures<<picture
		  }
		}
		
    #　自分のブログ宛の最近のメッセージのリストを取得する。
    recentBlogComments = Array.new
    @user.blogs.each{|blog|
      blog.blog_comments.find(:all, :conditions => ["created_at > ? and write_user_id != ?", 1.week.ago.to_s, @user.id] ).each{|blog_comment|
        recentBlogComments<<blog_comment
      }
    }
    
    #　自分のイメージ宛の最近のメッセージのリストを取得する。
    recentPictureComments = Array.new
    @user.pictures.each{|picture|
      picture.image_comments.find(:all, :conditions => ["created_at > ? and write_user_id != ?", 1.week.ago.to_s, @user.id]).each{|image_comment|
        recentPictureComments<<image_comment
      }
    }
    
    #　自分のイメージ宛の最近のメッセージのリストを取得する。
    recentMessageComments = Array.new
    recentMessageComments = @user.profile_comments.find(:all, :conditions => ["created_at > ? and write_user_id != ?", 1.week.ago.to_s, @user.id] )
    
    #　最近アップデートされたFriendshipを集める。
    recentUpdatedFriendships = Array.new
    recentUpdatedFriendships = Friendship.find(:all, :conditions => ["linked = ? and updated_at > ? and request_user_id = ? ",true, 1.week.ago.to_s, @user.id] )
    
    @recents = recentFriendBlogs + recentFriendPictures + recentBlogComments + recentPictureComments + recentMessageComments + recentUpdatedFriendships
    @sorted_recent_activities = @recents.sort{|a,b|
      b.created_at.to_i <=> a.created_at.to_i
    }
    
    
	end
	
	def friendship_connection
	  friendshipA = Friendship.find :first, :conditions => ["request_user_id=? AND replay_user_id=?", params[:id], params[:another_user_id]]
	  friendshipB = Friendship.find :first, :conditions => ["request_user_id=? AND replay_user_id=?", params[:another_user_id], params[:id]]
	  if friendshipA || friendshipB
	    render :text => 'OK', :status => 200 and return
    else
      render :text => 'NG', :status => 200 and return
    end
	end
	
	
	def send_friendrequest
    
    #二重リクエストのチェック
    double_check = Friendship.find :first, :conditions => ["request_user_id = ? AND replay_user_id = ?", params[:request_user_id], params[:replay_user_id]]
    
    #先にリクエストがある場合
    did_request_check = Friendship.find :first, :conditions => ["request_user_id = ? AND replay_user_id = ?", params[:replay_user_id], params[:request_user_id]]
    
    unless double_check && did_request_check
      @friendship = Friendship.new
  		@friendship.request_user_id = params[:request_user_id]
  		@friendship.replay_user_id = params[:replay_user_id]
  		@friendship.save
    end
    
		render :text => 'OK', :status => 200 and return
		
	end
	
	
  def update_friendship
	  friendship = Friendship.find( params[:friendship_id].to_i )
	  friendship.update_attributes(params[:friendship])
	  friendship.save
	  render :text => 'OK', :status => 200 and return
  end
    
  def delete_friendship
		friendship = Friendship.find(params[:friendship_id])
		if friendship
			friendship.destroy
			render :text => 'OK', :status => 200 and return
		else
		  render :text => '404', :status => 404 and return
		end
		
  end
end
