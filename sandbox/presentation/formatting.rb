require 'money'

class Formatting

	def self.format_isk(value)
		Money.new(value * 100).format(
			:symbol => "ISK", 
			:symbol_position => :after,
			:sign_before_symbol => true
			# :sign_before_symbol => false
		)
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
end




