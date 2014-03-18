# == Schema Information
# Schema version: 20090423095449
#
# Table name: schools
#
#  id         :integer       not null, primary key
#  name       :string(255)   
#  location   :string(255)   
#  country_id :integer       
#  created_at :datetime      
#  updated_at :datetime      
#

class School < ActiveRecord::Base
	belongs_to :country
	has_many :users
	has_many :grades, :dependent => :destroy
	has_many :students, :class_name => 'User', :order => 'lastname, firstname'
end
