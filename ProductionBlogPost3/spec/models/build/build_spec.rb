require_relative '../../spec_helper'
require_relative '../../../models/build/build'

describe Build do

	it 'should answer the correct name' do
	 	build = Build.new('Construction Components');
	 	build.name.should eq('Construction Components')	
	end

end