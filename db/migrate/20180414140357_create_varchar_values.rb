class CreateVarcharValues < ActiveRecord::Migration[5.1]
  def change
    create_table :varchar_values do |t|
      t.string "data"
      t.timestamps
    end
  end
end
