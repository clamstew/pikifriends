class CreateGrades < ActiveRecord::Migration
  def self.up
    create_table :grades do |t|
      t.string :name
      t.integer :school_id, :null => false
      t.timestamps
    end
  end

  def self.down
    drop_table :grades
  end
end
