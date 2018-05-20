class ApplicationRecord < ActiveRecord::Base

  # Option Types
  VARCHAR = "varchar"
  INTEGER = "integer"
  DECIMAL = "decimal"
  DATETIME = "datetime"
  MULTISELECT_VARCHAR = "multiselect_varchar"

  self.abstract_class = true
end
