require 'json'
require 'net/http'

class Table
  attr_accessor :api_key, :table_id, :table_name

  def initialize(api_key, table_id, table_name)
    @api_key = api_key
    @table_id = table_id
    @table_name = table_name
    @url = "https://api.airtable.com/v0/#{@table_id}/#{@table_name}"
  end

  def records
    uri = URI(@url)
    req = Net::HTTP::Get.new(uri)
    req['Authorization'] = "Bearer #{@api_key}"
    
    res = Net::HTTP.start(uri.host, uri.port, :use_ssl => true) do |http| 
      http.request(req)
    end

    data = res.body
    parsed_data = JSON.parse(data)
    parsed_data['records']
  end

  def fields
    records.first['fields'].keys
  end

  # CRUD OPERATIONS
  
  # takes hash of (field name) => (value)
  def create_record(field_values)
    
  end

  def read_record(record_id)
    uri = URI(@url + "/#{record_id}")
    req = Net::HTTP::Get.new(uri)
    req['Authorization'] = "Bearer #{@api_key}"

    res = Net::HTTP.start(uri.host, uri.port, :use_ssl => true) do |http|
      http.request(req)
    end

    data = res.body
    JSON.parse(data)
  end

  # should take a hash of {(key to update) => (new value), ...}
  def update_record(record_id, new_field_values)

  end

  def delete_record(record_id)
    uri = URI(@url + "/#{record_id}")
    req = Net::HTTP::Delete.new(uri)
    req['Authorization'] = "Bearer #{@api_key}"

    res = Net::HTTP.start(uri.host, uri.port, :use_ssl => true) do |http|
      http.request(req)
    end

    res_data = JSON.parse(res.body)

    res.is_a?(Net::HTTPSuccess) && res_data['deleted']
  end
end