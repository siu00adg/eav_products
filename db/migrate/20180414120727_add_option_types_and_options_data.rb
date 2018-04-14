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
        option_types = ["varchar","integer","decimal","datetime","multiselect"]
        options = ["description","position","price","expiry","size"]
        option_types.each do |ot|
          OptionType.find_by_name(ot).delete if OptionType.find_by_name(ot)
        end
        options.each do |o|
          Option.find_by_name(o).delete if Option.find_by_name(o)
        end
      end
    end
  end
end
