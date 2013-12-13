require_relative 'low_buy_high_sell_orders_pricing_model'
require_relative 'composite_pricing_model'
require_relative 'persistent_pricing_model'
require_relative 'default_markets'

class ReprocessingPricingModel

	attr_accessor :pricing

	def initialize
		@pricing = CompositePricingModel.new(
			DefaultMarkets.new().markets.map { |m|
				PersistentPricingModel.new(LowBuyHighSellOrdersPricingModel.new(m, "lbhs"))
			}
		)
	end

end