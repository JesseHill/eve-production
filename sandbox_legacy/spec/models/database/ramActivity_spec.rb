require 'spec_helper'
require './models/database/ramActivity.rb'

describe RamActivity do

	it 'should answer the correct activity for an activity id' do
		# activity ID 1 == Manufacturing
		activity = RamActivity.find_by(activityID: 1)
		activity.activityName.should eq('Manufacturing')
	end

end