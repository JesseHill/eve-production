require './models/build/reportNode.rb'
require './models/build/lineItemReport.rb'

class BuildReport < ReportNode

	def initialize(buildNode, pricingModel)
		super(buildNode.name, buildNode.quantity)
		@buildNode = buildNode
		@pricingModel = pricingModel
		populate_node()
	end

	def populate_node()
		@buildNode.items.each {|r|
			node = create_node(r)
			@items << node
			@cost += node.cost
			@value += node.value
			@productionTime += node.productionTime
			add_materials(node)
		}
		@items = @items.sort_by {|item| item.profit_margin }
	end

	def pricing_model
		@pricingModel
	end

	def create_node(item)
		if item.is_a? LineItem
			node = LineItemReport.new(item, @pricingModel)
		else
			node = BuildReport.new(item, @pricingModel)
		end
	end

	def add_materials(item)
		item.materials.each {|typeID,quantity|
			@materials[typeID] += quantity
		}
	end

end