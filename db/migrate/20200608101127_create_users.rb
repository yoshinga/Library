class CreateUsers < ActiveRecord::Migration[6.0]
  def change
    create_table :users, primary_key: :uid do |t|
      t.string :nickname
      t.integer :role, null: false, default: 0
      t.timestamps
    end

  end
end
