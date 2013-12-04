require_relative '../../spec_helper'
require_relative '../../../models/build/job'

describe Job do

	it 'should load item by id' do
	 	item = Job.new(34, 1);
	 	item.name.should eq('Tritanium')	
	end

	it 'should load item by name' do
	 	item = Job.new('Tritanium', 1);
	 	item.name.should eq('Tritanium')	
	end

	it 'should answer the correct quantity' do
	 	item = Job.new('Tritanium', 15);
	 	item.runs.should eq(15)
	end

end