

class MarketableVolumeCalculator

	def initialize(history)
		@history = history
		@marketable_percentage = 0.1
	end

	def visit(node)
		if node.is_buildable?
			node.data[:marketable_volume_per_day] = @history.volume(node.item) * @marketable_percentage
			node.data[:marketable_profit_per_day] = (@history.average_price(node.item) - node.data[:cost_per_unit]) * node.data[:marketable_volume_per_day]
			node.data[:marketable_hourly_profit] = node.data[:marketable_profit_per_day] / 24
		end
	end	
end