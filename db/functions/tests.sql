"__facility__destroy"
"__facility__get_head"
"__facility__get_head_batch"
"__facility__init"
"__facility__reinit"
"__inventory__convert_quantity"
"__inventory__destroy"
"__inventory__get_base_uom"
"__inventory__get_document"
"__inventory__get_head"
"__inventory__get_head_batch"
"__inventory__get_kind_spec"
"__inventory__get_meas_spec"
"__inventory__get_uom_conversion_factors"
"__inventory__init"
"__inventory__reinit"
"__inventory__set_kind_spec"
"__inventory__set_meas_spec"
"__uom__get_domain"
"__uom__get_factor"
"__uom__get_head"
"__uom__get_head_batch"




a


--
-- TOC entry 2391 (class 0 OID 351111)
-- Dependencies: 223
-- Data for Name: measurement; Type: TABLE DATA; Schema: inventory; Owner: postgres
--

INSERT INTO measurement (definition_id, uom_code, factor) VALUES (1, 'pcs', 1);
INSERT INTO measurement (definition_id, uom_code, factor) VALUES (2, 'pcs', 1);
INSERT INTO measurement (definition_id, uom_code, factor) VALUES (3, 'm', 25);
INSERT INTO measurement (definition_id, uom_code, factor) VALUES (4, 'pcs', 1);
INSERT INTO measurement (definition_id, uom_code, factor) VALUES (5, 'pcs', 1);
INSERT INTO measurement (definition_id, uom_code, factor) VALUES (6, 'pcs', 1);
INSERT INTO measurement (definition_id, uom_code, factor) VALUES (7, 'pcs', 1);
INSERT INTO measurement (definition_id, uom_code, factor) VALUES (8, 'pcs', 1);
INSERT INTO measurement (definition_id, uom_code, factor) VALUES (18, 'kg', 1);
INSERT INTO measurement (definition_id, uom_code, factor) VALUES (18, 'g', 1000);


--
-- TOC entry 2392 (class 0 OID 351117)
-- Dependencies: 224
-- Data for Name: variety; Type: TABLE DATA; Schema: inventory; Owner: postgres
--

INSERT INTO variety (definition_id, inventory_type) VALUES (1, 'PART');
INSERT INTO variety (definition_id, inventory_type) VALUES (1, 'PRODUCIBLE');
INSERT INTO variety (definition_id, inventory_type) VALUES (1, 'SALABLE');
INSERT INTO variety (definition_id, inventory_type) VALUES (1, 'STORABLE');
INSERT INTO variety (definition_id, inventory_type) VALUES (2, 'PART');
INSERT INTO variety (definition_id, inventory_type) VALUES (2, 'PRODUCIBLE');
INSERT INTO variety (definition_id, inventory_type) VALUES (2, 'SALABLE');
INSERT INTO variety (definition_id, inventory_type) VALUES (2, 'STORABLE');
INSERT INTO variety (definition_id, inventory_type) VALUES (3, 'STORABLE');
INSERT INTO variety (definition_id, inventory_type) VALUES (3, 'BUYABLE');
INSERT INTO variety (definition_id, inventory_type) VALUES (3, 'CONSUMABLE');
INSERT INTO variety (definition_id, inventory_type) VALUES (3, 'PRIMAL');
INSERT INTO variety (definition_id, inventory_type) VALUES (4, 'PRODUCIBLE');
INSERT INTO variety (definition_id, inventory_type) VALUES (4, 'ASSEMBLY');
INSERT INTO variety (definition_id, inventory_type) VALUES (4, 'STORABLE');
INSERT INTO variety (definition_id, inventory_type) VALUES (5, 'PRODUCIBLE');
INSERT INTO variety (definition_id, inventory_type) VALUES (5, 'ASSEMBLY');
INSERT INTO variety (definition_id, inventory_type) VALUES (5, 'STORABLE');
INSERT INTO variety (definition_id, inventory_type) VALUES (6, 'PRODUCIBLE');
INSERT INTO variety (definition_id, inventory_type) VALUES (6, 'ASSEMBLY');
INSERT INTO variety (definition_id, inventory_type) VALUES (6, 'STORABLE');
INSERT INTO variety (definition_id, inventory_type) VALUES (7, 'PRODUCIBLE');
INSERT INTO variety (definition_id, inventory_type) VALUES (7, 'ASSEMBLY');
INSERT INTO variety (definition_id, inventory_type) VALUES (7, 'STORABLE');
INSERT INTO variety (definition_id, inventory_type) VALUES (8, 'PRODUCIBLE');
INSERT INTO variety (definition_id, inventory_type) VALUES (8, 'ASSEMBLY');
INSERT INTO variety (definition_id, inventory_type) VALUES (8, 'STORABLE');
INSERT INTO variety (definition_id, inventory_type) VALUES (8, 'CONSUMABLE');
INSERT INTO variety (definition_id, inventory_type) VALUES (8, 'SALABLE');
INSERT INTO variety (definition_id, inventory_type) VALUES (18, 'ASSEMBLY');
INSERT INTO variety (definition_id, inventory_type) VALUES (18, 'STORABLE');



