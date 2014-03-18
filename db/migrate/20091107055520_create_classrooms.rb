class CreateClassrooms < ActiveRecord::Migration
  def self.up
    create_table :classrooms do |t|
      t.string :name
      t.integer :grade_id, :null => false
      t.timestamps
    end
  end

  def self.down
    drop_table :classrooms
  end
end
