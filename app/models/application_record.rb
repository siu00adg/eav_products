class ApplicationRecord < ActiveRecord::Base

  # Option Types
  VARCHAR = "varchar"
  INTEGER = "integer"
  DECIMAL = "decimal"
  DATETIME = "datetime"
  MULTISELECT = "multiselect"

  self.abstract_class = true
end
