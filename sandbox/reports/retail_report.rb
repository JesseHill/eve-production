#!/usr/bin/env ruby

require 'optparse'
require 'ostruct'

require_relative '../config/active_record_config'
require_relative '../models/build/build'
require_relative '../models/build/job'
require_relative '../models/pricing/retail_markets'
require_relative 'report_factory'

class RetailOptionsParser

  @@columns = [:name, :quantity, :group, :size, :slot, :volume]

  def self.aggregate_item_data(data)
    data.each_with_object(Hash.new(0)) do |values, hash|
      type = InvType.find_by_typeName(values[:name])
      hash[type] += values[:quantity].to_i
    end
  end

  def self.build_items_from_file(file)
  	begin
  		item_data = File.readlines(file).map do |line|
        values = line.split(/[\t\n]+/)
        Hash[@@columns.zip(values)]
      end
      aggregate_item_data(item_data)
  	rescue
  		puts "\nError creating items from file: #{file}.\n"
  		exit
  	end
  end

  def self.parse(args)
    options = OpenStruct.new
    options.items = []
    options.report_type = :retail

    opt_parser = OptionParser.new do |opts|
      opts.banner = "Usage: retail_report.rb [options]"

      opts.on("-f", "--file ITEM_FILE", "Specify a file to load item information from.") do |file|
      	options.items.push *build_items_from_file(file)
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
options = RetailOptionsParser.parse(ARGV)
if options.items.empty?
	RetailOptionsParser.parse(["-h"])
	exit
end

pricing = CompositePricingModel.new(
  RetailMarkets.new.markets.map { |m|
    PersistentPricingModel.new(LowSellOrdersPricingModel.new(m))
  }
)
shopping_list = ShoppingList.new(pricing, options.items, :sell)
ConsoleSerializer.new.write_retail_list(shopping_list)