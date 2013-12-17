#!/usr/bin/env ruby

require 'optparse'
require 'ostruct'

require_relative '../config/active_record_config'
require_relative '../models/build/build'
require_relative '../models/build/job'
require_relative 'report_factory'

class BpcDumpOptionsParser

  @@columns = [:name, :group, :category, :copy, :material_level, :production_level, :runs]

  def self.create_job(info)
  	begin
      # puts "Creating job with #{info[:name]}, #{info[:runs]}, #{info[:material_level]}"
  		Job.new(
        info[:name], 
        info[:runs], 
        {
          material_level: info[:material_level], 
          production_level: info[:production_level]
        }
      )
  	rescue
  		puts "Error creating job for item: \"#{item}\" quantity: \"#{quantity}\""
  		exit
  	end
  end

  def self.aggregate_bpc_data(data)
    data.each_with_object({}) do |values, hash|
      key = "#{values[:name]}-#{values[:material_level]}-#{values[:production_level]}"
      if hash[key]
        hash[key][:runs] += values[:runs].to_i
      else
        hash[key] = {
          name: values[:name].chomp('Blueprint'),
          material_level: values[:material_level].to_i,
          production_level: values[:production_level].to_i,
          runs: values[:runs].to_i
        }
      end
    end
  end

  def self.build_jobs_from_file(file)
  	begin
  		bpc_data = File.readlines(file).map do |line|
        values = line.split(/[\t\n]+/)
        Hash[@@columns.zip(values)]
      end
      aggregate_bpc_data(bpc_data).map { |key, info| create_job(info) }
  	rescue
  		puts "\nError creating jobs from file: #{file}.\n"
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
