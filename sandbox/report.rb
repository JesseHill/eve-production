#!/usr/bin/ruby
require 'nokogiri'
require 'open-uri'
require 'active_record'
require 'yaml'
require_relative './models/build/build'
require_relative './models/build/market_stats'
require_relative './models/build/waste_calculator'
require_relative './models/build/blueprint_repository'
require_relative './models/pricing/low_sell_orders_pricing_model'
require_relative './models/pricing/composite_pricing_model'
require_relative './models/pricing/persistant_pricing_model'
require_relative './presentation/console_serializer'

# First build a pricing model for each of the systems we care about.
# We'll do better than these magic system and type id numbers in later posts. 
jita = LowSellOrdersPricingModel.new(QuickLookData.new(usesystem: 30000142))
amarr = LowSellOrdersPricingModel.new(QuickLookData.new(usesystem: 30002187))

# Next we'll build a model that gives us the composite data from those systems.
markets = CompositePricingModel.new([jita, amarr])
markets = CompositePricingModel.new([jita])

# Persist it so we don't wear out the eve-central server.
pricing = PersistantPricingModel.new(markets)

dbconfig = YAML::load(File.open('./config/database.yml'))
ActiveRecord::Base.establish_connection(dbconfig)

# stats = MarketStats.new

build = Build.new("Stuff")
blueprintRepo = BlueprintRepository.new()
wasteCalculator = WasteCalculator.new(5, blueprintRepo)

InvType.where(groupID: 334).
	each {|t| build.add(LineItem.new(t.typeID, 1000, wasteCalculator))}

# InvType.where(groupID: 25).
# 	joins(:inv_meta_group).
# 	where(invMetaGroups: {metaGroupID: 4}).
# 	limit(10).
# 	order("typeName").
# 	each {|t| puts t.typeName}

# items = InvBlueprintType.order("typeName").
# 	joins(:inv_type).
# 	where(invTypes: {groupID: [25, 324, 830, 831, 834, 893]}).
# 	where("invTypes.marketGroupID IS NOT NULL").
# 	where.not(invTypes: {marketGroupID: [1365, 1366, 1619, 1623]})
# items = InvBlueprintType.all
# items = items.select {|w| 
# 	metaGroup = w.inv_type.inv_meta_group
# 	(metaGroup.nil? || metaGroup.metaGroupID < 3) && 
# 		/(capital|siege)/.match(w.inv_type.typeName).nil? &&
# 		stats.sell_volume(w.productTypeID) > 50
# }
# items.each {|w|
# 	build.add(LineItem.new(w.productTypeID, 1, wasteCalculator))
# 	# puts w.inv_type.typeName
# }

# build.add(LineItem.new('Inferno Javelin Torpedo', 1, wasteCalculator))
# build.add(LineItem.new('Nanofiber Internal Structure II', 130, wasteCalculator))
# build.add(LineItem.new('250mm Railgun II', 290, wasteCalculator))
# build.add(LineItem.new('Sensor Booster II', 30, wasteCalculator))
# build.add(LineItem.new('Explosive Deflection Field II', 30, wasteCalculator))
# build.add(LineItem.new('425mm Railgun II', 1, wasteCalculator))
# build.add(LineItem.new('Damage Control II', 2	0, wasteCalculator))

# build.add(LineItem.new("Cap Recharger I", 10, wasteCalculator))
# build.add(LineItem.new("Nanoelectrical Microprocessor", 10, wasteCalculator))
# build.add(LineItem.new("Nanofiber Internal Structure I", 127, wasteCalculator))
# build.add(LineItem.new("Superconductor Rails", 740, wasteCalculator))
# build.add(LineItem.new("Shrapnel Bomb", 5, wasteCalculator))
# build.add(LineItem.new("Sensor Booster I", 30, wasteCalculator))
# build.add(LineItem.new("Gravimetric Sensor Cluster", 120, wasteCalculator))
# build.add(LineItem.new("Quantum Microprocessor", 73, wasteCalculator))
# build.add(LineItem.new("Explosive Deflection Field I", 16, wasteCalculator))
# build.add(LineItem.new("Deflection Shield Emitter", 1120, wasteCalculator))

# build.add(LineItem.new("250mm Railgun I", 61, wasteCalculator))
# build.add(LineItem.new("Explosive Deflection Field I", 30, wasteCalculator))
# build.add(LineItem.new("Deflection Shield Emitter", 480, wasteCalculator))
# build.add(LineItem.new("Thermic Dissipation Field II", 30, wasteCalculator))

