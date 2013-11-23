require 'spec_helper'
require './models/database/invBlueprintType.rb'
require './models/database/invType.rb'

describe InvType do

	it 'should answer the correct type for a given blueprint id' do
		# blueprint ID 1121 == 250mm Railgun I blueprint
		# type ID 570 == 250mm Railgun I
		blueprint = InvBlueprintType.find_by(blueprintTypeID: 1121)
		blueprint.inv_type.typeID.should eq(570)
	end

end