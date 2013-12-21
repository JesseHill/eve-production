require_relative '../database/map_regions'
require_relative 'persistent_market_history'
require_relative 'seven_day_trailing_average'

class DefaultMarketHistory

	attr_accessor :history

	def initialize
		@history = PersistentMarketHistory.new(
			SevenDayTrailingAverage.new(
				MapRegions.find_by_regionName("The Forge")))
	end	

	def volume(item)
		@history.volume(item)
	end

	def average_price(item)
		@history.average_price(item)
	end

end