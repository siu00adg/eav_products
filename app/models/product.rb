class Product < ApplicationRecord
  has_many :values, :dependent => :destroy
  belongs_to :product_type

  @@data = {}

def test
  load_all_data
  @@data
end

# Need to limit getting and setting data based on options on the product_type

def get_data_by_name(option_name)
  if @@data[option_name]
    @@data[option_name]
  else
    option = Option.find_by_name(option_name)
    if option
      @@data[option_name] = get_data(option)
      @@data[option_name]
    else
      nil
    end
  end
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

  def load_all_data
    option_types = OptionType.all
    option_types.each do |type|
      # hack while not all type models exist
      if type.name == 'varchar' || type.name == 'integer' || type.name == 'decimal'
        load_data_by_type(type)
      end
    end
  end

  def load_data_by_type(type)
    sql_array = ["
    SELECT `options`.`name`, `data` \
    FROM `products` \
    INNER JOIN `values` ON `values`.`product_id` = \
               `products`.`id` && `valuable_type` = '%s' \
    INNER JOIN `%s` ON `values`.`valuable_id` = \
               `%s`.`id` \
    INNER JOIN `product_types` ON `products`.`product_type_id` = \
               `product_types`.`id` \
    INNER JOIN `options_product_types` ON `product_types`.`id` = \
               `options_product_types`.`product_type_id` \
    INNER JOIN `options` ON `options_product_types`.`option_id` = \
               `options`.`id` \
    INNER JOIN `option_types` ON `options`.`option_type_id` = \
               `option_types`.`id` && `option_types`.`name` = '%s' \
    WHERE `products`.`id` = %s
    ",
    "#{type.name.capitalize}Value",
    "#{type.name}_values",
    "#{type.name}_values",
    type.name,
    self.id]

    sql = ActiveRecord::Base.send(:sanitize_sql_array, sql_array)
    results = ActiveRecord::Base.connection.exec_query(sql)
    results.each do |row|
      @@data[row["name"]] = row["data"]
    end
  end

end
