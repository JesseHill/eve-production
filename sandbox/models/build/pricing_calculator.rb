class PricingCalculator

	def initialize(market_data)
		@market_data = market_data
	end

	def visit(node)
		compute_costs(node)
		compute_value(node)
		compute_profit(node)
	end		

	def compute_costs(node)
		node.data[:material_costs] = node.data[:materials].each_with_object({}) do |(m, q), h|
			price = @market_data.buy_price(m.typeID)
			h[m] = { per_unit: price, total: price * q }
		end
		node.data[:material_cost] = node.data[:material_costs].values.reduce(0) do |memo, costs|
			memo += costs[:total]
		end
		node.data[:cost] = node.data[:material_cost] + (node.data[:invention_cost] || 0)
		node.data[:cost_per_unit] = node.data[:cost] / node.runs / node.item.portionSize if node.is_buildable?
	end

	def compute_value(node)
		if node.is_buildable?
			node.data[:value_per_unit] = @market_data.sell_price(node.typeID)	
			node.data[:value] = node.runs * node.data[:value_per_unit] * node.portionSize
		else
			node.data[:value] = node.children.reduce(0) { |memo, node| memo += node.data[:value] }	* node.runs
		end
	end

	def compute_profit(node)
		node.data[:profit] = node.data[:value] - node.data[:cost]
		node.data[:profit_per_unit] = node.data[:profit] / node.runs / node.portionSize if node.is_buildable?
		node.data[:profit_margin] = node.data[:cost] > 0 ? node.data[:profit] / node.data[:cost] : 1
	end	

end	