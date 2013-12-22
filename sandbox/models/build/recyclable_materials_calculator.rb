require_relative 'waste_calculator'

class RecyclableMaterialsCalculator

	def visit(node)
		if node.is_buildable?
			node.data[:recyclable_materials] = recylable_materials(node.blueprint, node.runs)
		else
			node.data[:recyclable_materials] = node.children.each_with_object({}) do |n, h|
				h.merge!(n.data[:recyclable_materials]) { |k, l, r| l + r }
			end
		end
	end	

	def recylable_materials(blueprint, runs)
		blueprint.inv_type.inv_type_materials.each_with_object({}) do |m, h|
			h[m.required_type] = m.quantity * runs 
		end
	end

end	