require_relative '../database/inv_type'

class BlueprintRepository

	def material_level(key)
		blueprint = lookup_item(key)

		# Check some stored list of owned bpos? 
		# There doesn't seem to be an API that will allow this info to be grabbed dynamically.
		# We might prefer default values in most cases anyway to do fair comparisons between items.

		# Punt to some default values.
		default_material_level(blueprint)
	end

	def productivity_level(key)
		blueprint = lookup_item(key)

		# Check some stored list of owned bpos? 
		# There doesn't seem to be an API that will allow this info to be grabbed dynamically.
		# We might prefer default values in most cases anyway to do fair comparisons between items.

		# Punt to some default values.
		default_productivity_level(blueprint)
	end	

	private

	def lookup_item(key)
		return InvBlueprintType.find_by_blueprintTypeID(key) if key.is_a? Numeric
		return InvType.find_by_typeName(key).inv_blueprint_type if key.is_a? String
		return key if key.is_a? InvBlueprintType
		raise "Invalid argument"
	end

	def default_material_level(blueprint)
		meta_group = blueprint.inv_type.inv_meta_group
		return 0 if meta_group && (meta_group.is_faction? || meta_group.is_officer?)

		if blueprint.in_market_group?(:ships)
			return blueprint.is_techII? ? -3 : 20 if blueprint.in_market_group?(:frigates)
			return blueprint.is_techII? ? -1 : 50 if blueprint.in_market_group?(:cruisers)
			return blueprint.is_techII? ? -1 : 60
		end

		return blueprint.is_techII? ? -4 : 100 
	end

	def default_productivity_level(blueprint)
		return blueprint.is_techII? ? -4 : 15
	end	
end