-- Function: inventory.get_head(bigint)

-- DROP FUNCTION inventory.get_head(bigint);

CREATE OR REPLACE FUNCTION inventory.get_head(__document_id bigint)
  RETURNS common.inventory_head AS
$BODY$
DECLARE
BEGIN
  RETURN 
    (definition.id, 
    definition.gid, 
    information.display_name, 
    information.part_code, 
    definition.version_num, 
    definition.published_date, 
    definition.uom_code, 
    definition.curr_fsmt,
    'INVENTORY'::common.document_kind
    )::common.inventory_head
  FROM 
    inventory.information, 
    inventory.definition
  WHERE 
    information.id = definition.information_id AND
    definition.id = __document_id;
END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;
ALTER FUNCTION inventory.get_head(bigint)
  OWNER TO postgres;


-- Function: inventory.init(common.inventory_head, common.unit_conversion_type[], common.inventory_kind[])

-- DROP FUNCTION inventory.init(common.inventory_head, common.unit_conversion_type[], common.inventory_kind[]);

CREATE OR REPLACE FUNCTION inventory.init(
    __head common.inventory_head,
    __meas common.unit_conversion_type[],
    __kind common.inventory_kind[])
  RETURNS bigint AS
$BODY$
DECLARE
  _information_id bigint;
  _definition_id bigint;
  _max_version_num integer;
BEGIN

  IF (__head.document_date IS NULL) THEN
    __head.document_date := now()::date;
  END IF;

  IF (__head.version_num IS NULL) THEN
    __head.version_num := 1;
  END IF;

  IF (__head.display_name IS NULL) THEN
    __head.display_name := 'NO-NAME';
  END IF;

  SELECT
    max(definition.version_num)
  FROM 
    inventory.information, 
    inventory.definition
  WHERE 
    information.id = definition.information_id AND
    information.part_code = __head.part_code --AND 
    --definition.version_num = __head.version_num
  INTO
    _max_version_num;


  -- replece with coalesce
  IF (_max_version_num IS NULL) THEN
    _max_version_num := 0;
  END IF;  

  _information_id := id FROM inventory.information WHERE part_code = __head.part_code;

  IF (_information_id IS NULL) THEN
    INSERT INTO
      inventory.information (
        id,
        display_name,
        published_date,
        part_code)
    VALUES (
      DEFAULT,
      __head.display_name,
      __head.document_date,
      __head.part_code)
    RETURNING id INTO _information_id;
  END IF;

  INSERT INTO
    inventory.definition (
      id,
      display_name,
      version_num,
      published_date,
      information_id)
  VALUES (
    DEFAULT,
    __head.display_name,
    _max_version_num + 1,
    __head.document_date,
    _information_id)
  RETURNING id INTO _definition_id;

  PERFORM inventory.set_meas_spec(_definition_id, __meas);
  PERFORM inventory.set_kind_spec(_definition_id, __kind);

  RETURN _definition_id;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;
ALTER FUNCTION inventory.init(common.inventory_head, common.unit_conversion_type[], common.inventory_kind[])
  OWNER TO postgres;


