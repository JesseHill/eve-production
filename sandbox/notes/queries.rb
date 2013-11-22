types = InvType.joins(:inv_group).limit(10).where(invGroups: {categoryID: 6}).joins(:inv_meta_group).
where(invMetaGroups: {metaGroupID: 4})


InvType.where(groupID: 25).
	joins(:inv_meta_group).
	where(invMetaGroups: {metaGroupID: 4}).
	limit(10).
	order("typeName").
	collect {|t| t.typeName}