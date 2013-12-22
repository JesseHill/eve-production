require_relative 'shopping_node'
require_relative 'material_node'

class GroupNode < ShoppingNode

	def initialize(market, group, materials)
		@children = materials.map { |item, quantity| MaterialNode.new(market, item, quantity) }
		super(group.marketGroupName, market)
	end

end