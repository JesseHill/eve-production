require 'nokogiri'
require 'open-uri'

class MarketStats

	def initialize()
		@items = {}
	end

	def load_item(id)
		return @items[id] if @items.has_key?(id)
		api = "http://api.eve-central.com/api/marketstat?typeid=#{id}&usesystem=30000142"
		marketData = Nokogiri::XML(open(api))
		@items[id] = marketData.css("type")[0]
	end

	def sell_volume(id)
		item = load_item(id)
		item.css("buy volume")[0].content.to_d
	end
end

# <evec_api method="marketstat_xml" version="2.0">
# 	<marketstat>
# 		<type id="22548">
# 			<buy>
# 				<volume>94</volume>
# 				<avg>145534182.30</avg>
# 				<max>154000004.37</max>
# 				<min>130000000.00</min>
# 				<stddev>10273060.96</stddev>
# 				<median>152202000.00</median>
# 				<percentile>154000004.37</percentile>
# 			</buy>
# 			<sell>
# 				<volume>381</volume>
# 				<avg>172987787.16</avg>
# 				<max>217000121.00</max>
# 				<min>161999989.99</min>
# 				<stddev>15298445.45</stddev>
# 				<median>165999698.80</median>
# 				<percentile>161999989.99</percentile>
# 			</sell>
# 			<all>
# 				<volume>482</volume>
# 				<avg>165137123.98</avg>
# 				<max>217000121.00</max>
# 				<min>131202.00</min>
# 				<stddev>35067312.72</stddev>
# 				<median>165898999.84</median>
# 				<percentile>106348079.98</percentile>
# 			</all>
# 		</type>
# 	</marketstat>
# </evec_api>