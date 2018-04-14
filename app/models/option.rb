class Option < ApplicationRecord
  belongs_to :option_type
  has_many :values
  has_many :products, :through => :values
  has_many :varchar_values
  has_and_belongs_to_many :product_types
end
