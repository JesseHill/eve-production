require 'active_record'

class InvTypeMaterial < ActiveRecord::Base

	self.table_name = "invTypeMaterials"
	
	belongs_to :required_for, :class_name => 'InvType', :foreign_key => 'typeID'
	belongs_to :required_type, :class_name => 'InvType', :foreign_key => 'materialTypeID'

end