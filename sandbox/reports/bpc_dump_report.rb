#!/usr/bin/env ruby

require 'optparse'
require 'ostruct'

require_relative '../config/active_record_config'
require_relative '../models/build/build'
require_relative '../models/build/job'
require_relative 'report_factory'

class BpcDumpOptionsParser

  def self.create_job(item, quantity)
  	begin
  		Job.new(item.chomp('Blueprint'), quantity)
  	rescue
  		puts "Error creating job for item: \"#{item}\" quantity: \"#{quantity}\""
  		exit
  	end
  end

  def self.build_jobs_from_file(file)
  	begin
  		File.readlines(file).map { |line|
        values = line.split(/[\t\n]+/)
        [values[0], values[6]]
      }.each_with_object(Hash.new(0)) { |(item,runs), hash| 
        hash[item] += runs.to_i
      }.map { |item, runs|
        create_job(item, runs)
      }
  	rescue
  		puts "\nError reading jobs file.\n"
  		exit
  	end
  end

  def self.parse(args)
    options = OpenStruct.new
    options.jobs = []
    options.report_type = :manufacturing

    opt_parser = OptionParser.new do |opts|
      opts.banner = "Usage: bpc_dump_report.rb [options]"

      opts.on("-f", "--file BUILD_FILE", "Specify a file to load bpc information from.") do |file|
      	options.jobs.push *build_jobs_from_file(file)
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

ActiveRecordConfig.init
options = BpcDumpOptionsParser.parse(ARGV)
if options.jobs.empty?
	BpcDumpOptionsParser.parse(["-h"])
	exit
end
ReportFactory.create(options.report_type).run(Build.new("BPC Build", options.jobs), {print_shopping_list: true})
