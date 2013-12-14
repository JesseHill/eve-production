
class InventionStrategy

	attr_reader :encryption_skill, :data_skill_one, :data_skill_two

	def initialize(decryptor_strategy = nil, techI_strategy = nil, encryption_skill = 4, data_skill_one = 4, data_skill_two = 4)
		@decryptor_strategy = decryptor_strategy
		@techI_strategy = techI_strategy
		@encryption_skill = encryption_skill
		@data_skill_one = data_skill_one
		@data_skill_two = data_skill_two
	end

	def decryptor(item)
		return nil unless @decryptor_strategy
		@decryptor_strategy.decryptor(item)
	end

	def techI_item(item)
		return nil unless @techI_strategy
		@techI_strategy.techI_item(item)
	end

	def techI_item_meta_level(item)
		return 0 unless @techI_strategy
		@techI_strategy.techI_item_meta_level(item)
	end

end