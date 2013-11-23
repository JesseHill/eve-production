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
	
	def ram_type_requirements_for_manufacturing
		return [] unless inv_blueprint_type
		inv_blueprint_type.ram_type_requirements_for_manufacturing
	end

	def is_skill?
		inv_group.is_skill?
	end

	def is_techII?
		inv_meta_group && inv_meta_group.is_techII?
	end

	def in_market_group?(group)
		inv_market_group.included_in?(group)
	end	

end