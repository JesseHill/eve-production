require_relative 'shopping_node'
require_relative 'market_node'

class ShoppingList < ShoppingNode

	def initialize(markets, materials)
		@children = markets.group_by_buy_price(materials).map { |market, materials_for_market|
			MarketNode.new(market, materials_for_market)
		}	

		super("Shopping List", markets)
	end

end