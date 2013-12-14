require 'active_record'

class InvBlueprintType < ActiveRecord::Base
	self.table_name = "invBlueprintTypes"
	self.primary_key = "blueprintTypeID"
	
	belongs_to :inv_type, :foreign_key => 'productTypeID'
	has_many :ram_type_requirements, :class_name => 'RamTypeRequirement', :foreign_key => 'typeID'

	def ram_type_requirements_for(activityName)
		RamTypeRequirement.where(typeID: blueprintTypeID).
			joins(:ram_activity).
			where(ramActivities: {activityName: activityName.to_s.titleize})
	end

	def ram_type_requirements_for_manufacturing
		ram_type_requirements_for(:manufacturing)
	end

	def ram_type_requirements_for_invention
		ram_type_requirements_for(:invention)
	end	

	def in_market_group?(*group)
		inv_type.in_market_group?(group)
	end

	def is_techII?
		inv_type.is_techII?
	end
end