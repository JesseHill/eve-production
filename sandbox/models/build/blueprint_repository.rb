require_relative '../database/inv_type'

class BlueprintRepository

	def material_level(blueprint)
		blueprint = InvBlueprintType.find_by_blueprintTypeID(blueprint) if blueprint.is_a? Numeric
		blueprint = InvType.find_by_typeName(blueprint).inv_blueprint_type if blueprint.is_a? String
		raise "Invalid argument" unless blueprint.is_a? InvBlueprintType

		# Check some stored list of owned bpos? 
		# There doesn't seem to be an API that will allow this info to be grabbed dynamically.
		# We might prefer default values in most cases anyway to do fair comparisons between items.

		# Punt to some default values.
		default_material_level(blueprint)
	end

	private

	def default_material_level(blueprint)
		return 0 if blueprint.inv_type.inv_meta_group.is_faction?
		return 0 if blueprint.inv_type.inv_meta_group.is_officer?
		if blueprint.in_market_group?(:ships)
			return blueprint.is_techII? ? -3 : 20 if blueprint.in_market_group?(:frigates)
			return blueprint.is_techII? ? -1 : 50 if blueprint.in_market_group?(:cruisers)
			return blueprint.is_techII? ? -1 : 60
		end

		return blueprint.is_techII? ? -4 : 100 
	end
end