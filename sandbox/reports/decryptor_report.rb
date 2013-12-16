#!/usr/bin/env ruby

require_relative '../config/active_record_config'
require_relative '../models/database/inv_type'
require_relative '../models/build/job'
require_relative '../models/build/waste_calculator'
require_relative '../models/build/materials_calculator'
require_relative '../models/build/pricing_calculator'
require_relative '../models/build/decryptor_repository'
require_relative '../models/build/invention_strategy'
require_relative '../models/build/invention_probability_calculator'
require_relative '../models/build/invention_cost_calculator'
require_relative '../models/pricing/default_pricing_model'
require_relative '../presentation/formatting'

class DecryptorStrategy
	def initialize(decryptor)
		@decryptor = decryptor
	end

	def decryptor(item)
		@decryptor
	end
end

class TechIStrategy

	def techI_item(item)
		nil
	end

	def techI_item_meta_level(item)
		0
	end	
end

class MaterialLevelCalculator

	def initialize(modifier)
		@material_level = -4 + modifier
	end

	def material_level(item)
		@material_level
	end

end

class DecryptorReport

	def initialize
		@pricing = DefaultPricingModel.new.pricing
		@pricing_calculator = PricingCalculator.new(@pricing)
		@decryptor_repository = DecryptorRepository.new
	end

	def run(typeName)
		item = InvType.find_by_typeName(typeName)
		if !item.is_ship?
			puts "The decryptor report is only set up for ships. Sorry."
			exit
		end

		job = Job.new(item, 1)

		base_material_level_calculator = MaterialLevelCalculator.new(0)
		base_waste_calculator = WasteCalculator.new(5, base_material_level_calculator)
		base_materials_calculator = MaterialsCalculator.new(base_waste_calculator)
		base_data = job
			.accept(base_materials_calculator)
			.accept(@pricing_calculator)
			.data

		data = @decryptor_repository.types.map do |type|
			decryptor = @decryptor_repository.find(item, type)

			decryptor_strategy = DecryptorStrategy.new(decryptor)
			invention_strategy = InventionStrategy.new(decryptor_strategy, TechIStrategy.new)
			invention_calculator = InventionProbabilityCalculator.new(invention_strategy, @decryptor_repository)
			invention_cost = InventionCostCalculator.new(@pricing, invention_calculator, invention_strategy)

			material_level_calculator = MaterialLevelCalculator.new(@decryptor_repository.me_modifier(decryptor))
			waste_calculator = WasteCalculator.new(5, material_level_calculator)
			materials_calculator = MaterialsCalculator.new(waste_calculator)
			
			build_data = job
				.accept(materials_calculator)
				.accept(invention_cost)
				.accept(@pricing_calculator)
				.data

			{
				name: decryptor.typeName,
				materials: build_data[:invention_materials],
				build_cost: build_data[:material_cost],
				build_profit: build_data[:profit],
				invention_cost: build_data[:invention_cost],
				invention_profit: build_data[:profit] - base_data[:profit] - build_data[:invention_cost],
			}
		end

		puts 
		puts "-" * 50
		puts item.typeName
		puts "-" * 50
		puts
		puts "Sell price: #{Formatting.format_isk(base_data[:value])}"
		puts "Base cost: #{Formatting.format_isk(base_data[:material_cost])}"
		puts "Profit with no decryptors: #{Formatting.format_isk(base_data[:profit])}"
		puts

		data
			.sort_by { |d| d[:invention_profit] }
			.each do |d|
				puts d[:name]
				puts "\tBuild cost: #{Formatting.format_isk(d[:build_cost])}"
				puts "\tBuild value: #{Formatting.format_isk(base_data[:value])}"
				puts "\tBuild profit: #{Formatting.format_isk(d[:build_profit])}"
				puts "\tInvention cost per run: #{Formatting.format_isk(d[:invention_cost])}"
				puts "\tInvention profit per run: #{Formatting.format_isk(d[:invention_profit])}"
				puts "\tMaterials:"
				d[:materials].each do |material, quantity|
					puts "\t\t#{quantity} #{material.typeName} at #{Formatting.format_isk(@pricing.buy_price(material))}"
				end
				puts ""	
			end
	end
end

ActiveRecordConfig.init
DecryptorReport.new().run(ARGV[0])