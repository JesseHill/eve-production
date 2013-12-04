require_relative '../../spec_helper'
require_relative '../../../models/database/inv_market_group.rb'

describe InvMarketGroup do

	it 'should answer the correct group for a group id' do
		group = InvMarketGroup.find_by(marketGroupID: 5)
		group.marketGroupName.should eq('Standard Frigates')
	end

end