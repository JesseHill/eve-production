

class MaterialsVisitor

	def initialize(waste_calculator)
		@waste_calculator = waste_calculator
	end

	def apply(node)
		if node.is_buildable?
			node.data[:materials] = @waste_calculator.required_materials(node.blueprint, node.runs)
		else
			node.data[:materials] = node.children.each_with_object({}) { |n, h|
				h.merge!(n.materials) { |k, l, r| l + r }
			}
		end
	end

end
