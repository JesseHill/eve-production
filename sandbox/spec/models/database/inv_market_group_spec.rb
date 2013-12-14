require_relative '../../spec_helper'
require_relative '../../../models/database/inv_market_group.rb'

describe InvMarketGroup do

	it 'should answer the correct group for a group id' do
		group = InvMarketGroup.find_by_marketGroupID(5)
		group.marketGroupName.should eq('Standard Frigates')
	end

	it 'should answer whether a group is included in another' do
		# 420 == 'Covert Ops', but it's not safe to search by name as that is not a unique field.
		group = InvMarketGroup.find_by_marketGroupID(420)
		group.included_in?(:advanced_frigates).should be_true
		group.included_in?(:ships).should be_true
		group.included_in?(:cruisers).should be_false
	end

	it 'should answer whether a group is included in a set of groups' do
		# 420 == 'Covert Ops', but it's not safe to search by name as that is not a unique field.
		group = InvMarketGroup.find_by_marketGroupID(420)
		group.included_in?(:cruisers, :advanced_frigates).should be_true
		group.included_in?(:cruisers, :industrials).should be_false
	end	

end