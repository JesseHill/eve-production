class InventionCostCalculator

	def initialize(pricing, calculator, strategy)
		@pricing = pricing
		@calculator = calculator
		@strategy = strategy
	end

	def materials(item, options = {})
		return {} unless item.is_techII?
		materials = item.ram_type_requirements_for_invention
			.select { |r| r.required_type.in_market_group?(:datacores) }
			.each_with_object({}) { |r, h| h[r.required_type] = r.quantity }

		decryptor = @strategy.decryptor(item, options)
		materials[decryptor] = 1 if decryptor

		techI_item = @strategy.techI_item(item, options)
		materials[techI_item] = 1 if techI_item

		materials
	end

	def cost(item, options = {})
		return 0 unless item.is_techII?
		materials(item, options).inject(0) { |memo,(i,q)| memo + @pricing.buy_price(i) * q }
	end

	def cost_per_run(item, options = {})
		return 0 unless item.is_techII?
		cost(item, options) / @calculator.chance(item, options) / @calculator.runs(item, options)
	end

	def visit(node)
		if node.is_buildable?
			node.data[:invention_materials] = materials(node.item, node.options)
			node.data[:invention_cost] = node.runs * cost_per_run(node.item, node.options)
		else
			node.data[:invention_cost] = node.children.reduce(0) do |memo, node| 
				memo + node.data[:invention_cost]
			end
		end
	end		
end