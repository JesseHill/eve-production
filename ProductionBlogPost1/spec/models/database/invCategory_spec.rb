require 'spec_helper'
require './models/database/invCategory.rb'

describe InvCategory do

	it 'should answer the correct name for a category id' do
		# category ID 16 == Skill
		category = InvCategory.find_by(categoryID: 16)
		category.categoryName.should eq('Skill')
	end

	it 'should answer whether or not the category is a skill' do
		# category ID 16 == Skill
		category = InvCategory.find_by(categoryID: 16)
		category.is_skill?.should be_true

		# category ID 9 == Blueprint
		category = InvCategory.find_by(categoryID: 9)
		category.is_skill?.should be_false
	end

end