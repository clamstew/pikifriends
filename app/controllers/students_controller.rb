class StudentsController < ApplicationController
	
	before_filter :find_user
  # before_filter :check_user, :except => ['noauth']
  # before_filter :check_self, :except => ['profile','friend_list','noauth']

	
	def find_user
		@user = User.find(params[:id].to_i)
	end
	
	def check_user
	  token = Token.find :first, :conditions => ["data=?", params[:token]]
		unless token.user
		  redirect_to :action => 'noauth'
		end
	end
	
	def check_self
		unless @user.token.data == params[:token] && @user.role.name == 'student'
			redirect_to :action => 'noauth'
		end
	end
	
	def profile
    #p @user
	end
	
	def update
		@user.update_attributes(params[:user])
		render :action => 'profile'
	end
	
	def delete_profile_image
	  @user.image = nil
	  @user.save
	  render :action => 'profile'
	end
	
	def blog_list
	  
	  if params[:range]
	    #レンジがある場合
      range = params[:range].split(/\.\./)
	    @range = Range.new(range[0], range[1])
	    @blogs = @user.blogs.find( :all, :offset=>@range.first, :limit=>@range.to_a.size ) 
	  else
	    #レンジが無い場合は、全てのデータ
	    @blogs = @user.blogs
    end
		
	end
	
	#　一つ前のブログデータ
	def blog_older
	  
	  ids = @user.blog_ids
	  cursor = ids.index( params[:item_id].to_i )
	  
	  unless cursor
	    render :text => 'Null'
	    
	  else
	    
	    older_id = ids[cursor+1]

      if older_id
        @olderBlog = @user.blogs.find(older_id)
        render :text => @olderBlog.to_xml(:dasherize => false, :skip_types => true)
      else
        render :text => 'Null'
      end
      
    end
    
	end
	
	#　一つ新しいブログデータ
	def blog_newer
	  
	  ids = @user.blog_ids
	  cursor = ids.index( params[:item_id].to_i )
	  p cursor
	  unless cursor && cursor!=0
	    render :text => 'Null'
	  else
	    newer_id = ids[cursor-1]
	    if newer_id > 0
	      @newerBlog = @user.blogs.find(newer_id)
	      render :text => @newerBlog.to_xml(:dasherize => false, :skip_types => true)
	    else
	      render :text => 'Null'
      end
    end
	end
	
	def blog_create
		blog = Blog.new()
		blog.title = params[:title].to_s
		blog.body = params[:body].to_s
		blog.user = @user
		blog.save!
		render :text => 'OK'
	end
	
	def blog_edit
		blog = Blog.find(params[:item_id].to_i)
		blog.title = params[:title].to_s
		blog.body = params[:body].to_s
		blog.user = @user
		blog.save!
		render :text => 'OK'
	end
	
	def blog_delete
		@response = 'NG'
		@delete_blog = @user.blogs.find(params[:item_id].to_i)
		if @delete_blog
			@delete_blog.destroy
			@response = 'OK'
		end
		render :text => @response
	end
	
	def add_blog_comment
	  
	  blog = @user.blogs.find params[:blog_id].to_i
	  
	  bc = BlogComment.new
	  bc.write_user_id = params[:write_user_id].to_i
	  bc.body = params[:body]
	  bc.save
	  
	  blog.blog_comments<<bc
	  blog.save
	  
	  render :text => "OK"

	end
	
	def delete_blog_comment
	  
	  bc = BlogComment.find(params[:comment_id])
	  bc.destroy
	  render :text => "OK"

	end
	
	# Image周り
	def image_list
	  
	end

	def image_create
    
	  @picture = Picture.new()
	  @picture.update_attributes(params[:picture])
	  @picture.user = @user
	  @picture.save!
	  render :text => 'OK'
	  
	end
		
	def image_update
	  
	  response = 'NG'
		update_picture = @user.pictures.find(params[:item_id].to_i)
		if update_picture
			update_picture.title = params[:title]
			update_picture.save
			response = 'OK'
		end
		render :text => response
	end
	
	def image_delete
	  
		response = 'NG'
		delete_picture = @user.pictures.find(params[:item_id].to_i)
		if delete_picture
			delete_picture.destroy
			response = 'OK'
		end
		render :text => response
	end
	
	def add_image_comment
	  
	  image = @user.pictures.find params[:image_id].to_i
	  
	  imagecomment = ImageComment.new
	  imagecomment.write_user_id = params[:write_user_id].to_i
	  imagecomment.body = params[:body]
	  imagecomment.save
	  
	  image.image_comments<<imagecomment
	  image.save
	  
	  render :text => "OK"

	end
	
	def delete_image_comment
	  
	  bc = ImageComment.find(params[:comment_id])
	  bc.destroy
	  render :text => "OK"

	end
	
	def send_request
    
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
    
		render :text => 'OK'
		
	end
	
	def friend_list
		@user.friendships
	end
	
	def friendship_update

	  friendship = Friendship.find( params[:friendship_id].to_i )
	  friendship.update_attributes(params[:friendship])
	  friendship.save
	  render :text => 'OK'
	  
  end
  
	def friend_delete
	  
		response = 'NG'
		delete_friend = Friendship.find(params[:friendship_id])
		if delete_friend
			delete_friend.destroy
			response = 'OK'
		end
		render :text => response
	end
	

	

	
	def notices
	  
	end
	
	def activities
	  
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
	
	def message_list
		
	end
	
	def message_create
	  
		@profile_comment = ProfileComment.new
		@profile_comment.user_id = params[:user_id]
		@profile_comment.write_user_id = params[:write_user_id]
		@profile_comment.body = params[:body]
		@profile_comment.save
		render :text => 'OK'
		
	end
	
	def message_delete
	  
		comment = ProfileComment.find params[:item_id]
		comment.destroy	if comment
		render :text => "OK"
		
	end
	
	def noauth
		render :text => "Failed Authorization."
	end
	
	def cleanFriendship
	  friendships = Friendship.find(:all)
	  users = User.find(:all)
	  buf = 'friendships.length:'+friendships.length.to_s
	  
	  friendships.each{|friendship|
	    flg = false
	    users.each{|user|
	      if friendship.request_user_id == user.id || friendship.replay_user_id == user.id
	        flg = true
	      end
	    }
	    unless flg
	      buf += ' '+friendship.id.to_s
	      #friendship.destroy
      end
	  }
		render :text => buf
	end
end
