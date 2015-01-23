class CreateOrders < ActiveRecord::Migration
  def change
    create_table :orders do |t|
      t.string :product_name
      t.string :quantity
      t.string :unit_price
      t.string :total
      t.string :cost_unit_price
    end
  end
end
