require_relative 'shopping_node'
require_relative 'group_node'

class MarketNode < ShoppingNode

	@@selected_groups = ['Minerals', 'Construction Components', 'Planetary Materials']

	def initialize(market, materials)
		@children = materials
			.group_by { |m, _| group(m.inv_market_group) }
			.map { |group, materials_for_group| GroupNode.new(market, group, materials_for_group) }
		super(market.name, market)
	end

	def group(market_group)
		return market_group if @@selected_groups.include? market_group.marketGroupName
		market_group.parent_group.nil? ? market_group : group(market_group.parent_group)
	end

	def sort_children
		@children = @children.sort do |a, b| 
			a_index = @@selected_groups.index(a.name) || @@selected_groups.length
			b_index = @@selected_groups.index(b.name) || @@selected_groups.length
			a_index <=> b_index
		end
	end
end