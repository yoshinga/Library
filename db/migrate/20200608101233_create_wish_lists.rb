class CreateWishLists < ActiveRecord::Migration[6.0]
  def change
    create_table :wish_lists do |t|

      t.timestamps
    end
  end
end
