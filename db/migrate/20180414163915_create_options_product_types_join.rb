class CreateOptionsProductTypesJoin < ActiveRecord::Migration[5.1]
  def change
    create_table :options_product_types, :id => false do |t|
      t.integer "product_type_id"
      t.integer "option_id"
    end
    add_index("options_product_types", ["product_type_id", "option_id"])
  end
end
