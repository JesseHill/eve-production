require 'spec_helper'
require './models/database/ramTypeRequirement.rb'
require './models/database/invType.rb'
require './models/database/ramActivity.rb'

describe RamTypeRequirement do

	it 'should answer the correct list of materials for a given bluprint id' do
		# blueprint type ID 2606 == Nanofiber Internal Structure II
		blueprint = InvBlueprintType.find_by(blueprintTypeID: 2606)
		requirements = blueprint.ram_type_requirements
		requirements.length.should eq(22)
	end

	it 'should answer the correct list of manufacturing materials for a given bluprint id' do
		# blueprint type ID 2606 == Nanofiber Internal Structure II
		blueprint = InvBlueprintType.find_by(blueprintTypeID: 2606)
		requirements = blueprint.ram_type_requirements_for_manufacturing

		expected = {
			2603 => 1,
			3380 => 5,
			3828 => 5,
			11442 => 1,
			11475 => 1,
			11529 => 1
		}

		requirements.each {|r|
			expected.has_key?(r.required_type.typeID).should be_true
			expected[r.required_type.typeID] = r.quantity
		}
	end

end