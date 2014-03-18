class TeachersController < ApplicationController
  
  # 情報収集
  def notices
    @user = User.find(params[:id])
    @notices = Array.new
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
	
	# Profile
	def profile
	  @user = User.find(params[:id])
	end
	
	def update
	  @user = User.find(params[:id])
		@user.update_attributes(params[:user])
		render :action => 'profile'
	end
	
	def delete_profile_image
	  @user = User.find(params[:id])
	  @user.image = nil
	  @user.save
	  render :text => 'OK'
	end
	
	# Blog - CRUD
  def blog_create
    
    @user = User.find(params[:id])
    blog = Blog.new()
    blog.title = params[:title].to_s
    blog.body = params[:body].to_s
    blog.user = @user
    blog.save!
		render :text => 'OK'
		
	end

	def blog_edit
	  
	  @user = User.find(params[:id])
		blog = Blog.find(params[:item_id].to_i)
		blog.title = params[:title].to_s
		blog.body = params[:body].to_s
		blog.user = @user
		blog.save!
		render :text => 'OK'
		
	end
	
	def blog_list
	  @user = User.find(params[:id])
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
	
	def add_blog_comment
	  @user = User.find(params[:id])
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
	  @user = User.find(params[:id])
	  logger.debug(@user.pictures)
	end

	def image_create
    @user = User.find(params[:id])
	  @picture = Picture.new()
	  @picture.update_attributes(params[:picture])
	  @picture.user = @user
	  @picture.save!
	  render :text => 'OK'
	  
	end
		
	def image_update
	  @user = User.find(params[:id])
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
	  @user = User.find(params[:id])
		response = 'NG'
		delete_picture = @user.pictures.find(params[:item_id].to_i)
		if delete_picture
			delete_picture.destroy
			response = 'OK'
		end
		render :text => response
	end
	
	def add_image_comment
	  @user = User.find(params[:id])
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
	
	# Friend周り
	def friend_list
	  @user = User.find(params[:id])
		@user.friendships
	end
  
  # message 周り
  def message_list
		@user = User.find(params[:id])
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
	
end
