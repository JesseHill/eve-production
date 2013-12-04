require_relative '../../spec_helper'
require_relative '../../../models/database/map_solar_systems.rb'

describe MapSolarSystems do

	it 'should answer the correct id for a system name' do
		jita = MapSolarSystems.find_by_solarSystemName('Jita')
		jita.solarSystemID.should eq(30000142)

		jita = MapSolarSystems.find_by_solarSystemName('Amarr')
		jita.solarSystemID.should eq(30002187)
	end
end