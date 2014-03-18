class CreateUsers < ActiveRecord::Migration
	def self.up
		create_table :users do |t|
			t.string :username, :null=>false
			t.string :password, :null=>false
			t.string :firstname
			t.string :lastname
			t.string :image
			t.text   :about
			t.integer :school_id
			t.integer :role_id
			t.timestamps
		end
		add_index :users, :firstname
		add_index :users, :lastname
	end

	def self.down
		drop_table :users
	end
end
