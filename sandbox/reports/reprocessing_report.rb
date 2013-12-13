require_relative '../models/build/recyclable_materials_calculator'
require_relative '../models/build/reprocessing_calculator'
require_relative '../models/pricing/reprocessing_pricing_model'
require_relative '../presentation/console_serializer'

class ReprocessingReport

	def initialize
		# Create our pricing data.
		@pricing_calculator = ReprocessingCalculator.new(ReprocessingPricingModel.new().pricing)

		# Create the objects needed to compute recyclable materials.
		@recyclable_materials_calculator = RecyclableMaterialsCalculator.new()

		# Create our presentation object
		@writer = ConsoleSerializer.new()
	end

	def run(build, options = {})
		build = build.
			accept(@recyclable_materials_calculator).
			accept(@pricing_calculator)

		@writer.write_reprocessing_data(build)
	end
end
