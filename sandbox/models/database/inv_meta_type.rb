require 'active_record'

class InvMetaType < ActiveRecord::Base
	self.table_name = "invMetaTypes"
	belongs_to :inv_type, :foreign_key => 'typeID'
	belongs_to :inv_meta_group, :foreign_key => 'metaGroupID'
end