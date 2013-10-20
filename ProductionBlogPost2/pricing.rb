require './models/pricing/quick_look_data.rb'
require './models/pricing/low_sell_orders_pricing_model.rb'
require './models/pricing/composite_pricing_model.rb'
require './models/pricing/persistant_pricing_model.rb'

# First build a pricing model for each of the systems we care about.
# We'll do better than these magic system and type id numbers in later posts. 
jita = LowSellOrdersPricingModel.new(QuickLookData.new(usesystem: 30000142))
amarr = LowSellOrdersPricingModel.new(QuickLookData.new(usesystem: 30002187))

# Next we'll build a model that gives us the composite data from those systems.
markets = CompositePricingModel.new([jita, amarr])

# Persist it so we don't wear out the eve-central server.
pricing = PersistantPricingModel.new(markets)

# And now we should be able to get useful pricing data.
puts "Tritanium buy price: #{pricing.buy_price(34)}"
puts "Tritanium sell price: #{pricing.sell_price(34)}"