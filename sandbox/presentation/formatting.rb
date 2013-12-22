require 'money'

class Formatting

	def self.format_isk(value)
		Money.new(value * 100).format(
			:symbol => "ISK", 
			:symbol_position => :after,
			:sign_before_symbol => true)
	end

	def self.format_volume(value)
		Money.new(value.ceil * 100).format(
			:symbol => "m3", 
			:symbol_position => :after, 
			:no_cents => true)
	end

	def self.format_quantity(value)
		Money.new(value.ceil * 100).format(
			:symbol => "", 
			:no_cents => true)
	end	

	def self.format_time(value)
		mm, ss = value.divmod(60)
		hh, mm = mm.divmod(60)
		dd, hh = hh.divmod(24)

		if dd > 0
			"%d days, %d hours, %d minutes and %d seconds" % [dd, hh, mm, ss]
		elsif hh > 0
			"%d hours, %d minutes and %d seconds" % [hh, mm, ss]
		else
			"%d minutes and %d seconds" % [mm, ss]
		end
	end
end




