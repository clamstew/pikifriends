class CreateProfileComments < ActiveRecord::Migration
  def self.up
    create_table :profile_comments do |t|
			t.integer :user_id
			t.integer :write_user_id
			t.text    :body
      t.timestamps
    end
  end

  def self.down
    drop_table :profile_comments
  end
end
