require_relative '../../spec_helper'
require_relative '../../../models/database/inv_market_group.rb'

describe InvMarketGroup do

	it 'should answer the correct group for a group id' do
		group = InvMarketGroup.find_by_marketGroupID(5)
		group.marketGroupName.should eq('Standard Frigates')
	end

	it 'should answer whether a group is included in another' do
		# 420 == Covert Ops
		group = InvMarketGroup.find_by_marketGroupID(420)
		group.included_in?(:advanced_frigates).should be_true
		group.included_in?(:ships).should be_true
		group.included_in?(:cruisers).should be_false
	end
end