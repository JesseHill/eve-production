require_relative '../database/inv_type'

class BlueprintRepository

	def initialize(decryptor_repository, decryptor_strategy)
		@decryptor_repository = decryptor_repository
		@decryptor_strategy = decryptor_strategy
	end

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
		return key.inv_blueprint_type if key.is_a? InvType
		return InvBlueprintType.find_by_blueprintTypeID(key) if key.is_a? Numeric
		return InvType.find_by_typeName(key).inv_blueprint_type if key.is_a? String
		return key if key.is_a? InvBlueprintType
		raise "Invalid argument"
	end

	def default_material_level(blueprint)
		return 0 if blueprint.inv_type.is_officer_or_faction?

		if blueprint.is_techII?
			decryptor = @decryptor_strategy.decryptor(blueprint.inv_type)
			return -4 + (decryptor ? @decryptor_repository.me_modifier(decryptor) : 0)
		end 
		
		return 20 if blueprint.in_market_group?(:frigates)
		return 50 if blueprint.in_market_group?(:cruisers)
		return 60 if blueprint.in_market_group?(:ships)

		100 
	end

	def default_productivity_level(blueprint)
		return 0 if blueprint.inv_type.is_officer_or_faction?

		if blueprint.is_techII?
			decryptor = @decryptor_strategy.decryptor(blueprint.inv_type)
			return -4 + (decryptor ? @decryptor_repository.pe_modifier(decryptor) : 0)
		end 

		15
	end	
end