-- Function: tests.__demand__get_head()

-- DROP FUNCTION tests.__demand__get_head();

CREATE OR REPLACE FUNCTION tests.__inventory__get_head()
  RETURNS void AS
$BODY$
DECLARE
  _head common.outbound_head;
  _test_gid CONSTANT uuid := '9b2952fa-01d1-11e7-b440-d4bed939923a';
  _test_display_name CONSTANT character varying := 'DEMAND-02';
  _test_document_date CONSTANT date := '2017-02-01'::date;
  _test_ship_to CONSTANT character varying := 'A1';
  _test_ship_from CONSTANT character varying := 'B1';
  _test_curr_fsmt CONSTANT common.document_fsmt := 'COMMITTED'::common.document_fsmt;
  _test_doctype CONSTANT common.document_kind := 'DEMAND'::common.document_kind;
  _test_due_date CONSTANT date := '2017-02-02'::date;
BEGIN
  
  RAISE DEBUG '#trace Check __demand__get_head()';

      (definition.id, 
      definition.gid, 
      information.display_name, 
      information.part_code, 
      definition.version_num, 
      definition.published_date, 
      definition.uom_code, 
      definition.curr_fsmt,
      'INVENTORY'::common.document_kind
      )::common.inventory_head


  INSERT INTO
    information
      (id, gid, part_code, display_name, published_date)
    VALUES
      (1, 'a711da30-fa3a-11e7-8e63-d4bed939923a', '22.16.050-001', 'fl-16-50', '2018-01-15'),
      (2, 'b39a3ff4-fa3a-11e7-8e64-d4bed939923a', '22.25.050-001', 'fl-25-50', '2018-01-15'),
      (3, 'f08b5682-fa3a-11e7-86da-d4bed939923a', '22.40.050-001', 'fl-40-50', '2018-01-15'),


  INSERT INTO
    definition 
      (id, gid, display_name, version_num, published_date, prev_fsmt, prev_fsmt_date, curr_fsmt, curr_fsmt_date, information_id, uom_code)
    VALUES 
      (1, 'c9000ec8-fa3a-11e7-9489-d4bed939923a', 'fl-16-50', 1, '2018-01-15', NULL, NULL, 'PROPOSED', '2018-01-15', 1, 'pcs'),
      (2, 'd83fb96a-fa3a-11e7-948a-d4bed939923a', 'fl-25-50', 1, '2018-01-15', NULL, NULL, 'PROPOSED', '2018-01-15', 2, 'pcs'),
      (2, 'd83fb96a-fa3a-11e7-948a-d4bed939923a', 'fl-25-50', 2, '2018-01-16', NULL, NULL, 'PROPOSED', '2018-01-15', 2, 'pcs'),
      (2, 'd83fb96a-fa3a-11e7-948a-d4bed939923a', 'fl-40-50', 1, '2018-01-15', NULL, NULL, 'PROPOSED', '2018-01-15', 3, 'pcs'),

  


  _head := demand.get_head(102);
  PERFORM pgunit.assert_equals(_test_gid, _head.gid, 'Incorrect gid value');
  PERFORM pgunit.assert_equals(_test_display_name, _head.display_name, 'Incorrect display_name value');
  PERFORM pgunit.assert_equals(_test_document_date, _head.document_date, 'Incorrect document_date value');
  PERFORM pgunit.assert_equals(_test_ship_to, _head.addressee, 'Incorrect ship_to value');
  PERFORM pgunit.assert_equals(_test_ship_from, _head.facility_code, 'Incorrect ship_from value');
  PERFORM pgunit.assert_equals(_test_curr_fsmt, _head.curr_fsmt, 'Incorrect curr_fsmt value');
  PERFORM pgunit.assert_equals(_test_doctype, _head.doctype, 'Incorrect doctype value');
  PERFORM pgunit.assert_equals(_test_due_date, _head.due_date, 'Incorrect due_date value');

  _head := demand.get_head(103);
  PERFORM pgunit.assert_not_equals(_test_gid, _head.gid, 'Incorrect gid value');
  
  _head := demand.get_head(104);
  PERFORM pgunit.assert_null(_head, 'Incorrect _head value');

