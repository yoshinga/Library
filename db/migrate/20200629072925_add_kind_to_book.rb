class AddKindToBook < ActiveRecord::Migration[6.0]
  def change
    add_column :books, :kind, :integer, default: 1
  end
end
