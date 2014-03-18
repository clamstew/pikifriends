# == Schema Information
# Schema version: 20090423095449
#
# Table name: countries
#
#  id         :integer       not null, primary key
#  name       :string(255)   
#  shortname  :string(255)   
#  created_at :datetime      
#  updated_at :datetime      
#

class Country < ActiveRecord::Base
  has_many :schools
end