# build.add(LineItem.new("Large Armor Repairer II", 100, wasteCalculator))
# build.add(LineItem.new("Medium Armor Repairer II", 270, wasteCalculator))
# build.add(LineItem.new("Co-Processor II", 50, wasteCalculator))
# build.add(LineItem.new("Expanded Cargohold II", 60, wasteCalculator))
# build.add(LineItem.new("Nanofiber Internal Structure II", 90, wasteCalculator))
# build.add(LineItem.new("EM Ward Field II", 40, wasteCalculator))
# build.add(LineItem.new("Explosive Deflection Field II", 20, wasteCalculator))
# build.add(LineItem.new("Kinetic Deflection Field II", 20, wasteCalculator))
# build.add(LineItem.new("Thermic Dissipation Field II", 10, wasteCalculator))
# build.add(LineItem.new("Damage Control I", 40, wasteCalculator))
# build.add(LineItem.new("250mm Railgun II", 390, wasteCalculator))
# build.add(LineItem.new("Sensor Booster I", 20, wasteCalculator))
# build.add(LineItem.new("Adaptive Invulnerability Field I", 10, wasteCalculator))
# build.add(LineItem.new("Thermic Dissipation Field I", 40, wasteCalculator))
# build.add(LineItem.new("100MN Microwarpdrive I", 11, wasteCalculator))

# build.add(LineItem.new("Nanoelectrical Microprocessor", 660, wasteCalculator))
# build.add(LineItem.new("Photon Microprocessor", 483, wasteCalculator))
# build.add(LineItem.new("Oscillator Capacitor Unit", 380, wasteCalculator))
# build.add(LineItem.new("Quantum Microprocessor", 100, wasteCalculator))
# build.add(LineItem.new("Superconductor Rails", 760, wasteCalculator))
# build.add(LineItem.new("Gravimetric Sensor Cluster", 80, wasteCalculator))
# build.add(LineItem.new("Deflection Shield Emitter", 100, wasteCalculator))
# build.add(LineItem.new("Linear Shield Emitter", 100, wasteCalculator))
# build.add(LineItem.new("Plasma Pulse Generator", 100, wasteCalculator))
# build.add(LineItem.new("Pulse Shield Emitter", 2000, wasteCalculator))

# build.add(LineItem.new("Esoteric Data Interface", 2, wasteCalculator))
# build.add(LineItem.new("Esoteric Tuner Data Interface", 1, wasteCalculator))
# build.add(LineItem.new("Occult Data Interface", 8, wasteCalculator))
# build.add(LineItem.new("Occult Ship Data Interface", 2, wasteCalculator))
# build.add(LineItem.new("Occult Tuner Data Interface", 2, wasteCalculator))
# build.add(LineItem.new("Medium Ancillary Armor Repairer", 10, wasteCalculator))
# build.add(LineItem.new("Small Ancillary Armor Repairer", 31, wasteCalculator))
# build.add(LineItem.new("Large Ancillary Shield Booster", 6, wasteCalculator))
# build.add(LineItem.new("Medium Ancillary Shield Booster", 38, wasteCalculator))
# build.add(LineItem.new("Small Ancillary Shield Booster", 3, wasteCalculator))
# build.add(LineItem.new("X-Large Ancillary Shield Booster", 25, wasteCalculator))
# build.add(LineItem.new("Medium Hydraulic Bay Thrusters II", 2, wasteCalculator))
# build.add(LineItem.new("Ashimmu", 1, wasteCalculator))
# build.add(LineItem.new("Worm", 2, wasteCalculator))
# build.add(LineItem.new("Stabber Fleet Issue", 3, wasteCalculator))
# build.add(LineItem.new("Capital Anti-EM Screen Reinforcer II", 2, wasteCalculator))

# build.add(LineItem.new("Medium Armor Repairer I", 370, wasteCalculator))
# build.add(LineItem.new("Co-Processor I", 130, wasteCalculator))
# build.add(LineItem.new("Nanofiber Internal Structure I", 40, wasteCalculator))
# build.add(LineItem.new("EM Ward Field I", 40, wasteCalculator))
# build.add(LineItem.new("Explosive Deflection Field I", 20, wasteCalculator))
# build.add(LineItem.new("Kinetic Deflection Field I", 50, wasteCalculator))

