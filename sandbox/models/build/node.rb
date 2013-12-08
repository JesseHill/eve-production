class Node

	attr_accessor :name, :runs, :children, :data

	def initialize(name, runs = 1, children = [])
		@name = name
		@runs = Integer(runs)
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

	def each(direction = :top_down, &block)
		yield self if direction == :top_down
		@children.each { |c| c.each(&block) }
		yield self if direction == :bottom_up
	end

	def sort_by(&block)
		self.clone.tap { |copy|
			copy.data = @data.clone
			copy.children = @children.sort_by(&block)
		}
	end

end
