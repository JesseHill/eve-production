require_relative "decryptor_repository"

class DecryptorStrategy

	def initialize(repo = DecryptorRepository.new)
		@repo = repo
	end

	def decryptor(item, options = {})
		return nil unless item.in_market_group? :ships
		if item.in_market_group? :frigates
			return @repo.find(item, :symmetry)
			# return @repo.find(item, :symmetry) if options[:material_level] == -3
			# return nil
		end
		@repo.find(item, :process)
	end
end