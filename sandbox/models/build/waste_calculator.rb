class WasteCalculator

	def initialize(efficiency, blueprintRepo)
		@production_efficiency = efficiency
		@blueprintRepo = blueprintRepo
	end

	def production_waste(quantity)
		(quantity * (0.25 - (0.05 * @production_efficiency))).round
	end	

	def calculate_required_quantity(blueprint, quantity)
		blueprint = blueprint.inv_blueprint_type if blueprint.is_a? InvType
		materialLevel = @blueprintRepo.material_level(blueprint)
		if materialLevel >= 0
			required = quantity + (quantity * ((blueprint.wasteFactor.to_f / (materialLevel + 1)) / 100)).round
		else
			required = quantity + (quantity * (1  - materialLevel) * (blueprint.wasteFactor.to_f / 100)).round
		end
		required += production_waste(quantity)
	end

end
