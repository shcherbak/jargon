-- Function: tests.__inventory__init()

-- DROP FUNCTION tests.__inventory__init();

CREATE OR REPLACE FUNCTION tests.__inventory__init()
  RETURNS void AS
$BODY$
DECLARE
  _test_head CONSTANT common.inventory_head[] := ARRAY[(3, 'cf77e3ea-0b5c-4e62-be62-63704f4071b7', 'fl-25-50', '20.25.50-001', 2, '2018-01-16', 'pcs', 'PROPOSED', 'INVENTORY')]::common.inventory_head[];
  _test_meas CONSTANT common.unit_conversion_type[] := ARRAY[('pcs', 'pcs', 1), ('pcs', 'g', 1000)]::common.unit_conversion_type[];
  _test_kind CONSTANT common.inventory_kind[] := ARRAY[('ASSEMBLY'), ('STORABLE')]::common.inventory_kind[];
  _head common.inventory_head;
  _meas common.unit_conversion_type[];
  _kind common.inventory_kind[];
  _document_id bigint;
BEGIN

  RAISE DEBUG '#trace Check __inventory__init()';
  
  _document_id := inventory.init(_test_head[1], _test_meas, _test_kind);
  _head := inventory.get_head(_document_id);
  _meas := inventory.get_meas_spec(_document_id);
  _kind := inventory.get_kind_spec(_document_id);

  PERFORM pgunit.assert_array_equals(_test_meas, _meas, 'Incorrect _meas value');
  PERFORM pgunit.assert_array_equals(_test_kind, _kind, 'Incorrect _kind value');


END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;
ALTER FUNCTION tests.__inventory__init()
  OWNER TO postgres;
