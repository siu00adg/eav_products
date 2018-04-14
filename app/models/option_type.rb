class OptionType < ApplicationRecord
  has_many :options, :dependent => :destroy
end
