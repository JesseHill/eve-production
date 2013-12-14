require_relative '../../spec_helper'
require_relative '../../../models/build/decryptor_repository'

describe DecryptorRepository do
	before :each do
	    @repo = DecryptorRepository.new
	end

	it 'should answer the probability multiplier for different types' do
	 	@repo.probability_multiplier(InvType.find_by_typeName('Occult Augmentation')).should eq(0.6)	
	 	@repo.probability_multiplier(InvType.find_by_typeName('Optimized Esoteric Augmentation')).should eq(0.9)	
	 	@repo.probability_multiplier(InvType.find_by_typeName('Incognito Symmetry')).should eq(1.0)	
	 	@repo.probability_multiplier(InvType.find_by_typeName('Cryptic Process')).should eq(1.1)	
	 	@repo.probability_multiplier(InvType.find_by_typeName('Occult Accelerant')).should eq(1.2)	
	 	@repo.probability_multiplier(InvType.find_by_typeName('Esoteric Parity')).should eq(1.5)	
	 	@repo.probability_multiplier(InvType.find_by_typeName('Incognito Attainment')).should eq(1.8)	
	 	@repo.probability_multiplier(InvType.find_by_typeName('Optimized Cryptic Attainment')).should eq(1.9)	
	end

	it 'should answer the right decryptor for different types' do
	 	@repo.find(InvType.find_by_typeName('Crow'), :symmetry)
	 		.should eq(InvType.find_by_typeName('Esoteric Symmetry'))	
	 	@repo.find(InvType.find_by_typeName('Arazu'), :process)
	 		.should eq(InvType.find_by_typeName('Incognito Process'))	
	 	@repo.find(InvType.find_by_typeName('Pilgrim'), :attainment)
	 		.should eq(InvType.find_by_typeName('Occult Attainment'))	
	 	@repo.find(InvType.find_by_typeName('Rapier'), :augmentation)
	 		.should eq(InvType.find_by_typeName('Cryptic Augmentation'))	
	end	

end