END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;
ALTER FUNCTION tests.__demand__get_head()
  OWNER TO postgres;



-- Function: tests.__demand__get_head_batch()

-- DROP FUNCTION tests.__demand__get_head_batch();

CREATE OR REPLACE FUNCTION tests.__demand__get_head_batch()
  RETURNS void AS
$BODY$
DECLARE
  _heads common.outbound_head[];
  _head common.outbound_head;
  _array_lengh integer;
  _test_array_lengh CONSTANT integer := 2;
  _test_gid CONSTANT uuid := '9b2952fa-01d1-11e7-b440-d4bed939923a';
  _test_display_name CONSTANT character varying := 'DEMAND-02';
  _test_document_date CONSTANT date := '2017-02-01'::date;
  _test_ship_to CONSTANT character varying := 'A1';
  _test_ship_from CONSTANT character varying := 'B1';
  _test_curr_fsmt CONSTANT common.document_fsmt := 'COMMITTED'::common.document_fsmt;
  _test_doctype CONSTANT common.document_kind := 'DEMAND'::common.document_kind;
  _test_due_date CONSTANT date := '2017-02-02'::date;
BEGIN
  
  RAISE DEBUG '#trace Check __demand__get_head_batch()';

  INSERT INTO demand.head VALUES (101, '8236af18-eb1a-11e6-8a73-d4bed939923a', 'DEMAND-01', '2017-01-01', NULL, '2017-01-02', 'B1', 'A1', 'COMMITTED', '2017-02-04 22:46:51.810833+02', 'DECOMMITTED', '2017-02-04 22:47:10.05991+02');
  INSERT INTO demand.head VALUES (102, '9b2952fa-01d1-11e7-b440-d4bed939923a', 'DEMAND-02', '2017-02-01', NULL, '2017-02-02', 'A1', 'B1', 'PROPOSED', '2017-02-04 22:46:51.810833+02', 'COMMITTED', '2017-02-04 22:47:10.05991+02');
  INSERT INTO demand.head VALUES (103, 'f20d7196-01d1-11e7-b441-d4bed939923a', 'DEMAND-03', '2017-03-01', NULL, '2017-03-02', 'A1', 'B1', NULL, NULL, 'PROPOSED', '2017-02-04 22:47:10.05991+02');

  _heads := demand.get_head_batch(ARRAY[102,103]::bigint[]);
  _array_lengh := array_length(_heads, 1);
  _head := _heads[1];
  PERFORM pgunit.assert_equals(_test_array_lengh, _array_lengh, 'Incorrect _array_lengh value');
  PERFORM pgunit.assert_equals(_test_gid, _head.gid, 'Incorrect gid value');
  PERFORM pgunit.assert_equals(_test_display_name, _head.display_name, 'Incorrect display_name value');
  PERFORM pgunit.assert_equals(_test_document_date, _head.document_date, 'Incorrect document_date value');
  PERFORM pgunit.assert_equals(_test_ship_to, _head.addressee, 'Incorrect ship_to value');
  PERFORM pgunit.assert_equals(_test_ship_from, _head.facility_code, 'Incorrect ship_from value');
  PERFORM pgunit.assert_equals(_test_curr_fsmt, _head.curr_fsmt, 'Incorrect curr_fsmt value');
  PERFORM pgunit.assert_equals(_test_doctype, _head.doctype, 'Incorrect doctype value');
  PERFORM pgunit.assert_equals(_test_due_date, _head.due_date, 'Incorrect due_date value');

END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;
ALTER FUNCTION tests.__demand__get_head_batch()
  OWNER TO postgres;


-- Function: tests.__demand__init()

-- DROP FUNCTION tests.__demand__init();

CREATE OR REPLACE FUNCTION tests.__demand__init()
  RETURNS void AS
