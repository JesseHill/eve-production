require 'spec_helper'
require './models/build/lineItemReport.rb'

describe LineItemReport do

	it 'should answer the correct values for an item' do
		item = mock('lineItem')
		item.expects(:name).returns('someItem')
		item.expects(:typeID).returns(1)
		item.expects(:quantity).returns(1)
		item.expects(:materials).returns({34 => 10, 35 => 20})
 	
	 	pricing = mock('pricing')
    	pricing.expects(:price).with(1).returns(300)
    	pricing.expects(:price).with(34).returns(5)
    	pricing.expects(:price).with(35).returns(10)

	 	itemReport = LineItemReport.new(item, pricing)
	 	itemReport.cost.should eq(250)
	 	itemReport.value.should eq(300)
	 	itemReport.profit.should eq(50)
	 	itemReport.profit_margin.should eq(20)
	end
end