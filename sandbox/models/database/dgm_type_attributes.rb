require 'active_record'

class DgmTypeAttributes < ActiveRecord::Base
	self.table_name = "dgmTypeAttributes"
	self.primary_key = "typeID"
end