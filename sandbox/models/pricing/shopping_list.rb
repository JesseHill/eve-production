

class ShoppingList

	attr_accessor :by_market_and_group

	def initialize(items, markets)
		@special_groups = ['Minerals', 'Construction Components', 'Planetary Materials']
		@by_market_and_group = markets.group_by_buy_price(items).inject({}) { |memo, (market, materials)|
			memo.tap { |memo| 
				memo[market] = materials.group_by { |m, q| group(m.inv_market_group) }
			}
		}
	end

	def group(market_group)
		return market_group if @special_groups.include?(market_group.marketGroupName)
		market_group.parent_group.nil? ? market_group : group(market_group.parent_group)
	end

end