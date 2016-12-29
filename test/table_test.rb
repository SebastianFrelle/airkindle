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
    field_values = @table.records.first.select { |k, v| k == 'fields' }

    record = @table.create_record(field_values)

    refute_nil record
    assert_fields_are_the_same(record['fields'])
  end

  def test_read_record
    record_id = @table.records.first['id']
    record = @table.read_record(record_id)

    refute_nil record
    assert_equal record['id'], record_id

    assert_fields_are_the_same(record['fields'])
  end

  def test_update_record
    record_id = @table.records.first['id']
    word = 'scaffolding'
    difficulty = 'Easy'

    # probably ok to hardcode this for now
    new_field_values = { "fields" => { 
        "Word" => word,
        "Difficulty" => difficulty
      }
    }

    updated_record = @table.update_record(record_id, new_field_values)

    refute_nil updated_record

    assert_equal word, updated_record['Word']
    assert_equal difficulty, updated_record['Difficulty']

    assert_fields_are_the_same(record)
  end

  def test_update_part_of_record
    record_id = @table.records.first['id']
    word = 'scaffolding'
    difficulty = 'Easy'

    # probably ok to hardcode this for now
    new_field_values = { "fields" => {
        "Word" => word,
        "Difficulty" => difficulty
      }
    }

    updated_record = @table.update_part_of_record(record_id, new_field_values)

    refute_nil updated_record

    assert_equal word, updated_record['fields']['Word']
    assert_equal difficulty, updated_record['fields']['Difficulty']

    assert_fields_are_the_same(updated_record['fields'])
  end

  def test_delete_record
    record_id = @table.records.first['id']
    success = @table.delete_record(record_id)

    assert success
  end

  private

  def assert_fields_are_the_same(record_fields)
    record_field_names = record_fields.keys

    @table.fields.each do |field|
      assert record_field_names.include?(field)
    end
  end
end