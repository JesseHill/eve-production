require_relative 'node_view'
require_relative 'requirement_view'

class JobView < NodeView	

	def has_invention_cost?
		@node.data[:invention_cost] > 0
	end

	def material_cost 
		format_isk(@node.data[:material_cost])
	end

	def invention_cost 
		format_isk(@node.data[:invention_cost])
	end

	def cost_per_unit
		format_isk(@node.data[:cost_per_unit])
	end

	def value_per_unit
		format_isk(@node.data[:value_per_unit])
	end

	def profit_per_unit
		format_isk(@node.data[:profit_per_unit])
	end

	def has_marketing_stats?
		@node.data[:marketable_volume_per_day] > 0
	end

	def marketable_volume_per_day
		format_quantity(@node.data[:marketable_volume_per_day])
	end

	def marketable_profit_per_day
		format_isk(@node.data[:marketable_profit_per_day])
	end

	def marketable_hourly_profit
		format_isk(@node.data[:marketable_hourly_profit])
	end

	def print_materials?
		@options[:print_materials]
	end

	def materials
	    costs = @node.data[:material_costs]
		@node.data[:materials].map { |m,q| RequirementView.new(@options, q, m.typeName, costs[m]) }
	end
end