require_relative 'view'
require_relative './build/build_view'
require_relative './shopping/shopping_list_view'

class ReportView < View

	attr_reader :build, :shopping_list

	def initialize(build, shopping_list, options = {})
		super(options)
		@build = BuildView.new(build, options)
		@shopping_list = ShoppingListView.new(shopping_list, options)
	end

	def title
		@build.title
	end
end