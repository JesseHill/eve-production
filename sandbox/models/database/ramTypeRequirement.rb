require 'active_record'
require './models/database/ramActivity.rb'

class RamTypeRequirement < ActiveRecord::Base
	self.table_name = "ramTypeRequirements"
	belongs_to :required_for, :class_name => 'InvBluprintType', :foreign_key => 'typeID'
	belongs_to :required_type, :class_name => 'InvType', :foreign_key => 'requiredTypeID'
	belongs_to :ram_activity, :class_name => 'RamActivity', :foreign_key => 'activityID'
end