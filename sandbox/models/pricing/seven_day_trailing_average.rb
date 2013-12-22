require 'nokogiri'
require_relative '../database/map_regions'
require_relative '../database/inv_type'
require_relative 'item_history_data'

class SevenDayTrailingAverage

	attr_accessor :data_source, :name

	def initialize(source, name = nil)
		if source.is_a? MapRegions
			name = name || source.regionName
			source = ItemHistoryData.new(region_ids: source.regionID, days: 7, char_name: "Tommy Morgan")
		end
		@data_source = source
		@name = name
		@volume = {}
		@average_prices = {}
	end

  def volume(id)
    fetch(id)
    @volume[id] 
  end

  def average_price(id)
    fetch(id)
    @average_prices[id]
  end

  private  

	def average(marketData, property)
		data = marketData.css("row").collect { |n| n[property].to_f }
		data.size > 0 ? 
			(data.inject(0.0) {|sum, el| sum + el} / data.size).round : 
			0
	end

	def fetch(id)
		id = id.typeID if id.is_a? InvType
		return if @volume.has_key? id
		marketData = Nokogiri::XML(@data_source.data(:type_ids => id))
		@volume[id] = average(marketData, :volume)
		@average_prices[id] = average(marketData, :avgPrice)
	end	
	
end