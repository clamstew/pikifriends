class Proofread < ActiveRecord::Base
  belongs_to :blog
  belongs_to :proofreader, :class_name => "User", :foreign_key => "proofreader_id"
end
