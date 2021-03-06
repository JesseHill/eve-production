require_relative '../../spec_helper'
require_relative '../../../models/build/blueprint_repository'

describe BlueprintRepository do
	before :each do
		@repository = mock('repository')
		@strategy = mock('strategy')
	    @repo = BlueprintRepository.new(@repository, @strategy)
	end

	it 'should answer the correct material level for some frigates' do
	 	@repo.material_level('Merlin').should eq(20)	
	 	@repo.material_level('Worm').should eq(0)	

		helios = InvType.find_by_typeName('Helios')
		decryptor = mock('decryptor')
		@strategy.expects(:decryptor).with(helios).returns(decryptor)
		@repository.expects(:me_modifier).with(decryptor).returns(1)

	 	@repo.material_level(helios).should eq(-3)	
	end

	it 'should answer the correct material level for some cruisers' do
	 	@repo.material_level('Celestis').should eq(50)	
	 	@repo.material_level('Gila').should eq(0)	

		arazu = InvType.find_by_typeName('Arazu')
		decryptor = mock('decryptor')
		@strategy.expects(:decryptor).with(arazu).returns(decryptor)
		@repository.expects(:me_modifier).with(decryptor).returns(3)

	 	@repo.material_level(arazu).should eq(-1)	
	end

	it 'should answer the correct material level for some battleships' do
	 	@repo.material_level('Scorpion').should eq(60)	
	 	@repo.material_level('Rattlesnake').should eq(0)	

		widow = InvType.find_by_typeName('Widow')
		decryptor = mock('decryptor')
		@strategy.expects(:decryptor).with(widow).returns(decryptor)
		@repository.expects(:me_modifier).with(decryptor).returns(-2)

	 	@repo.material_level(widow).should eq(-6)	
	end

	it 'should answer the correct production level' do
	 	@repo.productivity_level('Merlin').should eq(15)	
	 	@repo.productivity_level('Worm').should eq(0)	

		helios = InvType.find_by_typeName('Helios')
		decryptor = mock('decryptor')
		@strategy.expects(:decryptor).with(helios).returns(decryptor)
		@repository.expects(:pe_modifier).with(decryptor).returns(4)

	 	@repo.productivity_level(helios).should eq(0)	
	end	
end