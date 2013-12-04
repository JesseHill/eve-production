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
end