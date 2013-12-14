
class InventionCostCalculator

	def initilize(decryptor_repository, encryption_skill = 4, data_skill_one = 4, data_skill_two = 4, item_meta_level = 0)
		@decryptor_repository = decryptor_repository
		@encryption_skill = encryption_skill
		@data_skill_one = data_skill_one
		@data_skill_two = data_skill_two
		@item_meta_level = item_meta_level
	end

	def base_chance(item)
		return 0.4 unless item.is_ship?
		
		return 0.3 if item.typeName == 'Skiff'
		return 0.25 if item.typeName == 'Mackinaw'
		return 0.2 if item.typeName == 'Hulk'		

		return 0.3 if item.in_market_group?(:frigates) or 
			item.in_market_group?(:destroyers) or
			item.in_market_group?(:freighters)

		return 0.25 if item.in_market_group?(:cruisers) or 
			item.in_market_group?(:industrials)

		0.2
	end

	def chance(item)
		base_chance(item) * 
			(1 + (0.1 * @encryption_skill)) *
			(1 + (0.2 * (@data_skill_one + @data_skill_two) * (5 / (5 - @item_meta_level)) *
			@decryptor_repository.probability_multiplier(item)
	end

	def cost(item)
		ram_requirements = inv_type.
			ram_type_requirements_for_invenction.
			reject { |r| r.required_type.is_skill? }
	end
end