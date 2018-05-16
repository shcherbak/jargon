-- Function: tests.__inventory__destroy()

-- DROP FUNCTION tests.__inventory__destroy();

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
