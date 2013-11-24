require_relative '../../spec_helper'
require_relative '../../../models/database/inv_type'
require_relative '../../../models/build/materials_calculator'

describe MaterialsCalculator do
	before :each do
		@blueprint_repo = mock('repo')
		@waste_calculator = WasteCalculator.new(5, @blueprint_repo)
		@materials_calculator = MaterialsCalculator.new(@waste_calculator)
	end

	it 'should calculate materials for a tech I item correctly' do
		blueprint = InvType.find_by_typeName('Worm').inv_blueprint_type
		@blueprint_repo.expects(:material_level).returns(0).at_least_once
		materials = @materials_calculator.required_materials(blueprint, 10)
		puts materials
		materials[34].should eq(208600)
		materials[35].should eq(92880)
		materials[36].should eq(30950)
		materials[37].should eq(5840)
		materials[38].should eq(20)
		materials[39].should eq(20)
		materials[40].should eq(20)
	end	

end