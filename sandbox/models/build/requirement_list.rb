require_relative 'requirement'

class RequirementList

	def initialize
		@requirements = Hash.new
	end

	def add_inv_type_materials(materials)
		materials.each { |m| 
			requirements[m.required_type.typeID] = Requirement.new(m.required_type, m.quantity)
		}
	end

end
