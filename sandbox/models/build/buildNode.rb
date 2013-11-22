class BuildNode
	
	def initialize(name, quantity)
		@name = name
		@quantity = quantity
		@items = []
	end

	def name
		@name
	end

	def items
		@items
	end

	def add(node)
		@items << node
	end

	def quantity
		@quantity
	end
end