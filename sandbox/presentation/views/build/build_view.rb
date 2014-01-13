require_relative 'node_view'

class BuildView < NodeView

	attr_reader :children

	def initialize(node, options = {})
		super(node, options)
		@children =	@node.children.map do |node|
			view_name = "#{node.class.name.underscore}_view"
			require_relative(view_name)
			classify(view_name).constantize.new(node, @options)
		end
	end

end