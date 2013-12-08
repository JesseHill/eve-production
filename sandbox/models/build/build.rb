require_relative 'node'

class Build < Node

	def initialize(name, children = [])
		super(name, 1, children)
	end
end