class CreateFaqCategories < ActiveRecord::Migration
  def self.up
    create_table :faq_categories do |t|
      t.string :name
      t.timestamps
    end
  end

  def self.down
    drop_table :faq_categories
  end
end
