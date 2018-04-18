class Product < ApplicationRecord
  has_many :values, :dependent => :destroy
  belongs_to :product_type

def initialize()
  @data = {}
end

def self.option_filter(filter_hash = {})
# THIS IS A TEST (Select products that have a description like 'abcd' OR a position of 11)
  joins(:values).joins("LEFT JOIN `varchar_values` ON `values`.`valuable_id` = `varchar_values`.`id`")
  .joins("LEFT JOIN `integer_values` ON `values`.`valuable_id` = `integer_values`.`id`")
  .where(" (`values`.`option_id` = 1 AND `varchar_values`.`data` LIKE '%abcd%') OR (`values`.`option_id` = 2 AND `integer_values`.`data` = 11)")
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
