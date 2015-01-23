class Order < ActiveRecord::Base

  validates :product_name, presence: true
  validates :quantity, presence: true
  validates :unit_price, presence: true
  validates :total, presence: true

end