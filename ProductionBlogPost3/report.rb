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
require_relative './presentation/console_serializer'

dbconfig = YAML::load(File.open('./config/database.yml'))
ActiveRecord::Base.establish_connection(dbconfig)

jita = PersistentPricingModel.new(LowSellOrdersPricingModel.new(MapSolarSystems.find_by_solarSystemName('Jita')))
amarr = PersistentPricingModel.new(LowSellOrdersPricingModel.new(MapSolarSystems.find_by_solarSystemName('Amarr')))
markets = CompositePricingModel.new([jita, amarr])

blueprint_repository = BlueprintRepository.new()
waste_calculator = WasteCalculator.new(5, blueprint_repository)
materials_calculator = MaterialsCalculator.new(waste_calculator)
pricing_calculator = PricingCalculator.new(markets)

jobs = [
	["250mm Railgun II", 100],
	["Warp Scrambler II", 100],
	["Expanded Cargohold II", 100]
].map { |name,count| Job.new(name, count) }

build = Build.new("Initial Build", 1, jobs).
	accept(materials_calculator).
	accept(pricing_calculator)

ConsoleSerializer.new(build).write()