require_relative '../../spec_helper'
require_relative '../../../models/build/waste_calculator'

describe WasteCalculator do
	before :each do
	    @blueprint = mock('blueprint')
		@blueprintRepo = mock('repo')
	end

	it 'should calculate a negative ME blueprint correctly' do
		@blueprint.expects(:wasteFactor).returns(10).at_least_once
		@blueprintRepo.expects(:material_level).with(@blueprint).returns(-1).at_least_once

		WasteCalculator.new(0, @blueprintRepo).calculate_required_quantity(@blueprint, 100).should eq(145)
		WasteCalculator.new(5, @blueprintRepo).calculate_required_quantity(@blueprint, 100).should eq(120)
	end	
	
	it 'should calculate a zero ME blueprint correctly' do
		@blueprint.expects(:wasteFactor).returns(10).at_least_once
		@blueprintRepo.expects(:material_level).with(@blueprint).returns(0).at_least_once

		WasteCalculator.new(0, @blueprintRepo).calculate_required_quantity(@blueprint, 100).should eq(135)
		WasteCalculator.new(5, @blueprintRepo).calculate_required_quantity(@blueprint, 100).should eq(110)
	end

	it 'should calculate a positive ME blueprint correctly' do
		@blueprint.expects(:wasteFactor).returns(10).at_least_once
		@blueprintRepo.expects(:material_level).with(@blueprint).returns(10).at_least_once

		WasteCalculator.new(0, @blueprintRepo).calculate_required_quantity(@blueprint, 100).should eq(126)
		WasteCalculator.new(5, @blueprintRepo).calculate_required_quantity(@blueprint, 100).should eq(101)
	end

	it 'should handle waste factors correctly' do
		@blueprintRepo.expects(:material_level).with(@blueprint).returns(0).at_least_once

		@blueprint.expects(:wasteFactor).returns(0).at_least_once
		WasteCalculator.new(5, @blueprintRepo).calculate_required_quantity(@blueprint, 100).should eq(100)

		@blueprint.expects(:wasteFactor).returns(50).at_least_once
		WasteCalculator.new(5, @blueprintRepo).calculate_required_quantity(@blueprint, 100).should eq(150)

		@blueprint.expects(:wasteFactor).returns(100).at_least_once
		WasteCalculator.new(5, @blueprintRepo).calculate_required_quantity(@blueprint, 100).should eq(200)
	end

end