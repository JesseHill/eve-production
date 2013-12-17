require_relative '../database/inv_type'
require_relative 'node'

class Job < Node
	
	attr_reader :item

	def initialize(key, runs, options = {})
		@item = key.is_a?(String) ? InvType.find_by_typeName(key) : InvType.find_by_typeID(key)
		raise "Failed to find item: #{key}" if @item.nil?
		
		super(@item.typeName, runs, [], options)
	end

	def portionSize
		@item.portionSize
	end

	def typeID
		@item.typeID
	end

	def is_buildable?
		blueprint
	end

	def blueprint
		@item.inv_blueprint_type
	end

end