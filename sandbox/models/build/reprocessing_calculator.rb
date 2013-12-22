class ReprocessingCalculator

	def initialize(market_data)
		@market_data = market_data
	end

	def visit(node)
		# Costs
		if node.is_buildable?
			node.data[:reprocessing_cost_per_unit] = @market_data.buy_price(node)	
			node.data[:reprocessing_cost] = node.runs * node.data[:reprocessing_cost_per_unit]
		else
			node.data[:reprocessing_cost] = node.children.reduce(0) do |memo, node| 
				memo += node.data[:reprocessing_cost] 
			end
		end

		# Value
		node.data[:reprocessing_value] = node.data[:recyclable_materials]
			.reduce(0) do |memo, (material, quantity)|
				memo + @market_data.sell_price(material) * quantity * node.runs
			end

		# Profit
		node.data[:reprocessing_profit] = node.data[:reprocessing_value] - node.data[:reprocessing_cost]
		node.data[:reprocessing_profit_margin] = node.data[:reprocessing_cost] > 0 ?
			node.data[:reprocessing_value] / node.data[:reprocessing_cost] - 1 :
			1
	end	

end	