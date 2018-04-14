class CreateCategoriesOptionsJoin < ActiveRecord::Migration[5.1]
  def change
    create_table :categories_options, :id => false do |t|
      t.integer "category_id"
      t.integer "option_id"
    end
    add_index("categories_options", ["category_id", "option_id"])
  end
end
