class AddSomeTestData < ActiveRecord::Migration[5.1]
  def change

    options = [["description","varchar"], ["price","decimal"], ["live","datetime"]]

    products = [{
                  :name => "MK3 FPH",
                  :product_type => "Steering Wheels",
                  :description => "MK3 description...",
                  :price => 130.00,
                  :live => Time.now
                },
                {
                  :name => "MK4 DPP",
                  :product_type => "Steering Wheels",
                  :description => "MK4 description...",
                  :price => 140.00,
                  :live => Time.now
                },
                {
                  :name => "Irvin Flying Jacket",
                  :product_type => "Flying Jackets",
                  :description => "Irvin description...",
                  :price => 600.00,
                  :live => Time.now
                },
                {
                  :name => "Red Arrows Jacket",
                  :product_type => "Flying Jackets",
                  :description => "Red Arrows description...",
                  :price => 450.00,
                  :live => Time.now
                },
                {
                  :name => "Goggles",
                  :product_type => "Accessories",
                  :description => "Goggles description",
                  :price => 50.00,
                  :live => Time.now
                },
                {
                  :name => "Horn Button",
                  :product_type => "Accessories",
                  :description => "Horn Button description",
                  :price => 40.00,
                  :live => Time.now
                }]

    reversible do |dir|
      dir.up do
        varchar = OptionType.find_by_name("varchar")
        decimal = OptionType.find_by_name("decimal")
        datetime = OptionType.find_by_name("datetime")
        Option.create(:name => "description", :option_type => varchar)
        Option.create(:name => "price", :option_type => decimal)
        Option.create(:name => "live", :option_type => datetime)

        products.each do |p|
          product_type = ProductType.find_or_create_by(name: p[:product_type])
          product = Product.create(:name => p[:name], :product_type => product_type)
          product.set_data_by_name("description", p[:description])
          product.set_data_by_name("price", p[:price])
          product.set_data_by_name("live", p[:live])
        end
      end
      dir.down do
        products.each do |p|
          product = Product.find_by_name(p[:name])
          if product
            product.destroy_data_by_name("description")
            product.destroy_data_by_name("price")
            product.destroy_data_by_name("live")
            product.destroy
          end
          ProductType.find_by_name(p[:product_type]).destroy if ProductType.find_by_name(p[:product_type])
        end
        Option.find_by_name("description").destroy if Option.find_by_name("description")
        Option.find_by_name("price").destroy if Option.find_by_name("price")
        Option.find_by_name("live").destroy if Option.find_by_name("live")
      end
    end


  end
end
