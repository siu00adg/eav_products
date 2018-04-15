class Product < ApplicationRecord
  has_many :values, :dependent => :destroy
  belongs_to :product_type

# Need to limit getting and setting data based on options on the product_type

def get_all_data
  #
  #
  #
end

def get_data_by_name(option_name)
  option = Option.find_by_name(option_name)
  option ? get_data(option) : nil
end

def get_data(option)
  if option_used?(option)
    value = option.values.where(:product => self).first
    value ? value.get_data : nil
  else
    nil
  end
end

def set_data_by_name(option_name, data)
  option = Option.find_by_name(option_name)
  option ? set_data(option, data) : nil
end

def set_data(option, data)
  if option_used?(option)
    value = Value.where(:option => option, :product => self).first
    if !value
      value = Value.create(:option => option, :product => self)
    end
    value.set_data(data)
  else
    nil
  end
end

def destroy_data_by_name(option_name)
  option = Option.find_by_name(option_name)
  option ? destroy_data(option) : nil
end

def destroy_data(option)
  value = option.values.where(:product => self).first
  value.destroy if value # NEED TO CHECK FOR ORPHANS
end

private
  def option_used?(option)
    option.product_types.where(:id => self.product_type.id).count > 0
  end

end
