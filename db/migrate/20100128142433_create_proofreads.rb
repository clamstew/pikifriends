class CreateProofreads < ActiveRecord::Migration
  
  def self.up
    create_table :proofreads do |t|
      
      t.integer :blog_id
      t.integer :user_id, :null=>false
      t.integer :proofreader_id, :null=>false
      
      t.text :original_title, :null=>false
      t.text :original_body, :null=>false
      t.text :title, :null=>false
      t.text :body, :null=>false
      t.text :comment
      t.string :stamp
      
      t.timestamps
    end
  end

  def self.down
    drop_table :proofreads
  end
  
end
