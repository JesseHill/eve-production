require_relative '../../spec_helper'
require_relative '../../../models/build/blueprint_repository'

describe BlueprintRepository do
	before :each do
	    @repo = BlueprintRepository.new
	end

	it 'should answer the correct material level for a Merlin' do
		merlin = InvType.find_by_typeName('Merlin')
	 	@repo.material_level(merlin.inv_blueprint_type.blueprintTypeID).should eq(20)	
	end

end