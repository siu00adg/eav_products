class ProductType < ApplicationRecord
  has_and_belongs_to_many :options, :dependent => :destroy
  has_one :product
end
