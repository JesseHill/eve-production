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

	it 'should answer manufacturing requirements correctly' do
		blueprint = InvType.find_by_typeName('Crow').inv_blueprint_type
		reqs = blueprint.ram_type_requirements_for_manufacturing
		reqs.length.should eq(6)

		materials = reqs.
			reject { |r| r.required_type.is_skill? }.
			each_with_object({}) { |r, h|
				h[r.required_type] = r.quantity
			}

		materials[InvType.find_by_typeName('Condor')].should eq(1)
		materials[InvType.find_by_typeName('R.A.M.- Starship Tech')].should eq(1)
	end	

	it 'should answer invention requirements correctly' do
		blueprint = InvType.find_by_typeName('Condor').inv_blueprint_type
		reqs = blueprint.ram_type_requirements_for_invention
		reqs.length.should eq(3)

		datacores = reqs.
			select { |r| r.required_type.inv_group.groupName == 'Datacores' }.
			each_with_object({}) { |r, h|
				h[r.required_type] = r.quantity
			}

		datacores[InvType.find_by_typeName('Datacore - Caldari Starship Engineering')].should eq(2)
		datacores[InvType.find_by_typeName('Datacore - Mechanical Engineering')].should eq(2)
	end
end