$BODY$
DECLARE
  _test_head CONSTANT common.outbound_head[] := ARRAY[(1,'8c1581c0-04c0-11e7-a843-08626627b4d6','DEMAND-01','2017-01-01','A1','PROPOSED','DEMAND','B1','2017-02-01')]::common.outbound_head[];
  _test_body CONSTANT common.document_body[] := ARRAY[('good1',10,'m'), ('good2',20,'m')]::common.document_body[];
  _head common.outbound_head;
  _body common.document_body[];
  _document_id bigint;
BEGIN
  
  RAISE DEBUG '#trace Check __demand__init()';
  
  _document_id := demand.init(_test_head[1], _test_body);
  _head := demand.get_head(_document_id);
  _body := demand.get_body(_document_id);
  --PERFORM pgunit.assert_equals(_test_head[1], _head, 'Incorrect _head value');
  PERFORM pgunit.assert_array_equals(_test_body, _body, 'Incorrect _body value');


END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;
ALTER FUNCTION tests.__demand__init()
  OWNER TO postgres;



-- Function: tests.__demand__reinit()

-- DROP FUNCTION tests.__demand__reinit();

CREATE OR REPLACE FUNCTION tests.__demand__reinit()
  RETURNS void AS
$BODY$
DECLARE
  _test_head CONSTANT common.outbound_head[] := ARRAY[(1,'8c1581c0-04c0-11e7-a843-08626627b4d6','DEMAND-01','2017-01-01','A1','PROPOSED','DEMAND','B1','2017-02-01')]::common.outbound_head[];
  _test_body_init CONSTANT common.document_body[] := ARRAY[('good1',10,'m'), ('good2',20,'m')]::common.document_body[];
  _test_body_reinit CONSTANT common.document_body[] := ARRAY[('good3',10,'m'), ('good4',20,'m')]::common.document_body[];
  _head common.outbound_head;
  _body common.document_body[];
  _document_id bigint;
BEGIN
  
  RAISE DEBUG '#trace Check __demand__reinit()';
  
  _document_id := demand.init(_test_head[1], _test_body_init);
  PERFORM demand.reinit(_document_id, _test_body_reinit);
  _head := demand.get_head(_document_id);
  _body := demand.get_body(_document_id);
  --PERFORM pgunit.assert_equals(_test_head[1], _head, 'Incorrect _head value');
  PERFORM pgunit.assert_array_equals(_test_body_reinit, _body, 'Incorrect _body value');


END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;
ALTER FUNCTION tests.__demand__reinit()
  OWNER TO postgres;



-- Function: tests.__despatch__destroy()

-- DROP FUNCTION tests.__despatch__destroy();

CREATE OR REPLACE FUNCTION tests.__despatch__destroy()
  RETURNS void AS
$BODY$
DECLARE
  _head common.outbound_head;
BEGIN
  
  RAISE DEBUG '#trace Check __despatch__destroy()';

  INSERT INTO despatch.head VALUES (101, '8236af18-eb1a-11e6-8a73-d4bed939923a', 'DESPATCH-01', '2017-01-01', NULL, '2017-01-02', 'B1', 'A1', 'COMMITTED', '2017-02-04 22:46:51.810833+02', 'DECOMMITTED', '2017-02-04 22:47:10.05991+02');
  INSERT INTO despatch.head VALUES (102, '9b2952fa-01d1-11e7-b440-d4bed939923a', 'DESPATCH-02', '2017-02-01', NULL, '2017-02-02', 'A1', 'B1', 'PROPOSED', '2017-02-04 22:46:51.810833+02', 'COMMITTED', '2017-02-04 22:47:10.05991+02');
  INSERT INTO despatch.head VALUES (103, 'f20d7196-01d1-11e7-b441-d4bed939923a', 'DESPATCH-03', '2017-03-01', NULL, '2017-03-02', 'A1', 'B1', NULL, NULL, 'PROPOSED', '2017-02-04 22:47:10.05991+02');

  PERFORM despatch.destroy(101); -- + add not allowed delete test
  
  _head := despatch.get_head(101);
  PERFORM pgunit.assert_null(_head, 'Incorrect _head value');

  _head := despatch.get_head(103);
  PERFORM pgunit.assert_not_null(_head, 'Incorrect _head value');

END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;
ALTER FUNCTION tests.__despatch__destroy()
  OWNER TO postgres;
