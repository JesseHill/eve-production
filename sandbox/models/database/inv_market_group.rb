require 'active_record'
require 'active_support/inflector'

class InvMarketGroup < ActiveRecord::Base
	self.table_name = "invMarketGroups"
	self.primary_key = "marketGroupID"

	has_many :child_groups, class_name: "InvMarketGroup", foreign_key: "parentGroupID"
	belongs_to :parent_group, class_name: "InvMarketGroup", foreign_key: "parentGroupID"

	def included_in?(name)
		name = ActiveSupport::Inflector.titleize(name)
		return true if name == marketGroupName
		parent_group.nil? ? false : parent_group.included_in?(name)
	end

	def leaf_groups
		hasTypes ?
			self :
			child_groups.flat_map { |g| g.leaf_groups }
	end

end