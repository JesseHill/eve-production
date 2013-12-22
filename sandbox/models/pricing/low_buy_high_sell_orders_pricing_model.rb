require 'nokogiri'
require_relative '../database/map_solar_systems'
require_relative 'quick_look_data'

class LowBuyHighSellOrdersPricingModel

	attr_accessor :data_source, :name

	def initialize(source, name = nil)
		if source.is_a? MapSolarSystems
			name = name || source.solarSystemName
			source = QuickLookData.new(usesystem: source.solarSystemID)
		end
		@data_source = source
		@name = name
		@buy_prices = {}
		@sell_prices = {}
	end

  def buy_price(id)
    load_prices(id)
    @buy_prices[id]
  end 

  def sell_price(id)
    load_prices(id)
    @sell_prices[id]
  end

  private

	def selector(type)
		type == :buy ? "sell_orders order price" : "buy_orders order price"
	end

	def get_price(marketData, type)
		prices = marketData.css(selector(type))
			.collect {|n| n.content.to_f}
			.sort
		prices = prices.reverse if type == :sell
		prices = prices.take(5)
		prices.size > 0 ?
			prices.inject(0.0) {|sum, el| sum + el} / prices.size :
			0
	end

  def load_prices(id)
    return if @buy_prices.has_key? id
    marketData = Nokogiri::XML(@data_source.data(:typeid => id))
    @buy_prices[id] = get_price(marketData, :buy)
    @sell_prices[id] = get_price(marketData, :sell)
  end 
	
end