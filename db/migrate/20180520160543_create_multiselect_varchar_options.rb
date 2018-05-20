class CreateMultiselectVarcharOptions < ActiveRecord::Migration[5.1]
  def change
    create_table :multiselect_varchar_options do |t|
      t.integer "option_id"
      t.string "data"
      t.timestamps
    end
    add_index("multiselect_varchar_options", "option_id")
  end
end
