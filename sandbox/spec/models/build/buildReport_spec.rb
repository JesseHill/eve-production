require 'spec_helper'
require './models/build/buildReport.rb'

describe BuildReport do

	it 'should answer the correct values for a nested build' do
    	wasteCalc = mock('wasteCalc')
    	wasteCalc.expects(:calculate_quantity).returns(1).at_least_once

		item1 = LineItem.new('250mm Railgun I', 1, wasteCalc)
		item1.expects(:typeID).returns(1)
		item1.expects(:quantity).returns(1)
		item1.expects(:materials).returns({34 => 10, 35 => 20})

		item2 = LineItem.new('250mm Railgun I', 1, wasteCalc)
		item2.expects(:typeID).returns(1)
		item2.expects(:quantity).returns(1)
		item2.expects(:materials).returns({34 => 10, 35 => 20})

	 	nested = Build.new('Nested');
	 	nested.add(item1)
	 	nested.add(item2)

	 	root = Build.new('Root');
	 	root.add(nested)
 	
	 	pricing = mock('pricing')
    	pricing.expects(:price).with(1).returns(300).twice()
    	pricing.expects(:price).with(34).returns(5).twice()
    	pricing.expects(:price).with(35).returns(10).twice()

	 	report = BuildReport.new(root, pricing)
	 	report.cost.should eq(500)
	 	report.value.should eq(600)
	 	report.profit.should eq(100)
	 	report.profit_margin.should eq(20)
	 	report.materials[34].should eq(20)
	 	report.materials[35].should eq(40)
	end

end