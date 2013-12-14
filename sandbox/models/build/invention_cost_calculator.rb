class InventionCostCalculator

	def initialize(pricing, calculator, strategy)
		@pricing = pricing
		@calculator = calculator
		@strategy = strategy
	end

	def cost(item)
		ram_requirements_cost = item.ram_type_requirements_for_invention.
			select { |r| r.required_type.in_market_group?(:datacores) }.
			inject(0) { |memo, r| 
				memo + (@pricing.buy_price(r.required_type) * r.quantity) }

		decryptor = @strategy.decryptor(item)
		decryptor_cost = decryptor.nil? ? 0 : @pricing.buy_price(decryptor) 

		techI_item = @strategy.techI_item(item)
		techI_item_cost = techI_item.nil? ? 0 : @pricing.buy_price(techI_item)
		
		ram_requirements_cost + decryptor_cost + techI_item_cost
	end

	def cost_per_run(item)
		cost(item) / @calculator.chance(item) / @calculator.runs(item)
	end

	def visit(node)
		if node.is_buildable?
			node.data[:invention_cost] = node.runs * cost_per_run(node.item)
		else
			node.data[:invention_cost] = node.children.reduce(0) do |memo, node| 
				memo + node.data[:invention_cost]
			end
		end
	end		
end