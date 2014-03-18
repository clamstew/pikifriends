class BlogComment < ActiveRecord::Base
  belongs_to :blog
  belongs_to :write_user, :class_name => "User", :foreign_key => "write_user_id"
end
