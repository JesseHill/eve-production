require_relative './views/report_view'

class ReportSerializer

	def write(build, shopping_list, options = {})
		puts ReportView.new(build, shopping_list, options).render
	end

end