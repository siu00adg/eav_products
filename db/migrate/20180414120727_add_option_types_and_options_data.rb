class AddOptionTypesAndOptionsData < ActiveRecord::Migration[5.1]
  def change
    reversible do |dir|
      option_types = ["varchar","integer","decimal","datetime","multiselect_varchar"]
      dir.up do
        option_types.each do |ot|
          OptionType.create(:name => ot)
        end
      end
      dir.down do
        option_types.each do |ot|
          OptionType.find_by_name(ot).delete if OptionType.find_by_name(ot)
        end
      end
    end
  end
end
