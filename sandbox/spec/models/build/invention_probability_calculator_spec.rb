require_relative '../../spec_helper'
require_relative '../../../models/database/inv_type'
require_relative '../../../models/build/decryptor_repository'
require_relative '../../../models/build/invention_probability_calculator'

describe InventionProbabilityCalculator do
	
	before :each do
		@strategy = mock('Invention Strategy')
		@repo = DecryptorRepository.new
	    @calc = InventionProbabilityCalculator.new(@strategy, @repo)
	end

	it 'should answer the correct base chance of invention' do
		@calc.base_chance(InvType.find_by_typeName('Warp Scrambler II')).should eq(0.4)
		@calc.base_chance(InvType.find_by_typeName('Helios')).should eq(0.3)
		@calc.base_chance(InvType.find_by_typeName('Arazu')).should eq(0.25)
		@calc.base_chance(InvType.find_by_typeName('Golem')).should eq(0.2)
	end

	it 'should answer the correct chance of invention for a base invention' do
		@strategy.expects(:encryption_skill).returns(4).once()
		@strategy.expects(:data_skill_one).returns(4).once()
		@strategy.expects(:data_skill_two).returns(4).once()
		@strategy.expects(:techI_item_meta_level).returns(0)
		@strategy.expects(:decryptor).returns(nil)

		item = InvType.find_by_typeName('Helios')
		@calc.chance(item).should be_within(0.0001).of(0.3619)
	end

	it 'should answer the correct chance of invention using bad encyrption skills' do
		@strategy.expects(:encryption_skill).returns(1).once()
		@strategy.expects(:data_skill_one).returns(4).once()
		@strategy.expects(:data_skill_two).returns(4).once()
		@strategy.expects(:techI_item_meta_level).returns(0)
		@strategy.expects(:decryptor).returns(nil)

		item = InvType.find_by_typeName('Helios')
		@calc.chance(item).should be_within(0.0001).of(0.3514)
	end	

	it 'should answer the correct chance of invention using bad data skills' do
		@strategy.expects(:encryption_skill).returns(4).once()
		@strategy.expects(:data_skill_one).returns(1).once()
		@strategy.expects(:data_skill_two).returns(1).once()
		@strategy.expects(:techI_item_meta_level).returns(0)
		@strategy.expects(:decryptor).returns(nil)

		item = InvType.find_by_typeName('Helios')
		@calc.chance(item).should be_within(0.0001).of(0.3244)
	end		

	it 'should answer the correct chance of invention using a decryptor' do
		@strategy.expects(:encryption_skill).returns(4).once()
		@strategy.expects(:data_skill_one).returns(4).once()
		@strategy.expects(:data_skill_two).returns(4).once()
		@strategy.expects(:techI_item_meta_level).returns(0)
		@strategy.expects(:decryptor).returns(InvType.find_by_typeName("Incognito Process"))

		item = InvType.find_by_typeName('Helios')
		@calc.chance(item).should be_within(0.0001).of(0.3981)
	end

	it 'should answer the correct chance of invention using a meta item' do
		@strategy.expects(:encryption_skill).returns(4).once()
		@strategy.expects(:data_skill_one).returns(4).once()
		@strategy.expects(:data_skill_two).returns(4).once()
		@strategy.expects(:techI_item_meta_level).returns(4)
		@strategy.expects(:decryptor).returns(nil)

		item = InvType.find_by_typeName('Warp Scrambler II')
		@calc.chance(item).should be_within(0.0001).of(0.7488)
	end

end