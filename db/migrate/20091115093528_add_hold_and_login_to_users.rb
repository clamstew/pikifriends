class AddHoldAndLoginToUsers < ActiveRecord::Migration
  def self.up
    add_column :users, :hold, :boolean, :default => false
    add_column :users, :login, :integer, :default => 0
  end

  def self.down
    remove_column :users, :hold
    remove_column :users, :login
  end
end
