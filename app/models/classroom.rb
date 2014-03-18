class Classroom < ActiveRecord::Base
  belongs_to :grade
  has_many :users, :order => 'lastname, firstname'
end
