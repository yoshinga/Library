class CreateComments < ActiveRecord::Migration[6.0]
  def change
    create_table :comments do |t|
      t.references :book
      t.references :user
      t.string :content
      t.timestamps
    end
  end
end
