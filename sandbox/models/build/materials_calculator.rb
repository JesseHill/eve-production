require_relative 'waste_calculator'

class MaterialsCalculator

	def initialize(waste_calculator)
		@waste_calculator = waste_calculator
	end

	def visit(node)
		if node.is_buildable?
			node.data[:materials] = required_materials(node.blueprint, node.runs)
		else
			node.data[:materials] = node.children.each_with_object({}) { |n, h|
				h.merge!(n.data[:materials]) { |k, l, r| l + r }
			}
		end
	end	

	def required_materials(blueprint, runs)
		inv_type = blueprint.inv_type
		ram_requirements = inv_type.
			ram_type_requirements_for_manufacturing.
			reject { |r| r.required_type.is_skill? }

		materials = Hash[inv_type.inv_type_materials. # Create a hash of [type: quantity] from the following ...
			each_with_object({}) { |m, h| h[m.required_type] = m.quantity }. # collect base materials
			merge(recyleable_requirements(ram_requirements)) { |k, l, r| l - r }. # remove recycleable materials
			select { |k, v| v > 0 }. # remove empty elements
			map { |type, quantity| # Adjust for waste and number of runs
				[type, @waste_calculator.calculate_required_quantity(inv_type, quantity) * runs]
			}]

		# Now add in ram requirements (extra materials) which are not skills
		# Apply production efficienty waste to materials which are already in the base material list.
		ram_requirements.
			each_with_object({}) { |r, h| h[r.required_type] = r.quantity * runs }.
			merge(materials) { |k, l, r| l + @waste_calculator.production_waste(l) + r }
	end

	def recyleable_requirements(ram_requirements)
		ram_requirements.
			select { |requirement| requirement.recycle? }.
			each_with_object({}) { |requirement, requirements| 
				materials = requirement.required_type.inv_type_materials.
					each_with_object({}) { |m, materials|
						materials[m.required_type] = m.quantity * requirement.quantity
					}
				requirements.merge!(materials) { |k, l, r| l + r }
			}
	end
end	