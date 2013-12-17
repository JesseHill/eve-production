require_relative 'node'

class Build < Node

	def initialize(name, children = [], options = {})
		super(name, 1, children, options)
	end
end