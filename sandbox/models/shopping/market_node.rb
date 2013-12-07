require_relative 'shopping_node'
require_relative 'group_node'

class MarketNode  < ShoppingNode

	def initialize(market, materials)
		@selected_groups = ['Minerals', 'Construction Components', 'Planetary Materials']

		@children = materials.group_by { |m, _| group(m.inv_market_group) }.map { |group, materials_for_group|
			GroupNode.new(market, group, materials_for_group)
		}
		super(market.name, market)
	end

	def group(market_group)
		return market_group if @selected_groups.include?(market_group.marketGroupName)
		market_group.parent_group.nil? ? market_group : group(market_group.parent_group)
	end
end