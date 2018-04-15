class IntegerValue < ApplicationRecord
  has_one :value, :as => :valuable, :dependent => :destroy
end
