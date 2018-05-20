class MultiselectVarcharValue < ApplicationRecord
  has_one :value, :as => :valuable, :dependent => :destroy
  belongs_to :multiselect_varchar_option
end
