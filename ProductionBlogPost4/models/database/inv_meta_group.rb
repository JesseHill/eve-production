require 'active_record'

	# Tech I	
	# Tech II	
	# Storyline	
	# Faction	
	# Officer	
	# Deadspace
	# Frigates	
	# Elite Frigates	
	# Commander Frigates	
	# Destroyer	
	# Cruiser	
	# Elite Cruiser	
	# Commander Cruiser	
	# Tech III	


class InvMetaGroup < ActiveRecord::Base
	self.table_name = "invMetaGroups"
	self.primary_key = "metaGroupID"

	has_many :inv_types, through: :inv_meta_type

	def is_techI?
		metaGroupName == 'Tech I'
	end

	def is_techII?
		metaGroupName == 'Tech II'
	end

	def is_techIII?
		metaGroupName == 'Tech III'
	end
end