class Value < ApplicationRecord
  belongs_to :option
  belongs_to :product
  belongs_to :varchar_value,
              :foreign_key => "type_value_id",
              :optional => true
  # belongs_to :integer_value,
  #             :foreign_key => "type_value_id",
  #             :optional => true
  # belongs_to :decimal_value,
  #             :foreign_key => "type_value_id",
  #             :optional => true
  # belongs_to :datetime_value,
  #             :foreign_key => "type_value_id",
  #             :optional => true
  ## belongs_to :multiselect_value,
  ##             :foreign_key => "type_value_id",
  ##             :optional => true


  def get_data
    if(option && option.option_type) #Overkill?
      case option.option_type.name
      when VARCHAR
        self.varchar_value ? self.varchar_value.data : nil
      when INTEGER
        self.integer_value ? self.integer_value.data : nil
      when DECIMAL
        self.decimal_value ? self.decimal_value.data : nil
      when DATETIME
        self.datetime_value ? self.datetime_value.data : nil
      when MULTISELECT
        nil # Will need to think about this
      else
        nil
      end
    else
      nil
    end
  end

  def set_data data
    if(option && option.option_type) #Overkill?
      case option.option_type.name
      when VARCHAR
        self.varchar_value = VarcharValue.create(:option => option, :data => data)
        self.save
      when INTEGER
        nil # need to create model
        # integer_value = IntegerValue.create(:option => option, :value => value)
      when DECIMAL
        nil # need to create model
        # decimal_value = DecimalValue.create(:option => option, :value => value)
      when DATETIME
        nil # need to create model
        # datetime_value = DateTimeValue.create(:option => option, :value => value)
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
