class DecryptorStrategy

	def initialize(repo)
		@repo = repo
	end

	def decryptor(item)
		return nil if item.in_market_group?(:frigates)
		# return @repo.find(item, :symmetry) if item.in_market_group?(:frigates)
		return @repo.find(item, :process) if item.in_market_group?(:ships)
		nil
	end
end