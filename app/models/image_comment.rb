class ImageComment < ActiveRecord::Base
  belongs_to :picture
  belongs_to :write_user, :class_name => "User", :foreign_key => "write_user_id"
end
