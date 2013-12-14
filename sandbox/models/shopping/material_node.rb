require_relative 'shopping_node'

class MaterialNode < ShoppingNode

	attr_accessor :quantity

	def initialize(market, item, quantity)
		@item = item
		@quantity = quantity
		super(item.typeName, market)
	end

	def compute_volume
		@volume = @item.packaged_volume * @quantity
	end

	def cost_per_unit
		@pricing.buy_price(@item)		
	end

	def compute_cost
		@cost = cost_per_unit * @quantity
	end
end