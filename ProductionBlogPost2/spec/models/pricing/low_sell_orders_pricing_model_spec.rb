require 'spec_helper'
require './models/pricing/low_sell_orders_pricing_model.rb'

describe LowSellOrdersPricingModel do

	it 'should answer the expected value for a standard test data file' do
		dataSource = mock('data')
		dataSource.
			expects(:data).
			with(:typeid => 34).
			returns(File.open("./spec/data/quicklook-data-standard.xml", "r")).
			once()

		model = LowSellOrdersPricingModel.new(dataSource)
		model.buy_price(34).should eq(4.78)
		model.sell_price(34).should eq(4.78)
	end

	it 'should answer the expected value for a test data file with only one sell order' do
		dataSource = mock('data')
		dataSource.
			expects(:data).
			with(:typeid => 34).
			returns(File.open("./spec/data/quicklook-data-one-sell-order.xml", "r")).
			once()

		model = LowSellOrdersPricingModel.new(dataSource)
		model.buy_price(34).should eq(4.8)
		model.sell_price(34).should eq(4.8)
	end

	it 'should answer the expected value for a test data file with only no sell orders' do
		dataSource = mock('data')
		dataSource.
			expects(:data).
			with(:typeid => 34).
			returns(File.open("./spec/data/quicklook-data-no-sell-orders.xml", "r")).
			once()

		model = LowSellOrdersPricingModel.new(dataSource)
		model.buy_price(34).should eq(0)
		model.sell_price(34).should eq(0)
	end

end