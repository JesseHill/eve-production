class Node

	attr_accessor :name, :runs, :children, :data

	def initialize(name, runs = 1, children = [])
		@name = name
		@runs = runs
		@children = children
		@data = {}
	end

	def is_buildable?
		false
	end	

	def accept(visitor)
		self.clone.tap { |copy|
			copy.data = @data.clone
			copy.children = @children.map { |c| c.accept(visitor) }
			visitor.visit(copy)
		}
	end

	def each(&block)
		@children.each { |c| c.each(&block) }
		yield self
	end

	def sort_by(&block)
		self.clone.tap { |copy|
			copy.data = @data.clone
			copy.children = @children.sort_by(&block)
		}
	end

end
