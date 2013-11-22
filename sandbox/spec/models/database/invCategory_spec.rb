require 'spec_helper'
require './models/database/invCategory.rb'

describe InvCategory do

	it 'should answer the correct name for a category id' do
		# category ID 16 == Skill
		category = InvCategory.find_by(categoryID: 16)
		category.categoryName.should eq('Skill')
	end

end