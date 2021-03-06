require_relative "../view"

class ShoppingNodeView < View

	attr_reader :children

	def initialize(node, options = {})
		@template_folder = File.basename(File.dirname(__FILE__))
		super(options)
		@node = node
		if @node.has_children?
			@children =	@node.children.map do |node|
				view_name = "#{node.class.name.underscore}_view"
				require_relative(view_name)
				classify(view_name).constantize.new(node, @options)
			end
		end
	end	

	def template_folder
		"shopping"
	end

	def title
		@node.name
	end

	def volume
		format_volume(@node.volume)
	end

	def quantity
		format_quantity(@node.quantity)
	end

	def cost
		format_isk(@node.cost)
	end

	def cost_per_unit
		format_isk(@node.cost_per_unit)
	end

end
