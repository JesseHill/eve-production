require_relative 'low_sell_orders_pricing_model'
require_relative 'composite_pricing_model'
require_relative 'persistent_pricing_model'
require_relative 'default_markets'

class DefaultPricingModel

	attr_accessor :pricing

	def initialize
		@pricing = CompositePricingModel.new(
			DefaultMarkets.new.markets.map do |m|
				PersistentPricingModel.new(LowSellOrdersPricingModel.new(m))
			end
		)
	end

end