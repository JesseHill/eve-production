class CompositePricingModel

	def initialize(models = [])
		@models = models
	end

	def buy_price(id)
		return 0 if @models.empty?
		@models.collect { |m| m.buy_price(id) }.min
	end	

	def sell_price(id)
		return 0 if @models.empty?
		@models.collect { |m| m.sell_price(id) }.max
	end	

	def group_by_buy_price(materials)
		Hash.new { |hash, key| hash[key] = Hash.new(0) }.tap { |groups|
			materials.each { |material, quantity|
				best_market = @models.min_by { |model| model.buy_price(material.typeID) }
				groups[best_market][material] += quantity
			}
		}	
	end
end