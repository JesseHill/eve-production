require_relative 'formatting'

class ConsoleSerializer
	include Formatting

	def write_banner(text, double_wide = false)
		width = double_wide ? 100 : 50;
		puts ""
		puts "-" * width
		puts text
		puts "-" * width
	end
	
	def write_line(text = "", level = 0)
		puts " " * level * 3 + text
	end

	def write_build(build, write_materials = false)
			# .select { |n| n.data[:marketable_profit_per_day] > 100000000 if n.data[:marketable_profit_per_day]}
	  		# .sort_by { |n| n.data[:production_time] }
		build
			.sort_by { |n| n.data[:profit_per_hour] }
			.each_with_depth do |node, depth| 
				write_banner(node.runs > 1 ? "#{node.name} - #{node.runs}" : node.name, depth == 0)
				if node.data[:invention_cost] > 0
					write_line "Material Cost: #{format_isk(node.data[:material_cost])}"
					write_line "Invention Cost: #{format_isk(node.data[:invention_cost])}"
					write_line "Total Cost: #{format_isk(node.data[:cost])}"
				else
					write_line "Cost: #{format_isk(node.data[:cost])}"
				end

				write_line "Cost per unit: #{format_isk(node.data[:cost_per_unit])}" if node.data[:cost_per_unit]
				write_line "Value: #{format_isk(node.data[:value])}"
				write_line "Value per unit: #{format_isk(node.data[:value_per_unit])}" if node.is_buildable?
				write_line "Profit: #{format_isk(node.data[:profit])}"
				write_line "Profit per unit: #{format_isk(node.data[:profit_per_unit])}" if node.is_buildable?
				write_line "Profit margin: #{(node.data[:profit_margin] * 100).round(2)} %"
				write_line "Production time: #{format_time(node.data[:production_time])}"
				write_line "Profit per hour: #{format_isk(node.data[:profit_per_hour])}"
				
				if node.data[:marketable_volume_per_day]
					write_line "Marketable volume per day : #{format_quantity(node.data[:marketable_volume_per_day])}"
					write_line "Marketable profit per day: #{format_isk(node.data[:marketable_profit_per_day])}"
					write_line "Marketable hourly profit: #{format_isk(node.data[:marketable_hourly_profit])}"
				end

	    	    if write_materials
		            write_line "Materials:"
		            costs = node.data[:material_costs]
		            node.data[:materials].each do |m, q|
	                per_unit = format_isk(costs[m][:per_unit])
	                total = format_isk(costs[m][:total]	)
	                write_line("#{format_quantity(q)} #{m.typeName} - per unit: #{per_unit} - total: #{total}", 1)
	            end
	        end
      end
  end

	def write_shopping_list(list, title = "Shopping List")
		write_banner title
		list.each_with_depth do |node, depth|
			if node.has_children? || depth == 0
				write_line
				write_line("#{node.name} - Volume: #{format_volume(node.volume)} Cost: #{format_isk(node.cost)}", depth)
			else
				write_line("#{format_quantity(node.quantity)} - #{node.name} - #{format_isk(node.cost_per_unit)} - #{format_isk(node.cost)}", depth)
			end	
		end
	end

	def write_retail_list(list, title = "Retail List")
		write_banner title
		list.each_with_depth do |node, depth|
			if node.has_children? || depth == 0
				write_line
				write_line("#{node.name} - Volume: #{format_volume(node.volume)} Value: #{format_isk(node.value)}", depth)
			else
				write_line("#{format_quantity(node.quantity)} - #{node.name} - #{format_isk(node.value_per_unit)} - #{format_isk(node.value)}", depth)
			end	
		end		
	end	

	def write_reprocessing_data(build)
		build
			.sort_by { |node| node.data[:reprocessing_profit_margin] }
			.each_with_depth do |node, depth| 
				write_banner(node.runs > 1 ? "#{node.name} - #{node.runs}" : node.name, depth == 0)
				write_line "Cost: #{format_isk(node.data[:reprocessing_cost])}"
				write_line "Value: #{format_isk(node.data[:reprocessing_value])}"
				write_line "Profit: #{format_isk(node.data[:reprocessing_profit])}"
				write_line "Profit Margin: #{(node.data[:reprocessing_profit_margin] * 100).round(2)} %"
      end
    end
end