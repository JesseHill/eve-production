require 'moneta'

require_relative '../database/inv_type'

class PersistentPricingModel

	def initialize(model, basePath = './data/pricing/default', expiration = 1 * 60 * 60 * 24)
		@model = model
		@buy_prices = Moneta.new(:PStore, :file => "#{basePath}_#{model.name}_buy.pstore", :expires => true)
		@sell_prices = Moneta.new(:PStore, :file => "#{basePath}_#{model.name}_sell.pstore", :expires => true)
		@expiration = expiration
	end

	def buy_price(id)
		id = id.typeID if id.is_a? InvType
		return @buy_prices[id] if @buy_prices.key?(id)
		price = @model.buy_price(id)
		@buy_prices.store(id, price, :expires => @expiration)
		price
	end	

	def sell_price(id)
		id = id.typeID if id.is_a? InvType
		return @sell_prices[id] if @sell_prices.key?(id)
		price = @model.sell_price(id)
		@sell_prices.store(id, price, :expires => @expiration)
		price
	end	

	def name
		@model.name
	end
end