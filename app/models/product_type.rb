class ProductType < ApplicationRecord
  has_and_belongs_to_many :options
  has_one :product
end
