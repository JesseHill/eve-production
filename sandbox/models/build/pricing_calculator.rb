class PricingCalculator

	def initialize(market_data)
		@market_data = market_data
	end

	def visit(node)
		# Costs
		node.data[:material_costs] = node.data[:materials].each_with_object({}) { |(m, q), h|
			price = @market_data.buy_price(m.typeID)
			h[m] = { per_unit: price, total: price * q }
		}
		node.data[:material_cost] = node.data[:material_costs].values.reduce(0) { |memo, costs|
			memo += costs[:total]
		}

		# Value	
		if node.is_buildable?
			node.data[:value_per_unit] = @market_data.sell_price(node.typeID)	
			node.data[:value] = node.runs * node.data[:value_per_unit]
		else
			node.data[:value] = node.children.reduce(0) { |memo, node| memo += node.data[:value] }	
		end

		# Profit
		node.data[:profit] = node.data[:value] - node.data[:material_cost]
		node.data[:profit_margin] = node.data[:profit] / node.data[:material_cost] 
	end	

end	