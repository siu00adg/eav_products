class MultiselectVarcharOption < ApplicationRecord
  has_many :multiselect_varchar_values
  belongs_to :option
end
