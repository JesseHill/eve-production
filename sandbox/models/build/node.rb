class Node

	attr_accessor :name, :runs, :children, :data, :options

	def initialize(name, runs = 1, children = [], options = {})
		@name = name
		@runs = Integer(runs)
		@children = children
		@options = options
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

	def each_with_depth(depth = 0, direction = :top_down, &block)
		yield(self, depth) if direction == :top_down
		@children.each { |c| c.each_with_depth(depth + 1, direction, &block) } if @children
		yield(self, depth) if direction == :bottom_up
	end	

	def sort_by(&block)
		self.clone.tap { |copy|
			copy.data = @data.clone
			copy.children = @children.sort_by(&block)
		}
	end

end
