require 'active_record'
require_relative 'inv_category'

class InvGroup < ActiveRecord::Base
	self.table_name = "invGroups"
	self.primary_key = "groupID"

	belongs_to :inv_category, :foreign_key => 'categoryID'

	def is_skill?
		inv_category.is_skill?
	end

	def is_ship?
		inv_category.is_ship?
	end
end