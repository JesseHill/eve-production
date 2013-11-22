require 'active_record'

class InvMetaGroup < ActiveRecord::Base
	self.table_name = "invMetaGroups"
	self.primary_key = "metaGroupID"

	has_many :inv_types, through: :inv_meta_type
end