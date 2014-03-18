class CreatePikiEntries < ActiveRecord::Migration
  def self.up
    create_table :piki_entries do |t|
      t.string :title
      t.text :body
      t.string :image
      t.datetime :published_at

      t.timestamps
    end
  end

  def self.down
    drop_table :piki_entries
  end
end
