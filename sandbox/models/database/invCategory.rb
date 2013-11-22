require 'active_record'

class InvCategory < ActiveRecord::Base
	self.table_name = "invCategories"
	self.primary_key = "categoryID"

	def is_skill?
		categoryName == 'Skill'
	end

	def is_ship?
		categoryName == 'Ship'
	end
end