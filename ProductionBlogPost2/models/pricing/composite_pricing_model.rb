class CompositePricingModel

	def initialize(models = [])
		@models = models
	end

	def buy_price(id)
		return 0 if @models.empty?
		@models.collect {|m| m.buy_price(id)}.min
	end	

	def sell_price(id)
		return 0 if @models.empty?
		@models.collect {|m| m.sell_price(id)}.max
	end	
end