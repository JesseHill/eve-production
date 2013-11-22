#!/usr/bin/ruby

require 'nokogiri'
require 'open-uri'
require './models/build/buildReport.rb'

class ConsoleSerializer

	def initialize(report, print_item_materials = true, print_consolidated_materials = true)
		@report = report
		@print_item_materials = print_item_materials
		@print_consolidated_materials = print_consolidated_materials
	end

	def write()
		puts "-" * 50
		puts @report.name
		puts "-" * 50
		@report.items.each {|build|
			print "\nItem: #{build.name} quantity: #{build.quantity}"
			if build.is_a? LineItemReport
				print " value per unit: #{build.value_per_unit}"
			end
			puts

			if @print_item_materials
				build.materials.each {|typeID, quantity|
					type = InvType.find_by_typeID(typeID)
					price = @report.pricing_model.buy_price(typeID)
					puts "\t #{quantity} #{type.typeName} at #{price.round(2)} = #{(quantity * price).round(2)}"
				}
			end
			puts "Build cost: #{build.cost.round(2)} value: #{build.value.round(2)} profit: #{build.profit.round(2)} profit_margin: #{build.profit_margin} profit per production time unit: #{build.profit_per_production_time.round(2)}"
			# puts "Profit margin: #{((build.value / build.cost - 1) * 100).round(2)} % on #{build.yield} items	"
		}

		puts "\n\nTotal build cost: #{@report.cost.round(2)} value: #{@report.value.round(2)} profit: #{@report.profit.round(2)} profit per production time unit: #{@report.profit_per_production_time.round(2)}"
		puts "Total profit margin: #{@report.profit_margin} %\n\n"
		if @print_consolidated_materials
			puts "-" * 50
			puts "Shopping list"
			puts "-" * 50
			@report.materials.each {|typeID, quantity|
				type = InvType.find_by_typeID(typeID)
				price = @report.pricing_model.buy_price(typeID)
				puts "\t #{quantity} #{type.typeName} at #{price.round(2)} = #{(quantity * price).round(2)}"
			}

		end		
	end
end




