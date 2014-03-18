class Grade < ActiveRecord::Base
  belongs_to :school
  has_many :classrooms, :dependent => :destroy
end
