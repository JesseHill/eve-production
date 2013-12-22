require_relative '../database/inv_type'

class CompositePricingModel

	def initialize(models = [])
		@models = models
	end

	def buy_price(id)
		return 0 if @models.empty?
		id = id.typeID if id.is_a? InvType
		@models.collect { |m| m.buy_price(id) }.min
	end	

	def sell_price(id)
		return 0 if @models.empty?
		id = id.typeID if id.is_a? InvType
		@models.collect { |m| m.sell_price(id) }.max
	end	

	def group_by_buy_price(materials)
		Hash.new { |hash, key| hash[key] = Hash.new(0) }.tap { |groups|
			materials.each { |material, quantity|
				best_market = @models.min_by { |model| model.buy_price(material) }
				groups[best_market][material] += quantity
			}
		}	
	end

	def group_by_sell_price(materials)
		Hash.new { |hash, key| hash[key] = Hash.new(0) }.tap { |groups|
			materials.each { |material, quantity|
				best_market = @models.max_by { |model| model.sell_price(material) }
				groups[best_market][material] += quantity
			}
		}	
	end	
end