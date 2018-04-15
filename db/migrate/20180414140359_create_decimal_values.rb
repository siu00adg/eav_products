class CreateDecimalValues < ActiveRecord::Migration[5.1]
  def change
    create_table :decimal_values do |t|
      t.decimal "data", :precision => 15, :scale => 4
      t.timestamps
    end
  end
end
