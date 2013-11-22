require './models/build/reportNode.rb'
require './models/build/lineItem.rb'

class LineItemReport < ReportNode

	def initialize(lineItem, pricingModel)
		@lineItem = lineItem
		@pricingModel = pricingModel
		@name = lineItem.name

		@materials = @lineItem.materials
		@cost = @materials.inject(0) {|sum,typeIDQuantity|
			sum + typeIDQuantity[1] * @pricingModel.buy_price(typeIDQuantity[0]) 
		}
		@value = @pricingModel.sell_price(@lineItem.typeID) * lineItem.quantity * lineItem.portionSize
		@productionTime = lineItem.productionTime
	end

	def quantity
		@lineItem.quantity
	end

	def value_per_unit
		@pricingModel.sell_price(@lineItem.typeID)
	end
end