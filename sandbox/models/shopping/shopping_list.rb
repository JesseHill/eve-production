require_relative 'shopping_node'
require_relative 'market_node'

class ShoppingList < ShoppingNode

	def initialize(markets, materials, type = :buy)
		groups = type == :buy ?
			markets.group_by_buy_price(materials) :
			markets.group_by_sell_price(materials)
		@children =	groups.map { |market, materials_for_market| MarketNode.new(market, materials_for_market) }
		super(type == :buy ? "Shopping List" : "Retail List", markets)
	end

end