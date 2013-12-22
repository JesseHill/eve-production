require_relative 'manufacturing_report'
require_relative 'reprocessing_report'

class ReportFactory

	@@report_types = {
		manufacturing: ManufacturingReport,
		reprocessing: ReprocessingReport
	}		

	def self.create(report_type)
    raise "Unsupported report type: #{report_type}" unless @@report_types.has_key? report_type
		@@report_types[report_type].send(:new)
	end

end