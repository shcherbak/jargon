--SELECT public.uuid_generate_v4();


"__facility__destroy"
"__facility__get_head"
"__facility__get_head_batch"
"__facility__init"
"__facility__reinit"
"__inventory__convert_quantity"
"__inventory__get_base_uom"
"__inventory__get_document"
"__inventory__get_head_batch"
"__inventory__get_kind_spec"
"__inventory__get_meas_spec"
"__inventory__get_uom_conversion_factors"
"__inventory__set_kind_spec"
"__inventory__set_meas_spec"
"__uom__get_domain"
"__uom__get_factor"
"__uom__get_head"
"__uom__get_head_batch"


CREATE OR REPLACE FUNCTION tests.__inventory__reinit()
  RETURNS void AS
$BODY$
DECLARE
  _test_head CONSTANT common.inventory_head[] := ARRAY[(3, 'cf77e3ea-0b5c-4e62-be62-63704f4071b7', 'fl-25-50', '20.25.50-001', 2, '2018-01-16', 'pcs', 'PROPOSED', 'INVENTORY')]::common.inventory_head[];
  _test_meas_init CONSTANT common.unit_conversion_type[] := ARRAY[('pcs', 'pcs', 1), ('pcs', 'g', 1000)]::common.unit_conversion_type[];
  _test_meas_reinit CONSTANT common.unit_conversion_type[] := ARRAY[('pcs', 'pcs', 1), ('pcs', 'kg', 10)]::common.unit_conversion_type[];
  _test_kind_init CONSTANT common.inventory_kind[] := ARRAY[('ASSEMBLY'), ('STORABLE')]::common.inventory_kind[];
  _test_kind_reinit CONSTANT common.inventory_kind[] := ARRAY[('PART'), ('CONSUMABLE')]::common.inventory_kind[];
  _head common.inventory_head;
  _meas common.unit_conversion_type[];
  _kind common.inventory_kind[];
  _document_id bigint;
BEGIN

  RAISE DEBUG '#trace Check __inventory__reinit()';
  
  _document_id := inventory.init(_test_head[1], _test_meas_init, _test_kind_init);
  PERFORM inventory.reinit(_document_id, _test_meas_reinit, _test_kind_reinit);
  _head := inventory.get_head(_document_id);
  _meas := inventory.get_meas_spec(_document_id);
  _kind := inventory.get_kind_spec(_document_id);

  PERFORM pgunit.assert_array_equals(_meas, _test_meas_reinit, 'Incorrect _meas_reinit value');
  PERFORM pgunit.assert_array_equals(_kind, _test_kind_reinit, 'Incorrect _kind_reinit value');

END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;
ALTER FUNCTION tests.__inventory__reinit()
  OWNER TO postgres;


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


CREATE OR REPLACE FUNCTION tests.__inventory__get_head()
  RETURNS void AS
$BODY$
DECLARE
  _head common.inventory_head;
  _test_gid CONSTANT uuid := 'cf77e3ea-0b5c-4e62-be62-63704f4071b7';
  _test_display_name CONSTANT character varying := 'fl-25-50';
  _test_part_code CONSTANT character varying := '22.25.050-001';
  _test_document_date CONSTANT date := '2018-01-16'::date;
  _test_version_num CONSTANT integer := 2;
  _test_uom_code CONSTANT character varying := 'pcs';
  _test_curr_fsmt CONSTANT common.document_fsmt := 'PROPOSED'::common.document_fsmt;
  _test_document_type CONSTANT common.document_kind := 'INVENTORY'::common.document_kind;
