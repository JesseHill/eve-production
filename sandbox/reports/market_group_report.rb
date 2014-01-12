#!/usr/bin/env ruby

require 'optparse'
require 'ostruct'

require_relative '../config/active_record_config'
require_relative '../models/build/build'
require_relative '../models/build/job'
require_relative 'report_factory'

class MarketGroupOptionsParser

  def self.parse(args)
    options = OpenStruct.new
    options.jobs = []
    options.report_type = :manufacturing

    opt_parser = OptionParser.new do |opts|
      opts.banner = "Usage: market_group_report.rb [options]"

      opts.on("-i", "--id MARKET_GROUP_ID", "Specify a market group id to use.") do |id|
      	options.marketGroupID = id
      end

      opts.on("-n", "--name NAME", "Specify a market group name.") do |name|
      	groups = InvMarketGroup.where(marketGroupName: name)
      	options.marketGroupID = groups.detect { |g| !g.description.include?('Blueprint')}.marketGroupID
      end

      opts.on("-r", "--report REPORT_TYPE", "Specify a report type to run.") do |report|
      	options.report_type = report.to_sym
      end      

      opts.on_tail("-h", "--help", "Show this message") do
        puts opts
        exit
      end
    end

    opt_parser.parse!(args)
    options
  end

end

class MarketGroupReport

	def initialize(marketGroupID, report_type)	
		group = InvMarketGroup.find_by_marketGroupID(marketGroupID)
		raise "No market group found for ID #{marketGroupID}" unless group

		group_ids = group.
		  leaf_groups.
		  map { |g| g.marketGroupID }

		jobs = InvType
			.where(marketGroupID: group_ids)
			.map { |f| Job.new(f.typeID, 1) }

		@build = Build.new(group.marketGroupName, 1, jobs)
		@report = ReportFactory.create(report_type)
	end

	def run()
		@report.run(@build, {print_shopping_list: true})		
	end
end

if !ARGV.empty?
	ActiveRecordConfig.init
	options = MarketGroupOptionsParser.parse(ARGV)
	if options.marketGroupID.nil?
		puts "Failed to find a market group matching #{ARGV}"
		MarketGroupOptionsParser.parse(["-h"])
		exit
	end
	MarketGroupReport.new(options.marketGroupID, options.report_type).run
end