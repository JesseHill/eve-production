
class ProductionInformation

	attr_reader :industry_skill, :production_slot_modifier, :implant_modifier

	def initialize(industry_skill = 5, production_slot_modifier = 1, implant_modifier = 1)
		@industry_skill = industry_skill
		@production_slot_modifier = production_slot_modifier
		@implant_modifier = implant_modifier
	end
	
end
