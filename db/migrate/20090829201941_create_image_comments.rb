class CreateImageComments < ActiveRecord::Migration
  def self.up
    create_table :image_comments do |t|
      
      t.integer :picture_id
      t.text :body
      t.integer :write_user_id
      t.timestamps
      
    end
  end

  def self.down
    drop_table :image_comments
  end
end
