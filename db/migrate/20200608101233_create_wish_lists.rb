class CreateWishLists < ActiveRecord::Migration[6.0]
  def change
    create_table :wish_lists do |t|
      t.references :user
      t.integer :price
      t.string :author
      t.string :link
      t.datetime :publication_date
      t.timestamps
    end
  end
end
