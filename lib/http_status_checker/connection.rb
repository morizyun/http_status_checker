module HttpStatusChecker
  module Connection
    def self.get_header(url)
      uri = URI.parse(url)
      http = Net::HTTP.new(uri.host)
      http.head(uri.request_uri)
    end
  end
end
