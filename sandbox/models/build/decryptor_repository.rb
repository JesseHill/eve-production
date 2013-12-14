

class DecryptorRepository

	@@race_map = {
		amarr: "Occult",
		caldari: "Esoteric",
		gallente: "Incognito",
		minmatar: "Cryptic"
	}

	@@decryptor_types = {
		augmentation: {
			name: "# Augmentation",
			probability_multiplier: 0.6,
			max_run_modifier: 9,
			me_modifier: -2,
			pe_modifier: 1
		},
		optimized_augmentation: {
			name: "Optimized # Augmentation",
			probability_multiplier: 0.9,
			max_run_modifier: 7,
			me_modifier: 2,
			pe_modifier: 0
		},
		symmetry: {
			name: "# Symmetry",
			probability_multiplier: 1,
			max_run_modifier: 2,
			me_modifier: 1,
			pe_modifier: 4
		},
		process: {
			name: "# Process",
			probability_multiplier: 1.1,
			max_run_modifier: 0,
			me_modifier: 3,
			pe_modifier: 3
		},
		accelerant: {
			name: "# Accelerant",
			probability_multiplier: 1.2,
			max_run_modifier: 1,
			me_modifier: 2,
			pe_modifier: 5
		},
		parity: {
			name: "# Parity",
			probability_multiplier: 1.5,
			max_run_modifier: 3,
			me_modifier: 1,
			pe_modifier: -1
		},
		attainment: {
			name: "# Attainment",
			probability_multiplier: 1.8,
			max_run_modifier: 4,
			me_modifier: -1,
			pe_modifier: 2
		},
		optimized_attainment: {
			name: "Optimized # Attainment",
			probability_multiplier: 1.9,
			max_run_modifier: 2,
			me_modifier: 1,
			pe_modifier: -1
		},
	}

	def find(item, type)
		raise 'Unsupported item. Sorry.' unless item.is_ship?
		typeName = @@decryptor_types[type][:name]
			.sub('#', @@race_map[item.inv_market_group.marketGroupName.downcase.to_sym])
		InvType.find_by_typeName(typeName)
	end

	def types
		@@decryptor_types.keys
	end

	def probability_multiplier(decryptor)
		return 1 unless decryptor
		find_decryptor_type(decryptor)[:probability_multiplier]
	end

	def max_run_modifier(decryptor)
		return 0 unless decryptor
		find_decryptor_type(decryptor)[:max_run_modifier]
	end

	def me_modifier(decryptor)
		return 0 unless decryptor
		find_decryptor_type(decryptor)[:me_modifier]
	end

	def pe_modifier(decryptor)
		return 0 unless decryptor
		find_decryptor_type(decryptor)[:pe_modifier]
	end

	private

	def find_decryptor_type(decryptor)
		name = @@race_map.values.inject(decryptor.typeName) { |memo,value| memo.sub(value, "#") }
		@@decryptor_types.values.detect { |type| type[:name] == name }
	end
end