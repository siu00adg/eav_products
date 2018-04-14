class CreateVarcharValues < ActiveRecord::Migration[5.1]
  def change
    create_table :varchar_values do |t|
      t.integer "option_id"
      t.string "value"
      t.timestamps
    end
    add_index("varchar_values", ["option_id"])
  end
end
