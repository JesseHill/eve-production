require_relative '../../spec_helper'
require_relative '../../../models/build/blueprint_repository'

describe BlueprintRepository do
	before :each do
	    @repo = BlueprintRepository.new
	end

	it 'should answer the correct material level for some frigates' do
	 	@repo.material_level('Merlin').should eq(20)	
	 	@repo.material_level('Helios').should eq(-3)	
	end

	it 'should answer the correct material level for some cruisers' do
	 	@repo.material_level('Celestis').should eq(50)	
	 	@repo.material_level('Arazu').should eq(-1)	
	end

	it 'should answer the correct material level for some battleships' do
	 	@repo.material_level('Scorpion').should eq(60)	
	 	@repo.material_level('Widow').should eq(-1)	
	end
end