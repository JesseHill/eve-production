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

	def is_skill?
		inv_group.is_skill?
	end

	def is_ship?
		inv_group.is_ship?
	end

	def is_techII?
		inv_meta_group && inv_meta_group.is_techII?
	end

	def in_market_group?(group)
		inv_market_group.included_in?(group)
	end	

end