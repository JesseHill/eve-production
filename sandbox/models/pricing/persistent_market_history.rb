require 'moneta'

require_relative '../database/inv_type'

class PersistentMarketHistory

	def initialize(model, basePath = './data/pricing/history/default', expiration = 1000 * 60 * 60 * 24)
		@model = model
		@volume = Moneta.new(:PStore, :file => "#{basePath}_#{model.name}_volume.pstore", :expires => true)
		@average_prices = Moneta.new(:PStore, :file => "#{basePath}_#{model.name}_avg.pstore", :expires => true)
		@expiration = expiration
	end

	def volume(id)
		id = id.typeID if id.is_a? InvType
		return @volume[id] if @volume.key?(id)
		price = @model.volume(id)
		@volume.store(id, price, :expires => @expiration)
		price
	end	

	def average_price(id)
		id = id.typeID if id.is_a? InvType
		return @average_prices[id] if @average_prices.key?(id)
		price = @model.average_price(id)
		@average_prices.store(id, price, :expires => @expiration)
		price
	end	

	def name
		@model.name
	end
end