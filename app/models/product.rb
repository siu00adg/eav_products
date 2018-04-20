class Product < ApplicationRecord
  has_many :values, :dependent => :destroy
  belongs_to :product_type

  OPERATORS = {:equal => "=", :like => "LIKE", :gt => ">", :lt => "<"}

  def self.sort
    #need to work out how to sort by an option
  end

  def self.filter(filter_hash = {})
    start = Time.now
    if !filter_hash.empty?
      filter_array = []
      types_array = []

      filter_hash.each do |key, value|
        option = Option.find_by_name(key.to_s)
        if !option
          # Option doesn't exist so return nil
          return nil
        end
        if value.is_a?(Hash)
          if !OPERATORS[value.keys.first]
            # Operator doesn't exist so return nil
            return nil
          end
          filter_array << [option, OPERATORS[value.keys.first], value.values.first]
        else
          filter_array << [option, OPERATORS[:equal], value]
        end
        types_array << option.option_type.name
      end

      types_array = types_array.uniq

      type_sql = ""
      types_array.each_with_index do |type, index|
        type_sql << "`#{type}_values`.`data` "
        type_sql << "AS `#{type}_data` "
        type_sql << ", " if index != types_array.size - 1
      end

      join_sql = ""
      types_array.each do |type|
        join_sql << "LEFT JOIN `#{type}_values` "
        join_sql << "ON `values`.`valuable_id` = `#{type}_values`.`id` "
        join_sql << "AND `values`.`valuable_type` = '#{type.capitalize}Value' "
      end

      where_option_sql = "WHERE `values`.`option_id` IN ("
      filter_array.each_with_index do |filter, index|
        where_option_sql << "#{filter[0].id}"
        where_option_sql << "," if index != filter_array.size - 1
      end
      where_option_sql << ")"

      case_sql = ""
      filter_array.each_with_index do |filter, index|
        case_sql << "CASE WHEN `p`.`option_id` = #{filter[0].id} "
        case_sql << "THEN `p`.`#{filter[0].option_type.name}_data` "
        case_sql << "END AS `#{filter[0].name}` "
        case_sql << ", " if index != filter_array.size - 1
      end

      max_sql = ""
      filter_array.each_with_index do |filter, index|
        max_sql << "MAX(IFNULL(`p2`.`#{filter[0].name}`,0)) "
        max_sql << "AS `#{filter[0].name}` "
        max_sql << ", " if index != filter_array.size - 1
      end

      # This is for filtering by an attribute on the product record
      # e.g. where_product_attribute_sql = "WHERE `name` LIKE '%something%'"
      where_product_attribute_sql = ""

      where_sql = "WHERE "
      filter_array.each_with_index do |filter, index|
        where_value = filter[2]
        where_value = "%" + where_value + "%" if filter[1] == "LIKE"
        where_sql << "(`#{filter[0].name}` #{filter[1]} '#{where_value}') "
        where_sql << "AND " if index != filter_array.size - 1
      end

      # Possible future optimisation:
      # Adding "AND `values`.`option_id` = X" to <type>_values joins
      query = <<-SQL
      SELECT *
        FROM   (SELECT `p2`.`id`,
                      `p2`.`name`,
                      #{max_sql}
               FROM   (SELECT `p`.`id`,
                              `p`.`name`,
                              `p`.`option_id`,
                              #{case_sql}
                       FROM   (SELECT *
                               FROM   (#{existing_scope_sql}) AS `existing_scope`
                                      JOIN (SELECT `values`.`product_id`,
                                                   `values`.`option_id`,
                                                   #{type_sql}
                                            FROM   `values`
                                                   #{join_sql}
                                            #{where_option_sql}) AS `v`
                                        ON `v`.`product_id` = `existing_scope`.`id`
                               #{where_product_attribute_sql}) AS `p`) AS `p2`
               GROUP  BY `p2`.`id`) AS `p3`
        #{where_sql}
      SQL
      results_array = self.find_by_sql(query)
      result = self.where(id: results_array.map(&:id))
      logger.info("Filter results: #{results_array.count} record(s)")
      logger.info("Filter time taken: #{Time.now - start} seconds")
      result
    else
      nil
    end
  end

  def get_option(option_name)
    if @data && @data[option_name]
      @data[option_name]
    else
      option = Option.find_by_name(option_name.to_s)
      if option
        @data = {} if !@data
        @data[option_name] = get_option_data(option)
        @data[option_name]
      else
        nil
      end
    end
  end

  def set_option(option_name, data)
    option = Option.find_by_name(option_name)
    if option
      #probably need to check the type is correct.
      @data = {} if !@data
      @data[option_name] = data
    end
    option ? set_option_data(option, data) : nil
  end

  def option(option_name, data = nil)
    if data
      set_option(option_name, data)
    else
      get_option(option_name)
    end
  end

  private
    def load_all_data
      option_types = OptionType.all
      option_types.each do |type|
        # hack while not all type models exist
        if type.name == 'varchar' || type.name == 'integer' || type.name == 'decimal'
          load_data_by_type(type)
        end
      end
    end

    def get_option_data(option)
      if option_used?(option)
        value = option.values.where(:product => self).first
        value ? value.get_data : nil
      else
        nil
      end
    end

    def set_option_data(option, data)
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

    def self.existing_scope_sql
        self.connection.unprepared_statement {self.reorder(nil).select("id, name").to_sql}
    end
end
