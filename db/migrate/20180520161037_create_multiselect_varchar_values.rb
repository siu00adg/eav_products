class CreateMultiselectVarcharValues < ActiveRecord::Migration[5.1]
  def change
    create_table :multiselect_varchar_values do |t|
      t.integer "multiselect_varchar_option_id"
      t.timestamps
    end
  end
end
