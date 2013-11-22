require 'uri/http'
require 'cgi'
require 'open-uri'

class QuickLookData

	def initialize(options = {})
		@query = options
	end

	def uri(extraQueryArgs = {})
		args = {}
		args[:host] = 'api.eve-central.com'
		args[:path] = '/api/quicklook'

		query = @query.merge(extraQueryArgs).map {|k,v| "#{CGI.escape(k.to_s)}=#{CGI.escape(v.to_s)}"}.	join("&")
		args[:query] = query unless query.empty? 

		URI::HTTP.build(args)
	end

	def data(args)
		open(uri(args))
	end
end
