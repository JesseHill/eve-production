require_relative '../models/build/recyclable_materials_calculator'
require_relative '../models/build/reprocessing_calculator'
require_relative '../models/pricing/reprocessing_pricing_model'
require_relative '../presentation/console_serializer'

class ReprocessingReport

	def initialize
		@pricing_calculator = ReprocessingCalculator.new(ReprocessingPricingModel.new().pricing)
		@recyclable_materials_calculator = RecyclableMaterialsCalculator.new()
		@writer = ConsoleSerializer.new()
	end

	def run(build, options = {})
		build = build
			.accept(@recyclable_materials_calculator)
			.accept(@pricing_calculator)
		@writer.write_reprocessing_data(build)
	end
end
