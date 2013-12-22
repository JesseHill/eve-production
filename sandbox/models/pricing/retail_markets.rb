require_relative '../database/map_solar_systems'

class RetailMarkets

	attr_accessor :markets

	def initialize
		@markets = ['Jita', 'Amarr', 'Hek', 'Dodixie'].map { |system|
			MapSolarSystems.find_by_solarSystemName(system)
		}
	end

end