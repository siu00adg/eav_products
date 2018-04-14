class Product < ApplicationRecord
  has_many :values
  has_many :options, :through => :values
  has_and_belongs_to_many :categories

def get_data_by_name(option_name)
  option = Option.find_by_name(option_name)
  option ? get_data(option) : nil
end

def get_data(option)
  value = option.values.where(:product => self).first
  value ? value.get_value : nil
  #value ? value.type_value_id : nil
end

def set_data_by_name(option_name, value)
end

def set_data(option, value)
end


end
