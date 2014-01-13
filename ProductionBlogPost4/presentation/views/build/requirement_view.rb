require_relative '../view'

class RequirementView < View

	attr_reader :quantity, :title, :per_unit, :total

	def initialize(options, quantity, name, costs)
		@template_folder = File.basename(File.dirname(__FILE__))
		super(options)
		@quantity = format_quantity(quantity)
		@title = name
		@per_unit = format_isk(costs[:per_unit])
		@total = format_isk(costs[:total])
	end

end