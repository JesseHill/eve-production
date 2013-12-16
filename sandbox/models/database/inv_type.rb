require_relative 'dgm_type_attributes'
require_relative 'inv_blueprint_type'
require_relative 'inv_type_material'
require_relative 'inv_group'
require_relative 'inv_meta_group'
require_relative 'inv_meta_type'
require_relative 'inv_market_group'
require_relative 'ram_type_requirement'

class InvType < ActiveRecord::Base
	self.table_name = "invTypes"
	self.primary_key = "typeID"
	
	has_one :inv_blueprint_type, :foreign_key => 'productTypeID'
	has_one :inv_meta_type, :foreign_key => 'typeID'
	has_one :inv_meta_group, through: :inv_meta_type
	belongs_to :inv_group, :foreign_key => 'groupID'
	belongs_to :inv_market_group, :foreign_key => 'marketGroupID'
	has_many :inv_type_materials, :foreign_key => 'typeID'
	has_many :ram_type_requirements, through: :inv_blueprint_type
	has_many :dgm_type_attributes, :foreign_key => 'typeID'

	@@packaged_volumes = {
		shuttles: 500,
		frigates: 2500,
		mining_barges: 3750,
		destroyers: 5000,
		cruisers: 10000,
		industrial_ships: 20000,
		battlecruisers: 15000,
		battleships: 50000,
		capital_ships: 1000000,
	}

	def packaged_volume
		return volume unless in_market_group?(:ships)
		@@packaged_volumes.detect { |k,v| in_market_group?(k) }[1]
	end
	
	def ram_type_requirements_for_manufacturing
		return [] unless inv_blueprint_type
		inv_blueprint_type.ram_type_requirements_for_manufacturing
	end

	def ram_type_requirements_for_invention
		return [] unless inv_blueprint_type
		base_item.inv_blueprint_type.ram_type_requirements_for_invention
	end	

	def is_skill?
		inv_group.is_skill?
	end

	def is_ship?
		inv_group.is_ship?
	end
	
	def is_techI?
		!inv_meta_group || inv_meta_group.is_techI?
	end

	def is_techII?
		inv_meta_group && inv_meta_group.is_techII?
	end

	def in_market_group?(*group)
		inv_market_group.included_in?(group)
	end	

	def meta_level
		DgmTypeAttributes.find_by(typeID: typeID, attributeID: 633).valueFloat
	end

	def base_item
		return self unless is_techII?

		# Not sure what the right wasy is to get the base item associated with a tech II item. 
		# Maybe we can just sub I for II. 
		if typeName.include? 'II'
			return InvType.find_by_typeName(typeName.sub('II', 'I'))
		end

		# Next we'll try an approach based on market groups.
		item = ram_type_requirements_for_manufacturing.detect do |r| 
			is_ship? ? 
				r.required_type.in_market_group?(:ships) : 
				r.required_type.in_market_group?(inv_market_group)
		end
		return item.required_type if item

		# Sigh. 
		raise "Unsupported type: #{typeName}"
	end

end