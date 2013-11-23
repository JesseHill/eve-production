require_relative 'waste_calculator'

class MaterialsCalculator

	def compute_materials_and_items
		# Start by collecting all the 'base' materials
		@item.inv_type_materials.collect {|m|
			@materials[m.required_type.typeID] = m.quantity
		}

		# Remove recyled materials
		ramRequirements = @item.ram_type_requirements_for_manufacturing
		ramRequirements.each {|ramRequirement|
			next if ramRequirement.required_type.is_skill?
			if ramRequirement.recycle?
				remove_materials(ramRequirement.required_type)
			end
		}

		# Now adjust for waste and quantity
		@materials.each {|typeID,quantity|
			@materials[typeID] = @waste_calculator.calculate_required_quantity(@item, quantity) * @quantity
			type = InvType.find_by_typeID(typeID)
		}

		# Now add in ram requirements (extra materials) which are not skills
		# Apply production efficienty waste to materials which are already in the base material list.
		ramRequirements.each {|ramRequirement|
			next if ramRequirement.required_type.is_skill?
			requiredQuantity = ramRequirement.quantity * @quantity
			if @materials.has_key?(ramRequirement.required_type.typeID)
				@materials[ramRequirement.required_type.typeID] = @materials[ramRequirement.required_type.typeID] + 
				requiredQuantity +
				@waste_calculator.production_waste(requiredQuantity)
			else
				@materials[ramRequirement.required_type.typeID] = requiredQuantity
			end
		}
	end

	def remove_materials(item)
		item.inv_type_materials.each {|m|
			@materials[m.required_type.typeID] -= m.quantity
			if @materials[m.required_type.typeID] <= 0
				@materials.delete(m.required_type.typeID)
			end
		}
	end
end	