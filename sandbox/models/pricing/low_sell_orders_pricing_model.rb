require 'nokogiri'
require_relative '../database/map_solar_systems'
require_relative '../database/inv_type'
require_relative 'quick_look_data'

class LowSellOrdersPricingModel

	attr_accessor :data_source, :name

	def initialize(source, name = nil)
		if source.is_a? MapSolarSystems
			name = name || source.solarSystemName
			source = QuickLookData.new(usesystem: source.solarSystemID)
		end
		@data_source = source
		@name = name
		@prices = {}
	end

	def buy_price(id)
		price(id)
	end	

	def sell_price(id)
		price(id)
	end

	private

	def price(id)
		id = id.typeID if id.is_a? InvType
		return @prices[id] if @prices.has_key? id
		marketData = Nokogiri::XML(@data_source.data(:typeid => id))
		prices = marketData.css("sell_orders order price")
			.collect {|n| n.content.to_f}
			.sort
			.take(5)
		price = prices.size > 0 ?
			prices.inject(0.0) {|sum, el| sum + el} / prices.size :
			0
		@prices[id] = price
		price
	end

end