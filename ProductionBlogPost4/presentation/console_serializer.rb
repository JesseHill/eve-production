require_relative './views/report_view'

class ConsoleSerializer

	def write(build, options = {})
		puts ReportView.new(build, options).render
	end

end