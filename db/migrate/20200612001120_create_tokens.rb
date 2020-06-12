class CreateTokens < ActiveRecord::Migration[6.0]
  def change
    create_table :tokens do |t|
      t.string :label, null: false
      t.string :digest_hash, null: false

      t.index :label, unique: true
      t.index :digest_hash, unique: true
      t.timestamps
    end
  end
end
