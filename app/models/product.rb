class Product < ApplicationRecord
  has_many :values, :dependent => :destroy
  has_many :options, :through => :values
  belongs_to :product_type

def get_data_by_name(option_name)
  option = Option.find_by_name(option_name)
  option ? get_data(option) : nil
end

def get_data(option)
  value = option.values.where(:product => self).first
  value ? value.get_data : nil
end

def set_data_by_name(option_name, data)
  option = Option.find_by_name(option_name)
  option ? set_data(option, data) : nil
end

def set_data(option, data)
  value = Value.where(:option => option, :product => self).first
  if !value
    value = Value.create(:option => option, :product => self)
  end
  value.set_data(data)
end

def destroy_data_by_name(option_name)
  option = Option.find_by_name(option_name)
  option ? destroy_data(option) : nil
end

def destroy_data(option)
  value = option.values.where(:product => self).first
  value.destroy if value
end

end
