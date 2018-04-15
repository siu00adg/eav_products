class AddSomeTestData < ActiveRecord::Migration[5.1]
  def change

    product_types = [{
                        :name => "Steering Wheels"
                      },
                      {
                        :name => "Flying Jackets"
                      },
                      {
                        :name => "Accessories"
                      }]

    products = [{
                  :name => "MK3 FPH",
                  :product_type => product_types[0][:name],
                  :description => "MK3 description...",
                  :position => 1,
                  :price => 130.00,
                  :live => Time.now
                },
                {
                  :name => "MK4 DPP",
                  :product_type => product_types[0][:name],
                  :description => "MK4 description...",
                  :position => 2,
                  :price => 140.00,
                  :live => Time.now
                },
                {
                  :name => "Irvin Flying Jacket",
                  :product_type => product_types[1][:name],
                  :description => "Irvin description...",
                  :position => 3,
                  :price => 600.00,
                  :live => Time.now
                },
                {
                  :name => "Red Arrows Jacket",
                  :product_type => product_types[1][:name],
                  :description => "Red Arrows description...",
                  :position => 4,
                  :price => 450.00,
                  :live => Time.now
                },
                {
                  :name => "Goggles",
                  :product_type => product_types[2][:name],
                  :description => "Goggles description...",
                  :position => 5,
                  :price => 50.00,
                  :live => Time.now
                },
                {
                  :name => "Horn Button",
                  :product_type => product_types[2][:name],
                  :description => "Horn Button description...",
                  :position => 6,
                  :price => 40.00,
                  :live => Time.now
                }]

    varchar = OptionType.find_by_name("varchar")
    integer = OptionType.find_by_name("integer")
    decimal = OptionType.find_by_name("decimal")
    datetime = OptionType.find_by_name("datetime")

    reversible do |dir|
      dir.up do

        description = Option.create(:name => "description", :option_type => varchar)
        position = Option.create(:name => "position", :option_type => integer)
        price = Option.create(:name => "price", :option_type => decimal)
        live = Option.create(:name => "live", :option_type => datetime)

        product_types.each do |pt|
          product_type = ProductType.find_or_create_by(name: pt[:name])
          product_type.options << description
          product_type.options << position
          product_type.options << price
          product_type.options << live
        end

        products.each do |p|
          product_type = ProductType.find_or_create_by(name: p[:product_type])
          product = Product.create(:name => p[:name], :product_type => product_type)
          product.set_data_by_name("description", p[:description])
          product.set_data_by_name("position", p[:position])
          product.set_data_by_name("price", p[:price])
          product.set_data_by_name("live", p[:live])
        end
      end
      dir.down do
        products.each do |p|
          product = Product.find_by_name(p[:name])
          if product
            product.destroy_data_by_name("description")
            product.destroy_data_by_name("position")
            product.destroy_data_by_name("price")
            product.destroy_data_by_name("live")
            product.destroy
          end
        end

        Option.find_by_name("description").destroy if Option.find_by_name("description")
        Option.find_by_name("position").destroy if Option.find_by_name("position")
        Option.find_by_name("price").destroy if Option.find_by_name("price")
        Option.find_by_name("live").destroy if Option.find_by_name("live")

        product_types.each do |pt|
          ProductType.find_by_name(pt[:name]).destroy if ProductType.find_by_name(pt[:name])
        end
      end
    end
  end
end
