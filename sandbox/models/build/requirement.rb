class Requirement

	attr_accessor :inv_type, :quantity

	def initialize(inv_type, quantity)
		@inv_type = inv_type
		@quantity = quantity
	end

end
