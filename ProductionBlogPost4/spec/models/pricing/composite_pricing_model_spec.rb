require_relative '../../spec_helper'
require_relative '../../../models/pricing/composite_pricing_model'

describe CompositePricingModel do

	it 'should answer the expected values when created with no models' do
		model = CompositePricingModel.new([])
		model.buy_price(34).should eq(0)
		model.sell_price(34).should eq(0)
	end

	it 'should answer the expected values when created with a single model' do
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

		model = CompositePricingModel.new([model])
		model.buy_price(34).should eq(1)
		model.sell_price(34).should eq(2)
	end

end