class Product < ApplicationRecord
  has_many :values, :dependent => :destroy
  belongs_to :product_type

def self.filter(filter_hash = {})

  where_string = ""
  where_array = []

  filter_hash.each_with_index do |(key, value), index|
    option = Option.find_by_name(key.to_s)
    if option
      if(option.data_table == 'varchar_values') #hack for now...
        operator = "LIKE"
      else
        operator = "="
      end
      where_string << "(`values`.`option_id` = %s AND `%s`.`data` #{operator} '%s')"
      if index != filter_hash.size - 1
        where_string << " AND "
      end
      where_array.push(option.id)
      where_array.push(option.data_table)
      if operator == "LIKE" #another hack for now...
        where_array.push("%#{value}%")
      else
        where_array.push(value)
      end
    end
  end
  where_array.unshift(where_string)

 #   where_string
 # where_array
  if where_string.empty?
    where_string = "1=1"
  end

# THIS IS A TEST (Select products that have a description like 'abcd' OR a position of 11)
# where_string = " (`values`.`option_id` = 1 AND `varchar_values`.`data` LIKE '%abcd%') OR (`values`.`option_id` = 2 AND `integer_values`.`data` = 11)"
# where_array = [" (`values`.`option_id` = %s AND `varchar_values`.`data` LIKE '%s') OR (`values`.`option_id` = %s AND `integer_values`.`data` = %s)",
# 1, '%abcd%', 2, 11]
  joins(:values)
  .joins("LEFT JOIN `varchar_values` ON `values`.`valuable_id` = `varchar_values`.`id`")
  .joins("LEFT JOIN `integer_values` ON `values`.`valuable_id` = `integer_values`.`id`")
  .joins("LEFT JOIN `decimal_values` ON `values`.`valuable_id` = `decimal_values`.`id`")
  .where(where_array)
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

def get_data_by_name(option_name)
  if @data && @data[option_name]
    @data[option_name]
  else
    option = Option.find_by_name(option_name)
    if option
      @data = {} if !@data
      @data[option_name] = get_data(option)
      @data[option_name]
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
  value.destroy if value # NEED TO CHECK FOR ORPHANS?
end

private
  def option_used?(option)
    option.product_types.where(:id => self.product_type.id).count > 0
  end

  def load_data_by_type(type)
    sql_array = ["
    SELECT `options`.`name`, `data` FROM `values` \
    INNER JOIN `%s` ON `values`.`valuable_id` = `%s`.`id` \
    INNER JOIN `options` ON `values`.`option_id` = `options`.`id` \
    WHERE `values`.`product_id` = %s && `values`.`valuable_type` = '%s'",
    "#{type.name}_values",
    "#{type.name}_values",
    self.id,
    "#{type.name.capitalize}Value"]

    sql = ActiveRecord::Base.send(:sanitize_sql_array, sql_array)
    results = ActiveRecord::Base.connection.exec_query(sql)

    @data = {} if !@data

    results.each do |row|
      @data[row["name"]] = row["data"]
    end
  end

end
