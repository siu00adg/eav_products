class VarcharValue < ApplicationRecord
  belongs_to :option
  has_many :values
end
