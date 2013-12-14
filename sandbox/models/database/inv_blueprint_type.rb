require 'active_record'

class InvBlueprintType < ActiveRecord::Base
	self.table_name = "invBlueprintTypes"
	self.primary_key = "blueprintTypeID"
	
	belongs_to :inv_type, :foreign_key => 'productTypeID'
	has_many :ram_type_requirements, :class_name => 'RamTypeRequirement', :foreign_key => 'typeID'

	def ram_type_requirements_for_manufacturing
		manufacturing = RamActivity.find_by_activityName("Manufacturing")
		ram_type_requirements.select {|r| r.ram_activity == manufacturing}
	end

	def ram_type_requirements_for_invention
		invention = RamActivity.find_by_activityName("Invention")
		ram_type_requirements.select {|r| r.ram_activity == invention}
	end	

	def in_market_group?(group)
		inv_type.in_market_group?(group)
	end

	def is_techII?
		inv_type.is_techII?
	end
end