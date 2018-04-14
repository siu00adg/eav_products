class VarcharValue < ApplicationRecord
  belongs_to :option
  has_one :value, :dependent => :destroy
end
