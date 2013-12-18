

class ProductionTimeCalculator

	def initialize(blueprint_repository, production_info)
		@blueprint_repository = blueprint_repository
		@production_info = production_info
	end

	def visit(node)
		node.data[:production_time] = node.is_buildable? ?
			calculate(node.blueprint, node.runs, node.options) :
			node.children.inject(0) { |memo, n| memo + n[:production_time] }
	end

	def calculate(blueprint, runs, options = {})
		productivity_level = options[:productivity_level] || 
			@blueprint_repository.productivity_level(blueprint)

		productivity_level_modifier = productivity_level >= 0 ?
			productivity_level.to_f / (1 + productivity_level) :
			productivity_level - 1

		(runs *
			blueprint.productionTime *
			(1 - 
				blueprint.productivityModifier.to_f / blueprint.productionTime * 
				productivity_level_modifier) *
			(1 - 0.04 * @production_info.industry_skill) *
			@production_info.implant_modifier *
			@production_info.production_slot_modifier).round
	end
end
