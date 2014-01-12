#!/usr/bin/env ruby

require 'optparse'
require 'ostruct'

require_relative '../config/active_record_config'
require_relative '../models/build/build'
require_relative '../models/build/job'
require_relative 'report_factory'

class LineItemOptionsParser

  def self.create_job(item, quantity)
  	begin
  		Job.new(item, quantity)
  	rescue
  		puts "Error creating job for item: \"#{item}\" quantity: \"#{quantity}\""
  		exit
  	end
  end

  def self.build_jobs_from_file(file)
  	begin
  		text = File.read(file)
  	rescue
  		puts "\nError reading jobs file.\n"
  		exit
  	end
  	build_jobs_from_text(text)
  end

  def self.build_jobs_from_text(jobText)
  	begin
        pairs = jobText
          .lines
          .reject { |line| line.strip.empty? || line.strip.start_with?("#") }
          .map { |line| line.split(" - ")[0..1] }
  	rescue
  		puts "\nError parsing job text: \"#{jobText}\"\n"
  		exit
  	end
  	pairs.map { |quantity, item| create_job(item.strip, quantity.gsub(",", "").strip) }
  end

  def self.parse(args)
    options = OpenStruct.new
    options.jobs = []
    options.runs = 1
    options.report_type = :manufacturing

    opt_parser = OptionParser.new do |opts|
      opts.banner = "Usage: line_item_report.rb [options]"

      opts.on("-f", "--file BUILD_FILE", "Specify an item: quantity file to load jobs from") do |file|
      	options.jobs.push *build_jobs_from_file(file)
      end

      opts.on("-j", "--job \"item: quantity\"", "Specify an '\"item: quantity\"' job") do |jobText|
      	options.jobs.push *build_jobs_from_text(jobText)
      end

      opts.on("-r", "--runs RUNS", "Specify a number of runs.") do |runs|
        options.runs = runs.to_i
      end      

      opts.on("-t", "--type REPORT_TYPE", "Specify a report type to run.") do |report|
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

options = LineItemOptionsParser.parse(ARGV)

if options.jobs.empty?
	LineItemOptionsParser.parse(["-h"])
	exit
end

ReportFactory
  .create(options.report_type)
  .run(Build.new("Line Item Build", options.runs, options.jobs), {print_shopping_list: true})
