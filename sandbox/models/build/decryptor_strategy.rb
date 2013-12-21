class DecryptorStrategy

	def initialize(repo)
		@repo = repo
	end

	def decryptor(item, options = {})
		if item.in_market_group?(:frigates)
			return @repo.find(item, :symmetry)
			# return @repo.find(item, :symmetry) if options[:material_level] == -3
			# return nil
		end
		return @repo.find(item, :process) if item.in_market_group?(:ships)
		nil
	end
end