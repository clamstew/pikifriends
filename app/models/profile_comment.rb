# == Schema Information
# Schema version: 20090423095449
#
# Table name: profile_comments
#
#  id            :integer       not null, primary key
#  user_id       :integer       
#  write_user_id :integer       
#  body          :text          
#  created_at    :datetime      
#  updated_at    :datetime      
#

class ProfileComment < ActiveRecord::Base
  belongs_to :user
end
