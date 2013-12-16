require_relative 'formatting'

class ConsoleSerializer

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
		build.
			sort_by { |node| node.data[:profit_margin] }.
			each_with_depth { |node, depth| 
				write_banner(node.runs > 1 ? "#{node.name} - #{node.runs}" : node.name, depth == 0)
				if node.data[:invention_cost] > 0
					write_line "Material Cost: #{Formatting.format_isk(node.data[:material_cost])}"
					write_line "Invention Cost: #{Formatting.format_isk(node.data[:invention_cost])}"
					write_line "Total Cost: #{Formatting.format_isk(node.data[:cost])}"
				else
					write_line "Cost: #{Formatting.format_isk(node.data[:cost])}"
				end
				write_line "Value: #{Formatting.format_isk(node.data[:value])}"
				write_line "Value Per Unit: #{Formatting.format_isk(node.data[:value_per_unit])}" if node.is_buildable?
				write_line "Profit: #{Formatting.format_isk(node.data[:profit])}"
				write_line "Profit Per Unit: #{Formatting.format_isk(node.data[:profit_per_unit])}" if node.is_buildable?
				write_line "Profit Margin: #{(node.data[:profit_margin] * 100).round(2)} %"

                if write_materials
                    write_line "Materials:"
                    costs = node.data[:material_costs]
                    node.data[:materials].each { |m, q|
                        per_unit = Formatting.format_isk(costs[m][:per_unit])
                        total = Formatting.format_isk(costs[m][:total])
                        write_line("#{Formatting.format_quantity(q)} #{m.typeName} - per unit: #{per_unit} - total: #{total}", 1)
                    }
                end
            }
    end

	def write_shopping_list(list)
		write_banner "Shopping List:"
		list.each_with_depth { |node, depth|
			if node.has_children?
				write_line
				write_line("#{node.name} - Volume: #{Formatting.format_volume(node.volume)} Cost: #{Formatting.format_isk(node.cost)}", depth)
			else
				write_line("#{Formatting.format_quantity(node.quantity)} - #{node.name} - #{Formatting.format_isk(node.cost_per_unit)} - #{Formatting.format_isk(node.cost)}", depth)
			end	
		}			
	end

	def write_reprocessing_data(build)
		build.
			sort_by { |node| node.data[:reprocessing_profit_margin] }.
			each_with_depth { |node, depth| 
				write_banner(node.runs > 1 ? "#{node.name} - #{node.runs}" : node.name, depth == 0)
				write_line "Cost: #{Formatting.format_isk(node.data[:reprocessing_cost])}"
				write_line "Value: #{Formatting.format_isk(node.data[:reprocessing_value])}"
				write_line "Profit: #{Formatting.format_isk(node.data[:reprocessing_profit])}"
				write_line "Profit Margin: #{(node.data[:reprocessing_profit_margin] * 100).round(2)} %"
            }
    end
end




