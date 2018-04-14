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
        OptionType.find_by_name('varchar').destroy
        OptionType.find_by_name('integer').destroy
        OptionType.find_by_name('decimal').destroy
        OptionType.find_by_name('datetime').destroy
        OptionType.find_by_name('multiselect').destroy
      end
    end
  end
end
