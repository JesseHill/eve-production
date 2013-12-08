#!/usr/bin/ruby
require 'nokogiri'
require 'open-uri'
require 'active_record'
require 'yaml'

require_relative '../models/database/map_solar_systems'
require_relative '../models/build/build'
require_relative '../models/build/job'
require_relative '../models/build/waste_calculator'
require_relative '../models/build/materials_calculator'
require_relative '../models/build/pricing_calculator'
require_relative '../models/build/blueprint_repository'
require_relative '../models/pricing/low_sell_orders_pricing_model'
require_relative '../models/pricing/composite_pricing_model'
require_relative '../models/pricing/persistent_pricing_model'
require_relative '../models/shopping/shopping_list'
require_relative '../presentation/console_serializer'

class ManufacturingReport

	def initialize
		dbconfig = YAML::load(File.open('./config/database.yml'))
		ActiveRecord::Base.establish_connection(dbconfig)

		# Create our pricing data.
		jita = PersistentPricingModel.new(LowSellOrdersPricingModel.new(MapSolarSystems.find_by_solarSystemName('Jita')))
		amarr = PersistentPricingModel.new(LowSellOrdersPricingModel.new(MapSolarSystems.find_by_solarSystemName('Amarr')))
		@markets = CompositePricingModel.new([jita, amarr])
		@pricing_calculator = PricingCalculator.new(@markets)

		# Create the objects needed to compute material costs.
		blueprint_repository = BlueprintRepository.new()
		waste_calculator = WasteCalculator.new(5, blueprint_repository)
		@materials_calculator = MaterialsCalculator.new(waste_calculator)

		# Create our presentation object
		@writer = ConsoleSerializer.new()
	end

	def run(build)
		build = build.
			accept(@materials_calculator).
			accept(@pricing_calculator).
			sort_by { |n| n.data[:profit_margin] }
		shopping_list = ShoppingList.new(@markets, build.data[:materials])

		@writer.write_build(build)
		@writer.write_shopping_list(shopping_list)
	end
end
