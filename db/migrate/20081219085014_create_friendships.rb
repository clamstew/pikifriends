class CreateFriendships < ActiveRecord::Migration
  def self.up
    create_table :friendships do |t|
      t.integer :request_user_id
      t.integer :replay_user_id
      t.boolean :linked, :default =>false
      t.string :request_with_message
      t.timestamps
    end
  end

  def self.down
    drop_table :friendships
  end
end
