#!/usr/bin/env ruby

require_relative 'manufacturing_report'
require_relative '../models/build/build'
require_relative '../models/build/job'

class MarketGroupReport

	def initialize(marketGroupID)
		@report = ManufacturingReport.new

		group = InvMarketGroup.find_by_marketGroupID(marketGroupID)

		raise "No market group found for ID #{marketGroupID}" unless group

		group_ids = group.
		  leaf_groups.
		  map { |g| g.marketGroupID }

		jobs = InvType.
			where(marketGroupID: group_ids).
			map { |f|
			  Job.new(f.typeID, 1)
			}

		@build = Build.new(group.marketGroupName, jobs)
	end

	def run()
		@report.run(@build, false)		
	end
end

if !ARGV.empty?
	MarketGroupReport.new(ARGV[0]).run
end