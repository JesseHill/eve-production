require 'nokogiri'

class LowSellOrdersPricingModel

	def initialize(dataSource)
		@dataSource = dataSource
		@prices = {}
	end

	def price(id)
		return @prices[id] if @prices.has_key?(id)
		marketData = Nokogiri::XML(@dataSource.data(:typeid => id))
		prices = marketData.css("sell_orders order price").
			collect {|n| n.content.to_f}.
			sort.
			take(5)
		price = prices.size > 0 ?
			prices.inject(0.0) {|sum, el| sum + el} / prices.size :
			0
		@prices[id] = price
		price
	end

	def buy_price(id)
		price(id)
	end	

	def sell_price(id)
		price(id)
	end	
end