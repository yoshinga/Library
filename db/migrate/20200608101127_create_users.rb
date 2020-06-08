class CreateUsers < ActiveRecord::Migration[6.0]
  def change
    create_table :users do |t|
      t.string :nicname
      t.integer :role, null: false, default: 0
      t.timestamps
    end
  end
end
