require 'spec_helper'
require './models/database/invTypeMaterial.rb'
require './models/database/invType.rb'

describe InvTypeMaterial do

	it 'should answer the correct list of materials for a given type id' do
		# type ID 11484 == R.A.M.- Shield Tech
		materials = InvTypeMaterial.where("typeID = ?", 11484)
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

	it 'should answer an empty list for a primitive type id' do
		# type ID 34 == Tritanium
		materials = InvTypeMaterial.where("typeID = ?", 34)
		materials.length.should eq(0)
	end

end