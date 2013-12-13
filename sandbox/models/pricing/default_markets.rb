require_relative '../database/map_solar_systems'

class DefaultMarkets

	attr_accessor :markets

	def initialize
		# Create our pricing data.
		@markets = ['Jita', 'Amarr'].map { |system|
			MapSolarSystems.find_by_solarSystemName(system)
		}
	end

end