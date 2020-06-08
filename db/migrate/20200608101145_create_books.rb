class CreateBooks < ActiveRecord::Migration[6.0]
  def change
    create_table :books do |t|
      t.integer :status, null: false, default: 1
      t.references :rent_user
      t.references :purchaser
      t.references :owner
      t.references :publisher
      t.integer :price
      t.string :author
      t.string :link
      t.datetime :latest_rent_date
      t.datetime :return_date
      t.datetime :purchage_date
      t.datetime :publication_date
      t.timestamps
    end
  end
end
