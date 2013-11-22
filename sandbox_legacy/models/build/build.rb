require './models/build/buildNode.rb'

class Build < BuildNode

	def initialize(name, quantity = 1)
		super(name, quantity)
	end

end