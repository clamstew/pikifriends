module UserHelper
	def friends_list(friends)
		buf = ''
		friends.each do |f|
			friend_id = (f.user_id==@user.id) ? f.replay_user_id : f.user_id
			u = User.find :first, :conditions => ["id=?", friend_id]
			buf += "\n<item><user_id>"+u.id.to_s+"</user_id><screen_name>"+u.firstname.to_s+','+u.lastname.to_s+"</screen_name></item>"
		end
		return buf
	end
	
	def blogs_list(blogs)
		buf = ''
		num = 0
		blogs = @user.blog
		blogs.each { |b|
			buf += '<item id="'+num.to_s+'">'
			buf += '<title>'+b.title+'</title>'
			buf += '<body>'+b.body+'</body>'
			buf += "</item>\n"
			
			num += 1
		}
		return buf
	end
	
	def profile_commnets_list
		buf = ''
		num = 0
		profile_comments = @user.profile_comments
		profile_comments.each { |e|
			
			write_user = User.find :first, :conditions => ["id=?", e.write_user_id]
			
			buf += '<item id="'+num.to_s+'">'
			buf += '<write_user>'+write_user.screen_name+'</write_user>'
			buf += '<body>'+e.body+'</body>'
			buf += "</item>\n"
			num += 1
		}
		return buf
	end
end
