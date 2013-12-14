#!/usr/bin/env ruby

require_relative '../config/active_record_config'
require_relative '../models/database/inv_type'
require_relative '../models/build/waste_calculator'
require_relative '../models/build/materials_calculator'
require_relative '../models/build/pricing_calculator'
require_relative '../models/pricing/default_pricing_model'

class DecryptorReport

	@@race_map = {
		amarr: "Occult",
		caldari: "Esoteric",
		gallente: "Incognito",
		minmattar: "Cryptic"
	}

	@@decyrptor_types = [ 
		{
			name: "# Augmentation",
			probability_multiplier: 0.6,
			max_run_modifier: 9,
			me_modifier: -2,
			pe_modifier: 1
		},
		{
			name: "Optimized # Augmentation",
			probability_multiplier: 0.9,
			max_run_modifier: 7,
			me_modifier: 2,
			pe_modifier: 0
		},
		{
			name: "# Symmetry",
			probability_multiplier: 1,
			max_run_modifier: 2,
			me_modifier: 1,
			pe_modifier: 4
		},
		{
			name: "# Process",
			probability_multiplier: 1.1,
			max_run_modifier: 0,
			me_modifier: 3,
			pe_modifier: 3
		},
		{
			name: "# Accelerant",
			probability_multiplier: 1.2,
			max_run_modifier: 1,
			me_modifier: 2,
			pe_modifier: 5
		},
		{
			name: "# Parity",
			probability_multiplier: 1.5,
			max_run_modifier: 3,
			me_modifier: 1,
			pe_modifier: -1
		},
		{
			name: "# Attainment",
			probability_multiplier: 1.8,
			max_run_modifier: 4,
			me_modifier: -1,
			pe_modifier: 2
		},
		{
			name: "Optimized # Attainment",
			probability_multiplier: 1.9,
			max_run_modifier: 2,
			me_modifier: 1,
			pe_modifier: -1
		},
	]

	def initialize
		@pricing = DefaultPricingModel.new().pricing
		@pricing_calculator = PricingCalculator.new(@pricing)

		# Create the objects needed to compute material costs.
		# blueprint_repository = BlueprintRepository.new()
		# waste_calculator = WasteCalculator.new(5, blueprint_repository)
		# @materials_calculator = MaterialsCalculator.new(waste_calculator)
	end

	def decryptor_name(item)
		@@race_map[item.inv_market_group.marketGroupName.downcase.to_sym]
	end

	def run(typeName)
		item = InvType.find_by_typeName(typeName)
		if !item.is_ship?
			puts "The decryptor report is only set up for ships. Sorry."
			exit
		end
		racial_name = decryptor_name(item)
		@@decyrptor_types.each { |d|
			puts d[:name].sub('#', racial_name)
		}
	end
end

ActiveRecordConfig.init
DecryptorReport.new().run(ARGV[0])