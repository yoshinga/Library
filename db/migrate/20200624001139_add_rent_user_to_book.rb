class AddRentUserToBook < ActiveRecord::Migration[6.0]
  def change
    add_column :books, :rent_user, :string
    add_column :books, :purchaser, :string
    add_column :books, :owner, :string
    add_column :books, :publisher, :string
    rename_column :books, :publisher, :publisher_name
  end
end
