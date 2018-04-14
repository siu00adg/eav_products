class AddProductTypeIdToProducts < ActiveRecord::Migration[5.1]
  def change
    add_column :products, :product_type_id, :integer
    add_index("products", "product_type_id")
  end
end
