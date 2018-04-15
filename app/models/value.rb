class Value < ApplicationRecord
  belongs_to :option
  belongs_to :product
  belongs_to :valuable, :polymorphic => true
  belongs_to :varchar_value, :foreign_key => 'valuable_id', :optional => true #needed for joins
  belongs_to :integer_value, :foreign_key => 'valuable_id', :optional => true #needed for joins
  belongs_to :decimal_value, :foreign_key => 'valuable_id', :optional => true #needed for joins
  # belongs_to :datetime_value, :foreign_key => 'valuable_id', :optional => true #needed for joins
  # #belongs_to :multiselect_value, :foreign_key => 'valuable_id', :optional => true #needed for joins

  def get_data
    self.valuable ? self.valuable.data : nil
  end

  def set_data data
    if(option && option.option_type)
      case option.option_type.name
      when VARCHAR
        self.valuable = VarcharValue.create(:data => data)
        self.save
      when INTEGER
        self.valuable = IntegerValue.create(:data => data)
        self.save
      when DECIMAL
        self.valuable = DecimalValue.create(:data => data)
        self.save
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
