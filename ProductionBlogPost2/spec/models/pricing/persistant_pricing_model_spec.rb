require 'spec_helper'
require './models/pricing/persistant_pricing_model.rb'

describe PersistantPricingModel do

	before(:each) do
    	FileUtils.rm Dir["./spec/data/*.pstore"]
    end

	it 'should answer the expected values from the pricing model' do
		model = mock('pricingModel')
		model.
			expects(:buy_price).
			with(34).
			returns(1).
			once()
		model.
			expects(:sell_price).
			with(34).
			returns(2).
			once()

		model = PersistantPricingModel.new(model, "./spec/data")
		model.buy_price(34).should eq(1)
		model.sell_price(34).should eq(2)
	end

	it 'should handle expiration correctly' do
		model = mock('pricingModel')
		model.
			expects(:buy_price).
			with(34).
			returns(1).
			twice()
		model.
			expects(:sell_price).
			with(34).
			returns(2).
			twice()

		model = PersistantPricingModel.new(model, "./spec/data", 1)
		model.buy_price(34).should eq(1)
		model.sell_price(34).should eq(2)
		sleep(2)
		model.buy_price(34).should eq(1)
		model.sell_price(34).should eq(2)
	end

end