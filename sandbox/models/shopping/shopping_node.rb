class ShoppingNode

	attr_accessor :name, :children, :volume, :cost

	def initialize(name, pricing)
		@name = name
		@pricing = pricing
		compute_volume
		compute_cost
		sort_children
	end

	def sort_children
		@children = @children.sort_by { |m| m.name} if @children
	end

	def has_children?
		@children && !@children.empty?
	end

	def compute_volume
		@volume = @children.reduce(0) { |memo, node| memo + node.volume }
	end

	def compute_cost
		@cost = @children.reduce(0) { |memo, node| memo + node.cost }
	end

	def each(direction = :top_down, &block)
		yield self if direction == :top_down
		@children.each { |c| c.each(&block) } if @children
		yield self if direction == :bottom_up
	end

	def each_with_depth(depth = 0, direction = :top_down, &block)
		yield(self, depth) if direction == :top_down
		@children.each { |c| c.each_with_depth(depth + 1, direction, &block) } if @children
		yield(self, depth) if direction == :bottom_up
	end
end
