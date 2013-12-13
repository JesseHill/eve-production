require_relative '../models/build/waste_calculator'
require_relative '../models/build/materials_calculator'
require_relative '../models/build/blueprint_repository'
require_relative '../models/build/pricing_calculator'
require_relative '../models/pricing/default_pricing_model'
require_relative '../models/shopping/shopping_list'
require_relative '../presentation/console_serializer'

class ManufacturingReport

	def initialize
		# Create our pricing data.
		@pricing_calculator = PricingCalculator.new(DefaultPricingModel.new().pricing)


		# Create the objects needed to compute material costs.
		blueprint_repository = BlueprintRepository.new()
		waste_calculator = WasteCalculator.new(5, blueprint_repository)
		@materials_calculator = MaterialsCalculator.new(waste_calculator)

		# Create our presentation object
		@writer = ConsoleSerializer.new()
	end

	def run(build, options = {})
		build = build.
			accept(@materials_calculator).
			accept(@pricing_calculator).
			sort_by { |n| n.data[:profit_margin] }

		@writer.write_build(build)

		if options[:print_shopping_list]
			shopping_list = ShoppingList.new(@markets, build.data[:materials])
			@writer.write_shopping_list(shopping_list)
		end
	end
end
