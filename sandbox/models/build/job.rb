require_relative '../inv_type.rb'

class Job

	def initialize(key, quantity, waste_calculator)
		@item = key.is_a?(String) ? InvType.find_by_typeName(key) : InvType.find_by_typeID(key)
		if @item.nil?
			puts "Failed to find item: #{key}"
		end
		@quantity = quantity
		@waste_calculator = waste_calculator
		@materials = Hash.new(0)
		compute_materials_and_items()
	end

	def name
		@item.typeName
	end

	def portionSize
		@item.portionSize
	end

	def productionTime
		@item.inv_blueprint_type.productionTime * @quantity
	end

	def typeID
		@item.typeID
	end

	def materials
		@materials
	end

end