require_relative 'invBlueprintType'
require_relative 'invTypeMaterial'
require_relative 'invGroup'
require_relative 'invMetaGroup'
require_relative 'invMetaType'
require_relative 'invMarketGroup'
require_relative 'ramTypeRequirement'

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
end