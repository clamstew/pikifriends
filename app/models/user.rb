# == Schema Information
# Schema version: 20090423095449
#
# Table name: users
#
#  id         :integer       not null, primary key
#  username   :string(255)   not null
#  password   :string(255)   not null
#  firstname  :string(255)   index_users_on_firstname
#  lastname   :string(255)   index_users_on_lastname
#  about      :text          
#  school_id  :integer       
#  role_id    :integer       
#  created_at :datetime      
#  updated_at :datetime      
#

class User < ActiveRecord::Base
	
	belongs_to :school
	belongs_to :classroom
	belongs_to :role
	has_one :token, :dependent => :destroy
	has_many :blogs, :order => 'created_at DESC', :dependent => :destroy
	has_many :pictures, :order => 'created_at DESC', :dependent => :destroy
	has_many :profile_comments, :order => 'created_at DESC', :dependent => :destroy
	
	acts_as_taggable_on :mykeywords
	
	file_column :image,
	            :root_path => File.join(RAILS_ROOT, "public/uploaded"),
	            :web_root => "uploaded/",
	            :magick => {:versions => {
	              :thumb => {:size => '50x50'},
	              :medium => {:size => '320x320'}
              }}
  
	def screen_name
		self.firstname + ', ' + self.lastname.slice(0..0)
	end
	
	def friends
	  #返り値用フレンドリスト
	  friendList = Array.new
	  #友達関係を取得する。
		friendshipList = Friendship.find :all, :conditions => ["(request_user_id=? OR replay_user_id=?) AND linked=?", self.id, self.id, true], :order => 'created_at'
		friendshipList.each do |friendship|
      #友達のIDを取得
      if friendship.request_user_id == id
        friend_id = friendship.replay_user_id
      else   
        friend_id = friendship.request_user_id
      end
      #IDがあれば
      friend = User.find(friend_id)
      if friend
          friendList.push(friend)
      end
		end
		return friendList
	end
	
	def linked_friendships
		Friendship.find :all, :conditions => ["linked=? AND (request_user_id=? OR replay_user_id=?)", true, self.id, self.id], :order => 'created_at'
	end
	
	def friendships
		Friendship.find :all, :conditions => ["request_user_id=? OR replay_user_id=?", self.id, self.id], :order => 'created_at'
	end
	
	def noreply_friendships
		Friendship.find(:all, :conditions => ["linked=? AND replay_user_id=?", false, self.id], :order => 'created_at')
	end
	
	def delete_friendship(friend_user_id)
		friendships = Friendship.find :all, :conditions => ["user_id=? OR replay_user_id=?",self.id,self.id]
		friendships.each {|friendship|
			if friend_user_id == friendship.user_id || friend_user_id == friendship.replay_user_id
				friendship.destroy
			end
		}
	end
	
	def messages
	  messagelist = ProfileComment.find( :all, :conditions => ["user_id=?",self.id], :order => 'created_at DESC' )
		return messagelist
	end
	
	def get_blog_comments_count()
    comments = BlogComment.find(:all, :conditions => ["write_user_id = ?", self.id] )
    return comments.count
  end
  
  def get_image_comments_count()
    comments = ImageComment.find(:all,  :conditions => ["write_user_id = ?", self.id] )
    return comments.count
  end
  
  def get_messages_count()
    comments = ProfileComment.find(:all,  :conditions => ["user_id = ? OR write_user_id = ?", self.id, self.id] )
    return comments.count
  end
end
