require 'spec_helper'
require './models/build/lineItem.rb'
require './models/build/wasteCalculator.rb'

describe LineItem do

	it 'should load item by id' do
	 	item = LineItem.new(34, 1, mock('unused'));
	 	item.name.should eq('Tritanium')	
	end

	it 'should load item by name' do
	 	item = LineItem.new('Tritanium', 1, mock('unused'));
	 	item.name.should eq('Tritanium')	
	end

	it 'should answer the correct quantity' do
	 	item = LineItem.new('Tritanium', 15, mock('unused'));
	 	item.quantity.should eq(15)
	end

	it 'should answer the correct list of build requirements for a tech I item' do
	 	blueprintRepo = mock('blueprintRepo')
	 	blueprintRepo.expects(:material_level).with(anything).returns(0).at_least_once
    	wasteCalc = WasteCalculator.new(5, blueprintRepo)

		item = LineItem.new('250mm Railgun I', 1, wasteCalc);
		materials = item.materials
		materials.length.should eq(5)
		materials[34].should eq(9042)
		materials[35].should eq(2951)
		materials[36].should eq(3563)
		materials[37].should eq(2)
		materials[38].should eq(18)
	end

	it 'should answer the correct list of build requirements for a tech II item' do
	 	blueprintRepo = mock('blueprintRepo')
	 	blueprintRepo.expects(:material_level).with(anything).returns(-4).at_least_once
    	wasteCalc = WasteCalculator.new(5, blueprintRepo)

		item = LineItem.new('250mm Railgun II', 1, wasteCalc);
		materials = item.materials
		materials.length.should eq(10)
		#Base
		materials[34].should eq(3420)
		materials[35].should eq(1316)
		materials[36].should eq(675)
		materials[37].should eq(2)
		materials[38].should eq(6)
		materials[11399].should eq(15)
		#Extra
		materials[570].should eq(1)
		materials[9848].should eq(3)
		materials[11486].should eq(1)
		materials[11690].should eq(12)
	end

	it 'should handle a quantity correctly' do
	 	blueprintRepo = mock('blueprintRepo')
	 	blueprintRepo.expects(:material_level).with(anything).returns(-4).at_least_once
    	wasteCalc = WasteCalculator.new(5, blueprintRepo)

		item = LineItem.new('250mm Railgun II', 10, wasteCalc);
		materials = item.materials
		materials.length.should eq(10)
		#Base
		materials[34].should eq(34200)
		materials[35].should eq(13160)
		materials[36].should eq(6750)
		materials[37].should eq(20)
		materials[38].should eq(60)
		materials[11399].should eq(150)
		#Extra
		materials[570].should eq(10)
		materials[9848].should eq(30)
		materials[11486].should eq(10)
		materials[11690].should eq(120)
	end

end