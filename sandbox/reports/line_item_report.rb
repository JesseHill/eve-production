#!/usr/bin/ruby

require_relative 'manufacturing_report'
require_relative '../models/build/build'
require_relative '../models/build/job'
require 'optparse'
require 'ostruct'
require 'pp'

class LineItemOptionsParser

  def self.create_job(item, quantity)
  	begin
  		Job.new(item, quantity)
  	rescue
  		puts "Error creating job for item: \"#{item}\" quantity: \"#{quantity}\""
  		exit
  	end
  end

  def self.parse(args)
    options = OpenStruct.new
    options.jobs = []

    opt_parser = OptionParser.new do |opts|
      opts.banner = "Usage: line_item_report.rb [options]"

      opts.on("-f", "--file BUILD_FILE", "Specify an item: quantity file to load jobs from") do |file|
      	begin
      		text = File.read(file)
	      	pairs = Hash[*text.split(/[:\n]+/)]
		rescue
			puts
			puts "Error reading jobs file."
			puts
			exit
		end
      	pairs.each { |k, v|
      		options.jobs << create_job(k, v)
      	}
      end

      opts.on("-j", "--job \"item: quantity\"", "Specify an '\"item: quantity\"' job") do |jobText|
      	begin
	      	pairs = Hash[*jobText.split(/[:\n]+/)]
		rescue
			puts
			puts "Error parsing job text: \"#{jobText}\""
			puts
			puts opts.help
			exit
		end
      	pairs.each { |k, v|
      		options.jobs << create_job(k, v)
      	}

      end

      # No argument, shows at tail.  This will print an options summary.
      opts.on_tail("-h", "--help", "Show this message") do
        puts opts
        exit
      end
    end

    opt_parser.parse!(args)
    options
  end

end

report = ManufacturingReport.new
options = LineItemOptionsParser.parse(ARGV)

if options.jobs.empty?
	LineItemOptionsParser.parse(["-h"])
	exit
end

report.run(Build.new("Line Item Build", options.jobs))
