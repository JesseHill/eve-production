#!/usr/bin/ruby

require 'nokogiri'
require 'open-uri'
require 'money'
require_relative '../models/build/build'

class ConsoleSerializer

	def initialize(build)
		@build = build
	end

	def format_isk(value)
		Money.new(value * 100).format(:symbol => "ISK", :symbol_position => :after)
	end

	def write()
		@build.
			sort_by { |node| node.data[:profit_margin] }.
			each { |node| 
				puts ""
				puts "-" * 50
				puts "#{node.name} - #{node.runs}"
				puts "-" * 50
				puts "Cost: #{format_isk(node.data[:material_cost])}"
				puts "Value: #{format_isk(node.data[:value])}"
				puts "Profit: #{format_isk(node.data[:profit])}"
				puts "Profit Margin: #{(node.data[:profit_margin] * 100).round(2)} %"
				puts "Materials:"
				costs = node.data[:material_costs]
				node.data[:materials].each { |m, q|
					per_unit = format_isk(costs[m][:per_unit])
					total = format_isk(costs[m][:total])
					puts "\t#{q} #{m.typeName} - per unit: #{per_unit} - total: #{total}"
				}
			}	
	end
end




