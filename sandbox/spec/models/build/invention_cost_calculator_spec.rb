require_relative '../../spec_helper'
require_relative '../../../models/database/inv_type'
require_relative '../../../models/database/inv_market_group'
require_relative '../../../models/build/decryptor_repository'
require_relative '../../../models/build/invention_cost_calculator'

describe InventionCostCalculator do
	
	before :each do
		@pricing = mock('Pricing')
		@prob_calc = mock('InventionProbabilityCalculator')
		@strategy = mock('InventionStrategy')
	    @calc = InventionCostCalculator.new(@pricing, @prob_calc, @strategy)
	end

	it 'should answer the correct base cost of invention' do
		datacore_1 = InvType.find_by_typeName('Datacore - Gallentean Starship Engineering')
		datacore_2 = InvType.find_by_typeName('Datacore - Mechanical Engineering')

		@strategy.expects(:techI_item).returns(nil)
		@strategy.expects(:decryptor).returns(nil)
		@pricing.expects(:buy_price).with(datacore_1).returns(100).once
		@pricing.expects(:buy_price).with(datacore_2).returns(100).once

		@calc.cost(InvType.find_by_typeName('Helios')).should eq(400)
	end

	it 'should answer the correct cost of invention with a decryptor' do
		datacore_1 = InvType.find_by_typeName('Datacore - Gallentean Starship Engineering')
		datacore_2 = InvType.find_by_typeName('Datacore - Mechanical Engineering')
		decryptor = InvType.find_by_typeName('Incognito Accelerant')

		@strategy.expects(:techI_item).returns(nil)
		@strategy.expects(:decryptor).returns(decryptor)
		@pricing.expects(:buy_price).with(datacore_1).returns(100).once
		@pricing.expects(:buy_price).with(datacore_2).returns(100).once
		@pricing.expects(:buy_price).with(decryptor).returns(1000).once

		@calc.cost(InvType.find_by_typeName('Helios')).should eq(1400)
	end	

	it 'should answer the correct cost of invention per run with a decryptor' do
		item = InvType.find_by_typeName('Helios')
		datacore_1 = InvType.find_by_typeName('Datacore - Gallentean Starship Engineering')
		datacore_2 = InvType.find_by_typeName('Datacore - Mechanical Engineering')
		decryptor = InvType.find_by_typeName('Incognito Accelerant')

		@strategy.expects(:techI_item).returns(nil)
		@strategy.expects(:decryptor).returns(decryptor)
		@pricing.expects(:buy_price).with(datacore_1).returns(100).once
		@pricing.expects(:buy_price).with(datacore_2).returns(100).once
		@pricing.expects(:buy_price).with(decryptor).returns(100).once
		@prob_calc.expects(:chance).with(item).returns(0.25)
		@prob_calc.expects(:runs).with(item).returns(2)

		@calc.cost_per_run(item).should eq(1000)
	end	

	it 'should answer the correct cost of invention per run with a tI item' do
		datacore_1 = InvType.find_by_typeName('Datacore - Gallentean Starship Engineering')
		datacore_2 = InvType.find_by_typeName('Datacore - Mechanical Engineering')
		item = InvType.find_by_typeName('Imicus')

		@strategy.expects(:techI_item).returns(item)
		@strategy.expects(:decryptor).returns(nil)
		@pricing.expects(:buy_price).with(datacore_1).returns(100).once
		@pricing.expects(:buy_price).with(datacore_2).returns(100).once
		@pricing.expects(:buy_price).with(item).returns(500).once

		@calc.cost(InvType.find_by_typeName('Helios')).should eq(900)

	end	end