class Value < ApplicationRecord
  belongs_to :option
  belongs_to :product
  belongs_to :valuable, :polymorphic => true
  belongs_to :varchar_value, :foreign_key => 'valuable_id', :optional => true #needed for joins
  belongs_to :integer_value, :foreign_key => 'valuable_id', :optional => true #needed for joins
  belongs_to :decimal_value, :foreign_key => 'valuable_id', :optional => true #needed for joins
  belongs_to :datetime_value, :foreign_key => 'valuable_id', :optional => true #needed for joins
  belongs_to :multiselect_varchar_value, :foreign_key => 'valuable_id', :optional => true #needed for joins
  before_save :save_data
  after_destroy :destroy_data

  def get_data
    self.valuable ? self.valuable.data : nil
  end

  def set_data data
    if(option && option.option_type)
      if(!self.valuable)
        case option.option_type.name
        when VARCHAR
          self.valuable = VarcharValue.new(:data => data)
        when INTEGER
          self.valuable = IntegerValue.new(:data => data)
        when DECIMAL
          self.valuable = DecimalValue.new(:data => data)
        when DATETIME
          self.valuable = DatetimeValue.new(:data => data)
        when MULTISELECT_VARCHAR
          nil # Will need to think about this
          # data will need to be a mutliselect_varchar_option
          # model which will have to be created against the option
          # before it can be set here (will need to check the
          # option is correct before setting too)
          # Maybe if the data isn't a mutliselect_varchar_option
          # model but a string we could search for the right one.
        else
          nil
        end
      else
        self.valuable.data = data
      end
    else
      nil
    end
  end

  private
    def save_data
      self.valuable.save
    end

    def destroy_data
      self.valuable.destroy
    end
end
