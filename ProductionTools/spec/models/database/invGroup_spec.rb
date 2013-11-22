require 'spec_helper'
require './models/database/invGroup.rb'

describe InvGroup do

	it 'should answer the correct group for a group id' do
		# group ID 72 == Smart Bomb
		group = InvGroup.find_by(groupID: 72)
		group.groupName.should eq('Smart Bomb')
	end

	it 'should answer the correct category for a skill group' do
		# group ID 268 == Industry
		group = InvGroup.find_by(groupID: 268)
		group.inv_category.categoryName.should eq("Skill")
	end

end