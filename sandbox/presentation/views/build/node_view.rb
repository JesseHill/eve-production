require_relative "../view"

class NodeView < View

	def initialize(node, options = {})
		@template_folder = File.basename(File.dirname(__FILE__))
		super(options)
		@node = node
	end

	def title
		@node.name
	end

	def cost
		format_isk(@node.data[:cost])
	end

	def value
		format_isk(@node.data[:value])
	end

	def profit
		format_isk(@node.data[:profit])
	end

	def profit_margin
		"#{(@node.data[:profit_margin] * 100).round(2)}%"
	end

	def production_time
		format_time(@node.data[:production_time])
	end

	def profit_per_hour
		format_isk(@node.data[:profit_per_hour])
	end

	def runs
		@node.runs
	end
end