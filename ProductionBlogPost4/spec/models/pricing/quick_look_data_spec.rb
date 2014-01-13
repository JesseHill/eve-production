require 'spec_helper'
require './models/pricing/quick_look_data.rb'

describe QuickLookData do

	it 'should answer the quick look api url when given no options' do
		api = QuickLookData.new
		api.uri.to_s.should eq('http://api.eve-central.com/api/quicklook')
	end

	it 'should answer with the options appended when options are passed' do
		api = QuickLookData.new({usesystem: 101, typeid: 34})
		api.uri.to_s.should eq('http://api.eve-central.com/api/quicklook?usesystem=101&typeid=34')
	end

end