require 'uri/http'
require 'cgi'
require 'open-uri'

class ItemHistoryData

	attr_accessor :query_data

	def initialize(options = {})
		@query_data = options
	end

	def uri(extraQueryArgs = {})
		args = {}
		args[:host] = 'api.eve-marketdata.com'
		args[:path] = '/api/item_history2.xml'

		query = @query_data.merge(extraQueryArgs).map {|k,v| "#{CGI.escape(k.to_s)}=#{CGI.escape(v.to_s)}"}.join("&")
		args[:query] = query unless query.empty? 

		URI::HTTP.build(args)
	end

	def data(args)
		# puts "Loading #{uri(args)}"
		open(uri(args))
	end
end
