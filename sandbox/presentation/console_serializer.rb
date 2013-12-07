#!/usr/bin/ruby

require 'nokogiri'
require 'open-uri'
require 'money'
require_relative '../models/build/build'

class ConsoleSerializer

	def initialize(build, markets)
		@build = build
		@shopping_list = ShoppingList.new(markets, @build.data[:materials])
	end

	def format_isk(value)
		Money.new(value * 100).format(:symbol => "ISK", :symbol_position => :after)
	end

	def format_volume(value)
		Money.new(value.ceil * 100).format(:symbol => "m3", :symbol_position => :after)
	end

	def write_banner(text)
		puts ""
		puts "-" * 50
		puts text
		puts "-" * 50
	end
	
	def write_line(text = "", level = 0)
		puts " " * level * 3 + text
	end

	def write()
		@build.
			sort_by { |node| node.data[:profit_margin] }.
			each(:top_down) { |node| 
				write_banner(node.runs > 1 ? "#{node.name} - #{node.runs}" : node.name)
				write_line "Cost: #{format_isk(node.data[:material_cost])}"
				write_line "Value: #{format_isk(node.data[:value])}"
				write_line "Value Per Unit: #{format_isk(node.data[:value_per_unit])}" if node.is_buildable?
				write_line "Profit: #{format_isk(node.data[:profit])}"
				write_line "Profit Margin: #{(node.data[:profit_margin] * 100).round(2)} %"
				# write_line "Materials:"
				# costs = node.data[:material_costs]
				# node.data[:materials].each { |m, q|
				# 	per_unit = format_isk(costs[m][:per_unit])
				# 	total = format_isk(costs[m][:total] * 100)
				# 	write_line "\t#{q} #{m.typeName} - per unit: #{per_unit} - total: #{total}"
				# }
			}	

		write_banner "Shopping List:"
		@shopping_list.each_with_depth { |node, depth|
			if node.has_children?
				write_line("#{node.name} - Volume: #{format_volume(node.volume)} Cost: #{format_isk(node.cost)}", depth)
			else
				write_line("#{node.name} - #{node.quantity} - #{format_isk(node.cost_per_unit)} - #{format_isk(node.cost)}", depth)
			end	
		}			
	end
end




