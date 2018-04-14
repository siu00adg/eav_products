class CreateValues < ActiveRecord::Migration[5.1]
  def change
    create_table :values do |t|
      t.integer "option_id"
      t.integer "product_id"
      t.integer "type_value_id"

      t.timestamps
    end
    add_index("values", ["option_id", "product_id", "type_value_id"])
  end
end
