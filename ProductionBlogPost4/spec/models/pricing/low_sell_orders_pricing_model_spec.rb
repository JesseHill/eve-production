require_relative '../../spec_helper'
require_relative '../../../models/pricing/low_sell_orders_pricing_model'

describe LowSellOrdersPricingModel do

	it 'should create the appropriate data source when given a solar system' do
		jita = MapSolarSystems.find_by_solarSystemName('Jita')
		model = LowSellOrdersPricingModel.new(jita)
		model.data_source.query_data[:usesystem].should eq(jita.solarSystemID)
		model.name.should eq(jita.solarSystemName)
	end

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