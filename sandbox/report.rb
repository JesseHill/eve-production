#!/usr/bin/ruby
require 'nokogiri'
require 'open-uri'
require 'active_record'
require 'yaml'

require_relative './models/database/map_solar_systems'
require_relative './models/build/build'
require_relative './models/build/job'
require_relative './models/build/waste_calculator'
require_relative './models/build/materials_calculator'
require_relative './models/build/pricing_calculator'
require_relative './models/build/blueprint_repository'
require_relative './models/pricing/low_sell_orders_pricing_model'
require_relative './models/pricing/composite_pricing_model'
require_relative './models/pricing/persistent_pricing_model'
require_relative './models/shopping/shopping_list'
require_relative './presentation/console_serializer'

dbconfig = YAML::load(File.open('./config/database.yml'))
ActiveRecord::Base.establish_connection(dbconfig)

# Create our pricing data.
jita = PersistentPricingModel.new(LowSellOrdersPricingModel.new(MapSolarSystems.find_by_solarSystemName('Jita')))
amarr = PersistentPricingModel.new(LowSellOrdersPricingModel.new(MapSolarSystems.find_by_solarSystemName('Amarr')))
markets = CompositePricingModel.new([jita, amarr])
pricing_calculator = PricingCalculator.new(markets)

# Create the object needed to compute material costs.
blueprint_repository = BlueprintRepository.new()
waste_calculator = WasteCalculator.new(5, blueprint_repository)
materials_calculator = MaterialsCalculator.new(waste_calculator)

# Set up our list of jobs
jobs = [
	["Warp Scrambler II", 100],
	["Expanded Cargohold II", 100],
	["Arazu", 2],
].map { |name, count| Job.new(name, count) }

# Run our visitors to generate our build data.
build = Build.new("Overall Build", 1, jobs).
	accept(materials_calculator).
	accept(pricing_calculator)

# Print out what we've found.
ConsoleSerializer.new(build, markets).write()

# items = { 
# 	InvType.find_by_typeName("Tritanium") => 1000,
# 	InvType.find_by_typeName("Morphite") => 100,
# 	InvType.find_by_typeName("Construction Blocks") => 500,
# 	InvType.find_by_typeName("Guidance Systems") => 500,
# 	InvType.find_by_typeName("Hypersynaptic Fibers") => 500,
# 	InvType.find_by_typeName("Ferrogel") => 500,
# 	InvType.find_by_typeName("250mm Railgun I") => 500,
# }

# shopping_list = ShoppingList.new(items, markets)
# shopping_list.by_market_and_group.each { |market, groups|
# 	puts "-" * 10
# 	puts market.name
# 	groups.each { |group, materials|
# 		puts "\t #{group.marketGroupName}"
# 		materials.each { |m, q|
# 			puts "\t\t #{m.typeName} - #{q} - #{market.buy_price(m.typeID)}"
# 		}
# 	}
# }