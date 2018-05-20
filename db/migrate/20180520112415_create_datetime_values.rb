class CreateDatetimeValues < ActiveRecord::Migration[5.1]
  def change
    create_table :datetime_values do |t|
      t.datetime "data"
      t.timestamps
    end
  end
end
