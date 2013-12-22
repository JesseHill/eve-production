require_relative '../models/build/waste_calculator'
require_relative '../models/build/materials_calculator'
require_relative '../models/build/production_time_calculator'
require_relative '../models/build/production_information'
require_relative '../models/build/blueprint_repository'
require_relative '../models/build/decryptor_repository'
require_relative '../models/build/decryptor_strategy'
require_relative '../models/build/invention_strategy'
require_relative '../models/build/invention_probability_calculator'
require_relative '../models/build/invention_cost_calculator'
require_relative '../models/build/pricing_calculator'
require_relative '../models/build/marketable_volume_calculator'
require_relative '../models/pricing/default_pricing_model'
require_relative '../models/pricing/default_market_history'
require_relative '../models/shopping/shopping_list'
require_relative '../presentation/console_serializer'

class ManufacturingReport

	def initialize
		@pricing = DefaultPricingModel.new.pricing
		@pricing_calculator = PricingCalculator.new(@pricing)
		@marketable_volume = MarketableVolumeCalculator.new(DefaultMarketHistory.new)

		decryptor_repository = DecryptorRepository.new
		decryptor_strategy = DecryptorStrategy.new(decryptor_repository)

		blueprint_repository = BlueprintRepository.new(decryptor_repository, decryptor_strategy)
		waste_calculator = WasteCalculator.new(5, blueprint_repository)
		@materials_calculator = MaterialsCalculator.new(waste_calculator)

		invention_strategy = InventionStrategy.new(decryptor_strategy)
		probability_calculator = InventionProbabilityCalculator.new(invention_strategy, decryptor_repository)
		@invention_calculator = InventionCostCalculator.new(@pricing, probability_calculator, invention_strategy)

		@production_time_calculator = ProductionTimeCalculator.new(blueprint_repository, ProductionInformation.new)

		@writer = ConsoleSerializer.new()
	end

	def run(build, options = {})
		build = build
			.accept(@materials_calculator)
			.accept(@invention_calculator)
			.accept(@pricing_calculator)
			.accept(@production_time_calculator)
			.accept@marketable_volume

		@writer.write_build(build)

		if options[:print_shopping_list]
			shopping_list = ShoppingList.new(@pricing, build.data[:materials])
			@writer.write_shopping_list(shopping_list)
		end
	end

end