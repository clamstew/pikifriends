# == Schema Information
# Schema version: 20090423095449
#
# Table name: friendships
#
#  id              :integer       not null, primary key
#  request_user_id :integer       
#  replay_user_id  :integer       
#  linked          :boolean       
#  created_at      :datetime      
#  updated_at      :datetime      
#

class Friendship < ActiveRecord::Base
	
	def request_user
		User.find(self.request_user_id)
	end
	
	def replay_user
		User.find(self.replay_user_id)
	end
end
