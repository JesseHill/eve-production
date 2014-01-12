require_relative '../database/map_solar_systems'

class RetailMarkets

	attr_accessor :markets

	def initialize
		@markets = ['Jita', 'Amarr', 'Hek', 'Dodixie', 'Rens'].map do |system|
			MapSolarSystems.find_by_solarSystemName(system)
		end
	end

end