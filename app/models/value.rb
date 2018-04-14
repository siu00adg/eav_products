class Value < ApplicationRecord
  belongs_to :option
  belongs_to :product
  belongs_to :varchar_value,
              :foreign_key => "type_value_id",
              :optional => true

  def get_value
    if(option && option.option_type) #Overkill?
      case option.option_type.name
      when VARCHAR
        varchar_value ? varchar_value.value : nil
      when INTEGER
        integer_value ? integer_value.value : nil
      when DECIMAL
        decimal_value ? decimal_value.value : nil
      when DATETIME
        datetime_value ? datetime_value.value : nil
      when MULTISELECT
        nil # Will need to think about this
      else
        nil
      end
    else
      nil
    end
  end

end
