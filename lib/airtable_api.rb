require 'socket'
require 'net/http'

module AirtableApi
  class Table
    def initialize(api_key, table_id, table_name)
      @api_key = api_key
      @table_id = table_id
      @table_name = table_name
      @client = Client.new(@api_key)
      @url = "https://api.airtable.com/v0/#{@table_id}/#{@table_name}"
    end

    def records
      uri = URI(@url)
      response = @client.connection(uri)
      response.body
    end
  end

  class Client
    attr_accessor :api_key

    def initialize(api_key)
      @api_key = api_key
    end
    
    def connection(uri)
      http_response = nil

      Net::HTTP.start(uri.host, uri.port, :use_ssl => true) do |http|
        request = Net::HTTP::Get.new(uri)
        request['Authorization'] = "Bearer #{@api_key}"

        http_response = http.request(request)
      end

      http_response
    end
  end
end