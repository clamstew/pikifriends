# == Schema Information
# Schema version: 20090423095449
#
# Table name: roles
#
#  id         :integer       not null, primary key
#  name       :string(255)   
#  created_at :datetime      
#  updated_at :datetime      
#

class Role < ActiveRecord::Base
end
