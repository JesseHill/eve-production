require_relative '../../spec_helper'
require_relative '../../../models/build/waste_calculator'

describe WasteCalculator do

	it 'should calculate a negative ME blueprint correctly' do
		blueprint = mock('blueprint')
		blueprint.expects(:wasteFactor).returns(10).at_least_once
		blueprintRepo = mock('repo')
		blueprintRepo.expects(:material_level).with(blueprint).returns(-1).at_least_once

		WasteCalculator.new(0, blueprintRepo).calculate_required_quantity(blueprint, 100).should eq(145)
		WasteCalculator.new(5, blueprintRepo).calculate_required_quantity(blueprint, 100).should eq(120)
	end	
	
	it 'should calculate a zero ME blueprint correctly' do
		blueprint = mock('blueprint')
		blueprint.expects(:wasteFactor).returns(10).at_least_once
		blueprintRepo = mock('repo')
		blueprintRepo.expects(:material_level).with(blueprint).returns(0).at_least_once

		WasteCalculator.new(0, blueprintRepo).calculate_required_quantity(blueprint, 100).should eq(135)
		WasteCalculator.new(5, blueprintRepo).calculate_required_quantity(blueprint, 100).should eq(110)
	end

	it 'should calculate a positive ME blueprint correctly' do
		blueprint = mock('blueprint')
		blueprint.expects(:wasteFactor).returns(10).at_least_once
		blueprintRepo = mock('repo')
		blueprintRepo.expects(:material_level).with(blueprint).returns(10).at_least_once

		WasteCalculator.new(0, blueprintRepo).calculate_required_quantity(blueprint, 100).should eq(126)
		WasteCalculator.new(5, blueprintRepo).calculate_required_quantity(blueprint, 100).should eq(101)
	end

end