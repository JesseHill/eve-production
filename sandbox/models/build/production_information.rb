
class ProductionInformation

	attr_reader :industry_level, :production_slot_modifier, :implant_modifier

	def initialize(industry_level = 5, production_slot_modifier = 1, implant_modifier = 1)
		@industry_level = industry_level
		@production_slot_modifier = production_slot_modifier
		@implant_modifier = implant_modifier
	end
	
end
