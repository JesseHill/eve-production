require_relative 'view'
require_relative './build/build_view'

class ReportView < View

	attr_reader :build
	
	def initialize(build, options = {})
		super(options)
		@build = BuildView.new(build, options)
	end

	def title
		@build.title
	end
end