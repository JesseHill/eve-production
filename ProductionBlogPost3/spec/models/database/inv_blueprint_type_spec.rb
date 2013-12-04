require_relative '../../spec_helper'
require_relative '../../../models/database/inv_blueprint_type.rb'
require_relative '../../../models/database/inv_type.rb'

describe InvType do

	it 'should answer the correct type for a given blueprint id' do
		# blueprint ID 1121 == 250mm Railgun I blueprint
		blueprint = InvBlueprintType.find_by(blueprintTypeID: 1121)
		blueprint.inv_type.typeName.should eq('250mm Railgun I')
	end

	it 'should answer market groups correctly' do
		blueprint = InvType.find_by_typeName('Helios').inv_blueprint_type
		blueprint.in_market_group?(:ships).should be_true
		blueprint.in_market_group?(:frigates).should be_true
		blueprint.in_market_group?(:advanced_frigates).should be_true
		blueprint.in_market_group?(:covert_ops).should be_true

		blueprint.in_market_group?(:cruisers).should be_false		
		blueprint.in_market_group?(:some_symbol).should be_false		
	end

end