class BlueprintRepository

	def material_level(blueprintTypeID)
		blueprint = InvBlueprintType.find_by_blueprintTypeID(blueprintTypeID)
		metaGroup = blueprint.inv_type.inv_meta_group
		techII = metaGroup && metaGroup.metaGroupID > 1
		isShip = blueprint.inv_type.inv_group.inv_category.is_ship?

		if isShip
			return 50 unless techII
			return blueprint.inv_type.inv_market_group.included_in_frigates? ? -3 : -1
		end

		return techII ? -4 : 75 
	end
end