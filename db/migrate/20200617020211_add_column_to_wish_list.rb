class AddColumnToWishList < ActiveRecord::Migration[6.0]
  def change
    add_column :wish_lists, :title, :string
  end
end
