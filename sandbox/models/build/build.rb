require_relative 'node'

class Build < Node

	def initialize(name, runs = 1, children = [], options = {})
		super(name, runs, children, options)
	end
  
end