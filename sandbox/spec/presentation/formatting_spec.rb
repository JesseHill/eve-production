require_relative '../spec_helper'
require_relative '../../presentation/formatting'

describe Formatting do

	it 'should format times correctly' do
		Formatting.format_time(45).should eq('45 seconds')

		Formatting.format_time(60).should eq('1 minute')
		Formatting.format_time(60 + 60).should eq('2 minutes')
		Formatting.format_time(60 + 45).should eq('1 minute and 45 seconds')
		Formatting.format_time(60 + 60 + 45).should eq('2 minutes and 45 seconds')

		Formatting.format_time(60 * 60).should eq('1 hour')
		Formatting.format_time(2 * 60 * 60).should eq('2 hours')
		Formatting.format_time(60 * 60 + 45).should eq('1 hour and 45 seconds')
		Formatting.format_time(60 * 60 + 60 + 45).should eq('1 hour, 1 minute, and 45 seconds')
		Formatting.format_time(2 * 60 * 60 + 60).should eq('2 hours and 1 minute')
		Formatting.format_time(2 * 60 * 60 + 2 * 60).should eq('2 hours and 2 minutes')

		Formatting.format_time(24 * 60 * 60).should eq('1 day')
		Formatting.format_time(2 * 24 * 60 * 60).should eq('2 days')
		Formatting.format_time(2 * 24 * 60 * 60 + 15).should eq('2 days and 15 seconds')
		Formatting.format_time(2 * 24 * 60 * 60 + 60).should eq('2 days and 1 minute')
		Formatting.format_time(2 * 24 * 60 * 60 + 60 * 60 + 60 + 15).should eq('2 days, 1 hour, 1 minute, and 15 seconds')
	end

end