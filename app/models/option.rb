class Option < ApplicationRecord
  belongs_to :option_type
  has_many :values
  has_and_belongs_to_many :product_types
  has_many :multiselect_varchar_options

  def data_table
    "#{self.option_type.name}_values"
  end
end
