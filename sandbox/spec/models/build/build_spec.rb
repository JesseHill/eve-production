require 'spec_helper'
require './models/build/build.rb'

describe Build do

	it 'should answer the correct name' do
	 	build = Build.new('Construction Components');
	 	build.name.should eq('Construction Components')	
	end

	it 'should add categories and line items' do
    	wasteCalc = mock('wasteCalc')
    	wasteCalc.expects(:calculate_quantity).returns(1).at_least_once

	 	build = Build.new('Stuff');
	 	category = Build.new('One');
	 	category.add(LineItem.new('250mm Railgun I', 100, wasteCalc));
	 	build.add(category)
	 	build.items.length.should eq(1)
	 	build.items[0].name.should eq('One')
	 	build.items[0].items[0].name.should eq('250mm Railgun I')
	end

end