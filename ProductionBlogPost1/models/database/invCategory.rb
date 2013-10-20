require 'active_record'

class InvCategory < ActiveRecord::Base
	self.table_name = "invCategories"
	self.primary_key = "categoryID"

	def is_skill?
		categoryID == 16
	end
end