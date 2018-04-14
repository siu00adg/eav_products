class Option < ApplicationRecord
  belongs_to :option_type
  has_many :values
  has_many :products, :through => :values
end
