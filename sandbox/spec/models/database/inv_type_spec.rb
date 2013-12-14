require_relative '../../spec_helper'
require_relative '../../../models/database/inv_type.rb'

describe InvType do

	it 'should answer type named Tritanium for id 34' do
		type = InvType.find_by(typeID: 34)
		type.typeName.should eq('Tritanium')
	end

	it 'should answer the correct blueprint for a given type' do
		# blueprint ID 1121 == 250mm Railgun I blueprint
		type = InvType.find_by(typeName: '250mm Railgun I')
		type.inv_blueprint_type.blueprintTypeID.should eq(1121)
	end

	it 'should answer no blueprint for a primitive type' do
		type = InvType.find_by(typeName: 'Tritanium')
		type.inv_blueprint_type.should be_nil
	end

	it 'should answer the correct group for a type' do
		type = InvType.find_by(typeName: '250mm Railgun I')
		type.inv_group.groupName.should eq('Hybrid Weapon')
	end

	it 'should answer the correct list of invTypeMaterials for a given type id' do
		type = InvType.find_by(typeName: 'R.A.M.- Shield Tech')
		materials = type.inv_type_materials
		materials.length.should eq(5)
		expected = {
			34 => 500,
			35 => 400,
			36 => 200,
			37 => 74,
			38 => 32
		}
		materials.each {|m|
			expected.has_key?(m.required_type.typeID).should be_true
			expected[m.required_type.typeID] = m.quantity
		}
	end

	it 'should answer an empty list of ramTypeRequirements for a primitive type id' do
		type = InvType.find_by(typeName: 'Tritanium')
		requirements = type.ram_type_requirements
		requirements.length.should eq(0)
	end

	it 'should answer the correct list of ramTypeRequirements for a given type id' do
		type = InvType.find_by(typeName: 'Nanofiber Internal Structure II')
		requirements = type.ram_type_requirements
		requirements.length.should eq(22)
	end

	it 'should answer an empty list of manufacturing ramTypeRequirements for a primitive type id' do
		type = InvType.find_by(typeName: 'Tritanium')
		requirements = type.ram_type_requirements_for_manufacturing
		requirements.length.should eq(0)
	end

	it 'should answer the correct list of manufacturing ramTypeRequirements for a tech II type id' do
		type = InvType.find_by(typeName: 'Nanofiber Internal Structure II')
		requirements = type.ram_type_requirements_for_manufacturing
		requirements.length.should eq(6)
	end

	it 'should answer the correct list of invention ramTypeRequirements for a tech II type id' do
		type = InvType.find_by(typeName: 'Helios')
		requirements = type.ram_type_requirements_for_invention
		requirements.length.should eq(3)
		materials = requirements.each_with_object({}) {|r,h| h[r.required_type] = r.quantity}
		materials[InvType.find_by_typeName('Datacore - Gallentean Starship Engineering')].should eq(2)
		materials[InvType.find_by_typeName('Datacore - Mechanical Engineering')].should eq(2)
		materials[InvType.find_by_typeName('Incognito Ship Data Interface')].should eq(1)
	end	

	it 'should answer whether the item is in a market group' do
		type = InvType.find_by_typeName('Crow')
		type.in_market_group?(:frigates).should be_true		
		type.in_market_group?(:cruisers, :frigates).should be_true		
		type.in_market_group?(:cruisers, :industrials).should be_false		
	end

	it 'should answer the correct meta-level' do
		InvType.find_by_typeName('1MN Microwarpdrive I').meta_level.should eq(0)
		InvType.find_by_typeName('Upgraded 1MN Microwarpdrive I').meta_level.should eq(1)
		InvType.find_by_typeName('Limited 1MN Microwarpdrive I').meta_level.should eq(2)
		InvType.find_by_typeName('Experimental 10MN Microwarpdrive I').meta_level.should eq(3)
	end	

	it 'should answer the correct base item' do
		condor = InvType.find_by_typeName('Condor')

		condor.base_item.should eq(condor)
		InvType.find_by_typeName('Crow').base_item.should eq(condor)
	end		
end