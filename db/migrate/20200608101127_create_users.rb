class CreateUsers < ActiveRecord::Migration[6.0]
  def change
    create_table :users do |t|
      t.string :nickname
      t.integer :role, null: false, default: 0
      t.string :uid, null: false
      t.timestamps
    end
  end
end
