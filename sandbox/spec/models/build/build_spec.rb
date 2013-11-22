require 'spec_helper'
require './models/build/build.rb'

describe Build do

	it 'should answer the correct name' do
	 	build = Build.new('Construction Components');
	 	build.name.should eq('Construction Components')	
	end

end