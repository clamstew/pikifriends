# == Schema Information
# Schema version: 20090423095449
#
# Table name: pictures
#
#  id         :integer       not null, primary key
#  user_id    :integer       
#  title      :string(255)   
#  created_at :datetime      
#  updated_at :datetime      
#

class Picture < ActiveRecord::Base
	
	belongs_to :user
	has_many :image_comments, :dependent => :destroy
	
	file_column :image,
	            :root_path => File.join(RAILS_ROOT, "public/uploaded"),
	            :web_root => "uploaded/",
          	  :magick => {
          	    :versions => {
	                :thumb => {:size => '50x50'},
	                :medium => {:size => '512x512'},
	                :high => {:size => '1024x1024'}
	              }
	            }
end
