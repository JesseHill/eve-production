require_relative 'manufacturing_report'
require_relative 'reprocessing_report'

class ReportFactory

	def self.create(report_type)
		@report_types = {
			manufacturing: ManufacturingReport.new,
			reprocessing: ReprocessingReport.new
		}		

		@report_types[report_type]	
	end
end