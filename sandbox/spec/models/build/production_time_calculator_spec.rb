require_relative '../../spec_helper'
require_relative '../../../models/database/inv_type'
require_relative '../../../models/build/production_time_calculator'

describe ProductionTimeCalculator do

	before :each do
		@blueprint = InvType.find_by_typeName('Retribution').inv_blueprint_type
		@blueprint_repo = mock('repo')
		@production_info = mock('production_info')
		@production_calculator = ProductionTimeCalculator.new(@blueprint_repo, @production_info)
	end

	it 'should calculate time for productivity_level correctly' do
		@production_info.expects(:industry_skill).returns(1).at_least_once
		@production_info.expects(:production_slot_modifier).returns(1).at_least_once
		@production_info.expects(:implant_modifier).returns(1).at_least_once

		@blueprint_repo.expects(:productivity_level).with(@blueprint).returns(-6).once
		@production_calculator.calculate(@blueprint, 1).should eq(92160)

		@blueprint_repo.expects(:productivity_level).with(@blueprint).returns(0).once
		@production_calculator.calculate(@blueprint, 1).should eq(38400)

		@blueprint_repo.expects(:productivity_level).with(@blueprint).returns(10).once
		@production_calculator.calculate(@blueprint, 1).should eq(31418)
	end		

	it 'should calculate time for industry skill correctly' do
		@blueprint_repo.expects(:productivity_level).returns(1).at_least_once
		@production_info.expects(:production_slot_modifier).returns(1).at_least_once
		@production_info.expects(:implant_modifier).returns(1).at_least_once

		@production_info.expects(:industry_skill).returns(1).once
		@production_calculator.calculate(@blueprint, 1).should eq(34560)

		@production_info.expects(:industry_skill).returns(5).once
		@production_calculator.calculate(@blueprint, 1).should eq(28800)
	end	

	it 'should calculate time for production_slot_modifier correctly' do
		@blueprint_repo.expects(:productivity_level).with(@blueprint).returns(1).at_least_once
		@production_info.expects(:industry_skill).returns(1).at_least_once
		@production_info.expects(:implant_modifier).returns(1).at_least_once

		@production_info.expects(:production_slot_modifier).returns(1).once
		@production_calculator.calculate(@blueprint, 1).should eq(34560)

		@production_info.expects(:production_slot_modifier).returns(0.75).once
		@production_calculator.calculate(@blueprint, 1).should eq(25920)
	end		

	it 'should calculate time for implant_modifier correctly' do
		@production_info.expects(:production_slot_modifier).returns(1).at_least_once
		@blueprint_repo.expects(:productivity_level).with(@blueprint).returns(1).at_least_once
		@production_info.expects(:industry_skill).returns(1).at_least_once

		@production_info.expects(:implant_modifier).returns(1).once
		@production_calculator.calculate(@blueprint, 1).should eq(34560)

		@production_info.expects(:implant_modifier).returns(0.95).once
		@production_calculator.calculate(@blueprint, 1).should eq(32832)
	end	

	it 'should calculate runs correctly' do
		@production_info.expects(:production_slot_modifier).returns(1).at_least_once
		@blueprint_repo.expects(:productivity_level).with(@blueprint).returns(1).at_least_once
		@production_info.expects(:industry_skill).returns(1).at_least_once
		@production_info.expects(:implant_modifier).returns(1).at_least_once

		@production_calculator.calculate(@blueprint, 1).should eq(34560)
		@production_calculator.calculate(@blueprint, 10).should eq(345600)
	end			

end