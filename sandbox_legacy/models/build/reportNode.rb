class ReportNode
	
	def initialize(name, quantity = 1)
		@name = name
		@items = []
		@cost = 0
		@value = 0
		@productionTime = 0
		@materials = Hash.new(0)
		@quantity = quantity
	end

	def name
		@name
	end

	def quantity
		@quantity
	end

	def items
		@items
	end

	def materials
		@materials
	end

	def productionTime
		@productionTime
	end

	def cost
		@cost.is_a?(Numeric) ? @cost : 0
	end

	def value
		@value.is_a?(Numeric) ? @value : 0
	end

	def profit
		value - cost
	end

	def profit_per_production_time
		return profit / productionTime if productionTime > 0
		puts "#{name} somehow had no productionTime" 
		profit
	end

	def profit_margin
		((value.to_d / cost - 1) * 100).round(2)
	end
end