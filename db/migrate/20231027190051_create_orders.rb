class CreateOrders < ActiveRecord::Migration[7.0]
  def change
    create_table :orders do |t|
      t.references :business, null: false, foreign_key: true
      t.references :buyer, null: false, foreign_key: { to_table: :users }
      t.integer :quantity, null: false
      t.decimal :price, null: false
      t.integer :status, default: 0, null: false

      t.timestamps
    end
  end
end
