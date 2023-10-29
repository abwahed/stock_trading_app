class CreateBusinesses < ActiveRecord::Migration[7.0]
  def change
    create_table :businesses do |t|
      t.string :name, null: false
      t.integer :shares_available, null: false
      t.references :owner, foreign_key: { to_table: :users }

      t.timestamps
    end
  end
end
