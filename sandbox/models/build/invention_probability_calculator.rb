class InventionProbabilityCalculator

	@@special_cases = {
		'Skiff' => 0.3,
		'Mackinaw' => 0.25,
		'Hulk' => 0.2
	}

	def initialize(strategy, decryptor_repo)
		@strategy = strategy
		@decryptor_repo = decryptor_repo
	end

	def chance(item, options = {})
		encryption_skill_multiplier = 0.01 * @strategy.encryption_skill
		data_skill_multiplier = 0.02 * (@strategy.data_skill_one + @strategy.data_skill_two)
		techI_multiplier = 5.0 / (5 - @strategy.techI_item_meta_level(item, options))
		decryptor_multiplier = @decryptor_repo.probability_multiplier(@strategy.decryptor(item, options))

		base_chance(item) * 
			(1 + encryption_skill_multiplier) *
			(1 + data_skill_multiplier * techI_multiplier) *
			decryptor_multiplier
	end		

	def runs(item, options = {})
		if item.in_market_group?(:ships, :rigs)
			return (1 + @decryptor_repo.max_run_modifier(@strategy.decryptor(item, options))) 
		end
		if item.in_market_group?(:ship_equipment)
			return (10 + @decryptor_repo.max_run_modifier(@strategy.decryptor(item, options))) 
		end
		raise "Runs for #{item.typeName} not yet supported."
	end

	def base_chance(item)
		return 0.4 unless item.is_ship?		
		return @@special_cases[item.typeName] if @@special_cases.has_key?(item.typeName)
		return 0.3 if item.in_market_group?(:frigates, :destroyers, :freighters)
		return 0.25 if item.in_market_group?(:cruisers, :industrials)
		0.2
	end
end
