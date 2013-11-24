require_relative 'waste_calculator'

class MaterialsCalculator

	def initialize(waste_calculator)
		@waste_calculator = waste_calculator;
	end

	def required_materials(blueprint, runs)
		materials = Hash.new(0)
		inv_type = blueprint.inv_type
		ram_requirements = inv_type.ram_type_requirements_for_manufacturing

		# Start by collecting all the 'base' materials
		inv_type.inv_type_materials.each { |m| materials[m.required_type.typeID] = m.quantity }

		# Remove recyleable materials, don't ask me why the BPO requirements are set up this way, but they are.
		remove_recyleable_ram_requirements(materials, ram_requirements)

		# Now adjust for waste and quantity
		materials.each { |typeID, quantity|
			materials[typeID] = @waste_calculator.calculate_required_quantity(inv_type, quantity) * runs
		}

		# Now add in ram requirements (extra materials) which are not skills
		# Apply production efficienty waste to materials which are already in the base material list.
		ram_requirements.each { |ram_requirement|
			next if ram_requirement.required_type.is_skill?
			requiredQuantity = ram_requirement.quantity * runs
			if materials.has_key?(ram_requirement.required_type.typeID)
				materials[ram_requirement.required_type.typeID] = materials[ram_requirement.required_type.typeID] + 
					requiredQuantity +
					@waste_calculator.production_waste(requiredQuantity)
			else
				materials[ram_requirement.required_type.typeID] = requiredQuantity
			end
		}

		materials
	end

	def remove_recyleable_ram_requirements(materials, ram_requirements)
		ram_requirements.each {|ram_requirement|
			next if ram_requirement.required_type.is_skill?
			remove_materials(materials, ram_requirement) if ram_requirement.recycle?
		}
	end

	def remove_materials(materials, ram_requirement)
		ram_requirement.required_type.inv_type_materials.each {|m|
			materials[m.required_type.typeID] -= m.quantity
			materials.delete(m.required_type.typeID) if materials[m.required_type.typeID] <= 0
		}
	end
end	