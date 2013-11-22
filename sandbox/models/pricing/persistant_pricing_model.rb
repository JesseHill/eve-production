require 'moneta'

class PersistantPricingModel

	def initialize(model, basePath = './data/pricing/default', expiration = 1000 * 60 * 60 * 24)
		@model = model
		@buy_prices = Moneta.new(:PStore, :file => basePath + "_buy.pstore", :expires => true)
		@sell_prices = Moneta.new(:PStore, :file => basePath + "_sell.pstore", :expires => true)
		@expiration = expiration
	end

	def buy_price(id)
		return @buy_prices[id] if @buy_prices.key?(id)
		price = @model.buy_price(id)
		@buy_prices.store(id, price, :expires => @expiration)
		price
	end	

	def sell_price(id)
		return @sell_prices[id] if @sell_prices.key?(id)
		price = @model.sell_price(id)
		@sell_prices.store(id, price, :expires => @expiration)
		price
	end	
end