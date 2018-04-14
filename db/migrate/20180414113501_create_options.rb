class CreateOptions < ActiveRecord::Migration[5.1]
  def change
    create_table :options do |t|
      t.string :name
      t.integer "option_type_id"
      t.timestamps
    end
    add_index("options", ["option_type_id"])
  end
end
