class AddClassroomToUsers < ActiveRecord::Migration
  def self.up
    add_column :users, :classroom_id, :integer
  end

  def self.down
    remove_column :users, :classroom_id
  end
end
