require 'active_record'

class InvMarketGroup < ActiveRecord::Base
	self.table_name = "invMarketGroups"
	self.primary_key = "marketGroupID"

	has_many :child_groups, class_name: "InvMarketGroup", foreign_key: "parentGroupID"
	belongs_to :parent_group, class_name: "InvMarketGroup", foreign_key: "parentGroupID"

	def included_in_group?(name)
		return true if name == marketGroupName
		parent_group.nil? ? false : parent_group.included_in_group?(name)
	end

	def included_in_frigates?
		included_in_group?('Frigates')
	end

	def included_in_cruisers?
		included_in_group?('Cruisers')
	end

end