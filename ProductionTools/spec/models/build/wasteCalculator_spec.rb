require './models/build/wasteCalculator.rb'

describe WasteCalculator do
	
	it 'should calculate a positive ME bp correctly' do
		blueprintRepo = mock('repo')
		blueprintRepo.expects(:material_level).with(1).returns(0).at_least_once

		blueprint = mock('blueprint')
		blueprint.expects(:blueprintTypeID).returns(1)
		blueprint.expects(:wasteFactor).returns(10).at_least_once

		wasteCalc = WasteCalculator.new(5, blueprintRepo)
		quantity = wasteCalc.calculate_quantity(blueprint, 8220)
		quantity.should eq(9042)
	end
end