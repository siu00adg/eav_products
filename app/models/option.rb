class Option < ApplicationRecord
  belongs_to :option_type
  has_many :values
  has_many :products, :through => :values
  has_many :varchar_values
end
