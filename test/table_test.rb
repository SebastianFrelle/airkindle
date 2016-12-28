require 'minitest/autorun'
require 'net/http'
require_relative '../lib/table'

class TableTest < Minitest::Test
  def setup
    @api_key = 'keyExQRsVBWnSiDWS'
    @table_id = 'appd6wsQHQgwCf7V6'
    @table_name = 'Words'

    @table = Table.new(@api_key, @table_id, @table_name)
  end

  def test_init_client
    refute_nil @table

    assert_equal @table.api_key, 'keyExQRsVBWnSiDWS'
    assert_equal @table.table_id, 'appd6wsQHQgwCf7V6'
    assert_equal @table.table_name, 'Words'
  end

  # Consider creating a mock table here for testing
  def test_records
    records = @table.records

    refute_nil records
    assert records.kind_of? Array
  end

  def test_fields
    fields = @table.fields

    refute_nil fields
    assert fields.kind_of? Array
    assert fields.include? 'Difficulty'
  end

  def test_create_record
    record_id = @table.records.first['id']

    # field_values = # init hash of values here

    # figure out a way to do field types here in order to be able to pass
    # values as arguments
    record = @table.create_record()

    assert_equal record['id'], record_id
    
    assert_field_names(record)
  end

  def test_read_record
    record_id = @table.records.first['id']
    record = @table.read_record(record_id)

    refute_nil record
    assert_equal record['id'], record_id

    assert_field_names(record)
  end

  def test_update_record
    record_id = @table.records.first['id']

    # init field values somehow
    # maybe write a method that maps mock data to table fields in a hash
    new_field_values = {"field_name" => "new_field_value"}
    updated_record = @table.update_record(record_id, new_field_values)

    assert_equal updated_record['id'], record_id
    assert_field_names(record)
  end

  def test_delete_record
    record_id = @table.records.first['id']
    success = @table.delete_record(record_id)

    assert success
  end

  private

  def assert_field_names(record)
    field_names = record['fields'].keys
    
    @table.fields.each do |field|
      assert field_names.include?(field)
    end
  end
end