# build.add(LineItem.new("Nanoelectrical Microprocessor", 740, wasteCalculator))
# build.add(LineItem.new("Photon Microprocessor", 390, wasteCalculator))
# build.add(LineItem.new("Oscillator Capacitor Unit", 260, wasteCalculator))
# build.add(LineItem.new("Linear Shield Emitter", 640, wasteCalculator))
# build.add(LineItem.new("Deflection Shield Emitter", 320, wasteCalculator))
# build.add(LineItem.new("Sustained Shield Emitter", 800, wasteCalculator))
# build.add(LineItem.new("Thermic Dissipation Field I", 30, wasteCalculator))
# build.add(LineItem.new("Pulse Shield Emitter", 480, wasteCalculator))
#build.add(LineItem.new("100MN Microwarpdrive II", 1, wasteCalculator))

# item = LineItem.new('Skiff', 1, wasteCalculator)
# puts "-" * 50
# puts "Shopping list"
# puts "-" * 50
# item.materials.each {|typeID, quantity|
# 	type = InvType.find_by_typeID(typeID)
# 	puts "\t #{quantity} #{type.typeName}"
# }

# build.add(LineItem.new("Drake", 4, wasteCalculator))
# build.add(LineItem.new("Rokh", 2, wasteCalculator))

# build.add(LineItem.new("Retribution", 1, wasteCalculator))
# build.add(LineItem.new("Vengeance", 1, wasteCalculator))

# build.add(LineItem.new("Crusader", 1, wasteCalculator))
# build.add(LineItem.new("Malediction", 1, wasteCalculator))

# build.add(LineItem.new("Reactive Armor Hardener", 76, wasteCalculator))
# build.add(LineItem.new("Medium Ancillary Armor Repairer", 3, wasteCalculator))
# build.add(LineItem.new("Small Ancillary Armor Repairer", 10, wasteCalculator))
# build.add(LineItem.new("Medium Ancillary Shield Booster", 60, wasteCalculator))
# build.add(LineItem.new("Small Ancillary Shield Booster", 19, wasteCalculator))
# build.add(LineItem.new("X-Large Ancillary Shield Booster", 2, wasteCalculator))
# # # build.add(LineItem.new("Large Micro Jump Drive", 16, wasteCalculator))
# build.add(LineItem.new("Medium Emission Scope Sharpener II", 2, wasteCalculator))
# # # build.add(LineItem.new("Target Spectrum Breaker", 41, wasteCalculator))
# build.add(LineItem.new("Occult Data Interface", 31, wasteCalculator))
# build.add(LineItem.new("Occult Ship Data Interface", 4, wasteCalculator))
# build.add(LineItem.new("Occult Tuner Data Interface", 11, wasteCalculator))

# build.add(LineItem.new("Sentinel", 15, wasteCalculator))

# build.add(LineItem.new("Fusion Thruster", 420, wasteCalculator))
# build.add(LineItem.new("Radar Sensor Cluster", 1050, wasteCalculator))
# build.add(LineItem.new("Nanoelectrical Microprocessor", 2100, wasteCalculator))
# build.add(LineItem.new("Tungsten Carbide Armor Plate", 5250, wasteCalculator))
# build.add(LineItem.new("Antimatter Reactor Unit", 45, wasteCalculator))
# build.add(LineItem.new("Tesseract Capacitor Unit", 1050, wasteCalculator))
# build.add(LineItem.new("Linear Shield Emitter", 210, wasteCalculator))


# build.add(LineItem.new("Large Armor Repairer I", 100, wasteCalculator))
# build.add(LineItem.new("Medium Armor Repairer I", 270, wasteCalculator))
# build.add(LineItem.new("Expanded Cargohold I", 60, wasteCalculator))
# build.add(LineItem.new("250mm Railgun I", 390, wasteCalculator))
# build.add(LineItem.new("Kinetic Deflection Field I", 20, wasteCalculator))
# build.add(LineItem.new("Thermic Dissipation Field I", 10, wasteCalculator))
# build.add(LineItem.new("Nanofiber Internal Structure I", 90, wasteCalculator))
# build.add(LineItem.new("Explosive Deflection Field I", 20, wasteCalculator))
# build.add(LineItem.new("Nanoelectrical Microprocessor", 940, wasteCalculator))
# build.add(LineItem.new("Photon Microprocessor", 150, wasteCalculator))
# build.add(LineItem.new("Oscillator Capacitor Unit", 100, wasteCalculator))
# build.add(LineItem.new("Nanomechanical Microprocessor", 60, wasteCalculator))
# build.add(LineItem.new("Crystalline Carbonide Armor Plate", 60, wasteCalculator))
# build.add(LineItem.new("Deflection Shield Emitter", 320, wasteCalculator))
# build.add(LineItem.new("Sustained Shield Emitter", 320, wasteCalculator))
# build.add(LineItem.new("Pulse Shield Emitter", 160, wasteCalculator))
# build.add(LineItem.new("Superconductor Rails", 4680, wasteCalculator))


