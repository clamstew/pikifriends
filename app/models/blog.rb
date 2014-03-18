class Blog < ActiveRecord::Base
	belongs_to :user
	has_many :blog_comments, :dependent => :destroy
	has_one :proofread, :dependent => :destroy
end
