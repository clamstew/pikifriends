# == Schema Information
# Schema version: 20090423095449
#
# Table name: tokens
#
#  id         :integer       not null, primary key
#  user_id    :integer       
#  data       :string(255)   
#  created_at :datetime      
#  updated_at :datetime      
#

class Token < ActiveRecord::Base
	has_one :user
end
