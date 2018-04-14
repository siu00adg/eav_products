class AddOptionTypesAndOptionsData < ActiveRecord::Migration[5.1]
  def change
    reversible do |dir|
      dir.up do
        option_type = OptionType.create(:name => 'varchar')
        Option.create(:name => 'description', :option_type => option_type)
        option_type = OptionType.create(:name => 'integer')
        Option.create(:name => 'position', :option_type => option_type)
        option_type = OptionType.create(:name => 'decimal')
        Option.create(:name => 'price', :option_type => option_type)
        option_type = OptionType.create(:name => 'datetime')
        Option.create(:name => 'expiry', :option_type => option_type)
        option_type = OptionType.create(:name => 'multiselect')
        Option.create(:name => 'size', :option_type => option_type)
      end
      dir.down do
        if OptionType.find_by_name('varchar')
          OptionType.find_by_name('varchar').delete
        end

        if OptionType.find_by_name('integer')
          OptionType.find_by_name('integer').delete
        end
        if OptionType.find_by_name('decimal')
          OptionType.find_by_name('decimal').delete
        end
        if OptionType.find_by_name('datetime')
          OptionType.find_by_name('datetime').delete
        end
        if OptionType.find_by_name('multiselect')
          OptionType.find_by_name('multiselect').delete
        end
        if Option.find_by_name('description')
          Option.find_by_name('description').delete
        end
        if Option.find_by_name('position')
          Option.find_by_name('position').delete
        end
        if Option.find_by_name('price')
          Option.find_by_name('price').delete
        end
        if Option.find_by_name('expiry')
          Option.find_by_name('expiry').delete
        end
        if Option.find_by_name('size')
          Option.find_by_name('size').delete
        end
      end
    end
  end
end