# build.add(LineItem.new("Crusader", 3, wasteCalculator))
# build.add(LineItem.new("Malediction", 18, wasteCalculator))
# build.add(LineItem.new("Purifier", 1, wasteCalculator))
# build.add(LineItem.new("Retribution", 9, wasteCalculator))
# build.add(LineItem.new("Sentinel", 12, wasteCalculator))
# build.add(LineItem.new("Expanded Cargohold II", 30, wasteCalculator))
# build.add(LineItem.new("Nanofiber Internal Structure II", 100, wasteCalculator))
# build.add(LineItem.new("250mm Railgun II", 40, wasteCalculator))
# build.add(LineItem.new("Sensor Booster II", 190, wasteCalculator))
# build.add(LineItem.new("Warp Disruptor II", 130, wasteCalculator))

# build.add(LineItem.new("Executioner", 16, wasteCalculator))
# build.add(LineItem.new("Inquisitor", 9, wasteCalculator))
# build.add(LineItem.new("Fusion Thruster", 1659, wasteCalculator))
# build.add(LineItem.new("Radar Sensor Cluster", 2184, wasteCalculator))
# build.add(LineItem.new("Nanoelectrical Microprocessor", 6678, wasteCalculator))
# build.add(LineItem.new("Tungsten Carbide Armor Plate", 23100, wasteCalculator))
# build.add(LineItem.new("Antimatter Reactor Unit", 37, wasteCalculator))
# build.add(LineItem.new("Tesseract Capacitor Unit", 3570, wasteCalculator))
# build.add(LineItem.new("Linear Shield Emitter", 987, wasteCalculator))
# build.add(LineItem.new("Nanomechanical Microprocessor", 30, wasteCalculator))
# build.add(LineItem.new("Superconductor Rails", 480, wasteCalculator))
# build.add(LineItem.new("Gravimetric Sensor Cluster", 1280, wasteCalculator))
# build.add(LineItem.new("Quantum Microprocessor", 960, wasteCalculator))

# build.add(LineItem.new("Fusion Thruster", 100, wasteCalculator))
# build.add(LineItem.new("Radar Sensor Cluster", 100, wasteCalculator))
# build.add(LineItem.new("Nanoelectrical Microprocessor", 100, wasteCalculator))
# build.add(LineItem.new("Tungsten Carbide Armor Plate", 100, wasteCalculator))
# build.add(LineItem.new("Antimatter Reactor Unit", 100, wasteCalculator))
# build.add(LineItem.new("Tesseract Capacitor Unit", 100, wasteCalculator))
# build.add(LineItem.new("Linear Shield Emitter", 100, wasteCalculator))
# build.add(LineItem.new("Nanomechanical Microprocessor", 100, wasteCalculator))
# build.add(LineItem.new("Superconductor Rails", 100, wasteCalculator))
# build.add(LineItem.new("Ion Thruster", 276, wasteCalculator))
# build.add(LineItem.new("Magnetometric Sensor Cluster", 2376, wasteCalculator))
# build.add(LineItem.new("Photon Microprocessor", 8640, wasteCalculator))
# build.add(LineItem.new("Crystalline Carbonide Armor Plate", 18000, wasteCalculator))
# build.add(LineItem.new("Fusion Reactor Unit", 144, wasteCalculator))
# build.add(LineItem.new("Oscillator Capacitor Unit", 1800, wasteCalculator))
# build.add(LineItem.new("Pulse Shield Emitter", 1440, wasteCalculator))
# build.add(LineItem.new("Gravimetric Sensor Cluster", 2160, wasteCalculator))
# build.add(LineItem.new("Quantum Microprocessor", 1620, wasteCalculator))

report = BuildReport.new(build, pricing)
ConsoleSerializer.new(report).write()