BEGIN
  
  RAISE DEBUG '#trace Check __inventory__get_head()';

  INSERT INTO
    inventory.information
      (id, gid, part_code, display_name, published_date)
    VALUES
      (1, 'a711da30-fa3a-11e7-8e63-d4bed939923a', '22.16.050-001', 'fl-16-50', '2018-01-15'),
      (2, 'b39a3ff4-fa3a-11e7-8e64-d4bed939923a', '22.25.050-001', 'fl-25-50', '2018-01-15'),
      (3, 'f08b5682-fa3a-11e7-86da-d4bed939923a', '22.40.050-001', 'fl-40-50', '2018-01-15');

  INSERT INTO
    inventory.definition 
      (id, gid, display_name, version_num, published_date, prev_fsmt, prev_fsmt_date, curr_fsmt, curr_fsmt_date, information_id, uom_code)
    VALUES 
      (1, 'c9000ec8-fa3a-11e7-9489-d4bed939923a', 'fl-16-50', 1, '2018-01-10', NULL, NULL, 'DECOMMITTED', '2018-01-10', 1, 'pcs'),
      (2, 'd83fb96a-fa3a-11e7-948a-d4bed939923a', 'fl-25-50', 1, '2018-01-15', NULL, NULL, 'COMMITTED', '2018-01-15', 2, 'pcs'),
      (3, 'cf77e3ea-0b5c-4e62-be62-63704f4071b7', 'fl-25-50', 2, '2018-01-16', NULL, NULL, 'PROPOSED', '2018-01-16', 2, 'pcs'),
      (4, 'c792f74d-7e6e-4577-ad69-987f56af7af7', 'fl-40-50', 1, '2018-01-17', NULL, NULL, 'COMMITTED', '2018-01-17', 3, 'pcs');

  _head := inventory.get_head(3);
  PERFORM pgunit.assert_equals(_test_gid, _head.gid, 'Incorrect gid value');
  PERFORM pgunit.assert_equals(_test_display_name, _head.display_name, 'Incorrect display_name value');
  PERFORM pgunit.assert_equals(_test_part_code, _head.part_code, 'Incorrect part_code value');
  PERFORM pgunit.assert_equals(_test_document_date, _head.document_date, 'Incorrect document_date value');
  PERFORM pgunit.assert_equals(_test_version_num, _head.version_num, 'Incorrect version_num value');
  PERFORM pgunit.assert_equals(_test_uom_code, _head.uom_code, 'Incorrect uom_code value');
  PERFORM pgunit.assert_equals(_test_curr_fsmt, _head.curr_fsmt, 'Incorrect curr_fsmt value');
  PERFORM pgunit.assert_equals(_test_document_type, _head.document_type, 'Incorrect document_type value');


  _head := inventory.get_head(4);
  PERFORM pgunit.assert_not_equals(_test_gid, _head.gid, 'Incorrect gid value');
  
  _head := inventory.get_head(5);
  PERFORM pgunit.assert_null(_head, 'Incorrect _head value');

END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;
ALTER FUNCTION tests.__inventory__get_head()
  OWNER TO postgres;


CREATE OR REPLACE FUNCTION tests.__inventory__destroy()
  RETURNS void AS
$BODY$
DECLARE
  _head common.inventory_head;
BEGIN
  
  RAISE DEBUG '#trace Check __inventory__destroy()';

  INSERT INTO
    inventory.information
      (id, gid, part_code, display_name, published_date)
    VALUES
      (1, 'a711da30-fa3a-11e7-8e63-d4bed939923a', '22.16.050-001', 'fl-16-50', '2018-01-15'),
      (2, 'b39a3ff4-fa3a-11e7-8e64-d4bed939923a', '22.25.050-001', 'fl-25-50', '2018-01-15'),
      (3, 'f08b5682-fa3a-11e7-86da-d4bed939923a', '22.40.050-001', 'fl-40-50', '2018-01-15');

  INSERT INTO
    inventory.definition 
      (id, gid, display_name, version_num, published_date, prev_fsmt, prev_fsmt_date, curr_fsmt, curr_fsmt_date, information_id, uom_code)
    VALUES 
      (1, 'c9000ec8-fa3a-11e7-9489-d4bed939923a', 'fl-16-50', 1, '2018-01-10', NULL, NULL, 'DECOMMITTED', '2018-01-10', 1, 'pcs'),
      (2, 'd83fb96a-fa3a-11e7-948a-d4bed939923a', 'fl-25-50', 1, '2018-01-15', NULL, NULL, 'COMMITTED', '2018-01-15', 2, 'pcs'),
      (3, 'cf77e3ea-0b5c-4e62-be62-63704f4071b7', 'fl-25-50', 2, '2018-01-16', NULL, NULL, 'PROPOSED', '2018-01-16', 2, 'pcs'),
      (4, 'c792f74d-7e6e-4577-ad69-987f56af7af7', 'fl-40-50', 1, '2018-01-17', NULL, NULL, 'COMMITTED', '2018-01-17', 3, 'pcs');

  PERFORM inventory.destroy(1); -- + add not allowed delete test
  
  _head := inventory.get_head(1);
  PERFORM pgunit.assert_null(_head, 'Incorrect _head value');

  _head := inventory.get_head(3);
  PERFORM pgunit.assert_not_null(_head, 'Incorrect _head value');

END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;
ALTER FUNCTION tests.__inventory__destroy()
  OWNER TO postgres;
