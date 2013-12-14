class DecryptorStrategy

	def initialize(repo)
		@repo = repo
	end

	def decryptor(item)
		return @repo.find(item, :symmetry) if item.in_market_group?(:frigates)
		return @repo.find(item, :process) if item.in_market_group?(:cruisers)
		nil
	end
end