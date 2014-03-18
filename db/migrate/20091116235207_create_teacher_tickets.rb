class CreateTeacherTickets < ActiveRecord::Migration
  def self.up
    create_table :teacher_tickets do |t|
      t.string :firstname, :null=>false
      t.string :lastname, :null=>false
      t.string :email, :null=>false
      t.integer :school_id, :null=>false
      t.timestamps
    end
  end

  def self.down
    drop_table :teacher_tickets
  end
end
