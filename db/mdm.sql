--
-- PostgreSQL database dump
--

-- Dumped from database version 9.6.7
-- Dumped by pg_dump version 9.6.7

-- Started on 2018-02-17 23:23:57 EET

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SET check_function_bodies = false;
SET client_min_messages = warning;
SET row_security = off;

--
-- TOC entry 12 (class 2615 OID 76394)
-- Name: common; Type: SCHEMA; Schema: -; Owner: postgres
--

CREATE SCHEMA common;


ALTER SCHEMA common OWNER TO postgres;

--
-- TOC entry 13 (class 2615 OID 76395)
-- Name: equipment; Type: SCHEMA; Schema: -; Owner: postgres
--

CREATE SCHEMA equipment;


ALTER SCHEMA equipment OWNER TO postgres;

--
-- TOC entry 14 (class 2615 OID 76396)
-- Name: facility; Type: SCHEMA; Schema: -; Owner: postgres
--

CREATE SCHEMA facility;


ALTER SCHEMA facility OWNER TO postgres;

--
-- TOC entry 15 (class 2615 OID 76397)
-- Name: inventory; Type: SCHEMA; Schema: -; Owner: postgres
--

CREATE SCHEMA inventory;


ALTER SCHEMA inventory OWNER TO postgres;

--
-- TOC entry 16 (class 2615 OID 76398)
-- Name: personnel; Type: SCHEMA; Schema: -; Owner: postgres
--

CREATE SCHEMA personnel;


ALTER SCHEMA personnel OWNER TO postgres;

--
-- TOC entry 17 (class 2615 OID 76399)
-- Name: pgunit; Type: SCHEMA; Schema: -; Owner: postgres
--

CREATE SCHEMA pgunit;


ALTER SCHEMA pgunit OWNER TO postgres;

--
-- TOC entry 18 (class 2615 OID 76400)
-- Name: tests; Type: SCHEMA; Schema: -; Owner: postgres
--

CREATE SCHEMA tests;


ALTER SCHEMA tests OWNER TO postgres;

--
-- TOC entry 19 (class 2615 OID 76401)
-- Name: tooling; Type: SCHEMA; Schema: -; Owner: postgres
--

CREATE SCHEMA tooling;


ALTER SCHEMA tooling OWNER TO postgres;

--
-- TOC entry 20 (class 2615 OID 76402)
-- Name: transactor; Type: SCHEMA; Schema: -; Owner: postgres
--

CREATE SCHEMA transactor;


ALTER SCHEMA transactor OWNER TO postgres;

--
-- TOC entry 21 (class 2615 OID 76403)
-- Name: uom; Type: SCHEMA; Schema: -; Owner: postgres
--

CREATE SCHEMA uom;


ALTER SCHEMA uom OWNER TO postgres;

--
-- TOC entry 2 (class 3079 OID 13343)
-- Name: plpgsql; Type: EXTENSION; Schema: -; Owner: 
--

CREATE EXTENSION IF NOT EXISTS plpgsql WITH SCHEMA pg_catalog;


--
-- TOC entry 3515 (class 0 OID 0)
-- Dependencies: 2
-- Name: EXTENSION plpgsql; Type: COMMENT; Schema: -; Owner: 
--

COMMENT ON EXTENSION plpgsql IS 'PL/pgSQL procedural language';


--
-- TOC entry 1 (class 3079 OID 76404)
-- Name: adminpack; Type: EXTENSION; Schema: -; Owner: 
--

CREATE EXTENSION IF NOT EXISTS adminpack WITH SCHEMA pg_catalog;


--
-- TOC entry 3516 (class 0 OID 0)
-- Dependencies: 1
-- Name: EXTENSION adminpack; Type: COMMENT; Schema: -; Owner: 
--

COMMENT ON EXTENSION adminpack IS 'administrative functions for PostgreSQL';


--
-- TOC entry 5 (class 3079 OID 76413)
-- Name: pldbgapi; Type: EXTENSION; Schema: -; Owner: 
--

CREATE EXTENSION IF NOT EXISTS pldbgapi WITH SCHEMA public;


--
-- TOC entry 3517 (class 0 OID 0)
-- Dependencies: 5
-- Name: EXTENSION pldbgapi; Type: COMMENT; Schema: -; Owner: 
--

COMMENT ON EXTENSION pldbgapi IS 'server-side support for debugging PL/pgSQL functions';


--
-- TOC entry 4 (class 3079 OID 76450)
-- Name: plpgsql_check; Type: EXTENSION; Schema: -; Owner: 
--

CREATE EXTENSION IF NOT EXISTS plpgsql_check WITH SCHEMA public;


--
-- TOC entry 3518 (class 0 OID 0)
-- Dependencies: 4
-- Name: EXTENSION plpgsql_check; Type: COMMENT; Schema: -; Owner: 
--

COMMENT ON EXTENSION plpgsql_check IS 'extended check for plpgsql functions';


--
-- TOC entry 3 (class 3079 OID 76455)
-- Name: uuid-ossp; Type: EXTENSION; Schema: -; Owner: 
--

CREATE EXTENSION IF NOT EXISTS "uuid-ossp" WITH SCHEMA public;


--
-- TOC entry 3519 (class 0 OID 0)
-- Dependencies: 3
-- Name: EXTENSION "uuid-ossp"; Type: COMMENT; Schema: -; Owner: 
--

COMMENT ON EXTENSION "uuid-ossp" IS 'generate universally unique identifiers (UUIDs)';


SET search_path = common, pg_catalog;

--
-- TOC entry 702 (class 1247 OID 76467)
-- Name: day_kind; Type: TYPE; Schema: common; Owner: postgres
--

CREATE TYPE day_kind AS ENUM (
    'WORKDAY',
    'HOLIDAY'
);


ALTER TYPE day_kind OWNER TO postgres;

--
-- TOC entry 705 (class 1247 OID 76472)
-- Name: document_fsmt; Type: TYPE; Schema: common; Owner: postgres
--

CREATE TYPE document_fsmt AS ENUM (
    'PROPOSED',
    'COMMITTED',
    'DECOMMITTED'
);


ALTER TYPE document_fsmt OWNER TO postgres;

--
-- TOC entry 708 (class 1247 OID 76480)
-- Name: document_kind; Type: TYPE; Schema: common; Owner: postgres
--

CREATE TYPE document_kind AS ENUM (
    'INVENTORY'
);


ALTER TYPE document_kind OWNER TO postgres;

--
-- TOC entry 711 (class 1247 OID 76484)
-- Name: facility_kind; Type: TYPE; Schema: common; Owner: postgres
--

CREATE TYPE facility_kind AS ENUM (
    'ENTERPRISE',
    'SITE',
    'AREA',
    'LINE',
    'ZONE'
);


ALTER TYPE facility_kind OWNER TO postgres;

--
-- TOC entry 714 (class 1247 OID 76497)
-- Name: facility_head; Type: TYPE; Schema: common; Owner: postgres
--

CREATE TYPE facility_head AS (
	document_id bigint,
	gid uuid,
	facility_code character varying,
	version_num integer,
	display_name character varying,
	document_date date,
	parent_facility_code character varying,
	facility_type facility_kind
);


ALTER TYPE facility_head OWNER TO postgres;

--
-- TOC entry 717 (class 1247 OID 76500)
-- Name: inventory_head; Type: TYPE; Schema: common; Owner: postgres
--

CREATE TYPE inventory_head AS (
	document_id bigint,
	gid uuid,
	display_name character varying,
	part_code character varying,
	version_num integer,
	document_date date,
	uom_code character varying,
	curr_fsmt document_fsmt,
	document_type document_kind
);


ALTER TYPE inventory_head OWNER TO postgres;

--
-- TOC entry 720 (class 1247 OID 76502)
-- Name: inventory_kind; Type: TYPE; Schema: common; Owner: postgres
--

CREATE TYPE inventory_kind AS ENUM (
    'ASSEMBLY',
    'PART',
    'BUYABLE',
    'CONSUMABLE',
    'PRODUCIBLE',
    'PRIMAL',
    'SALABLE',
    'STORABLE'
);


ALTER TYPE inventory_kind OWNER TO postgres;

--
-- TOC entry 723 (class 1247 OID 76521)
-- Name: unit_conversion_type; Type: TYPE; Schema: common; Owner: postgres
--

CREATE TYPE unit_conversion_type AS (
	uom_code_from character varying,
	uom_code_to character varying,
	factor numeric
);


ALTER TYPE unit_conversion_type OWNER TO postgres;

--
-- TOC entry 726 (class 1247 OID 76524)
-- Name: inventory_document; Type: TYPE; Schema: common; Owner: postgres
--

CREATE TYPE inventory_document AS (
	head inventory_head,
	meas unit_conversion_type[],
	kind inventory_kind[]
);


ALTER TYPE inventory_document OWNER TO postgres;

--
-- TOC entry 729 (class 1247 OID 76525)
-- Name: quantity; Type: DOMAIN; Schema: common; Owner: postgres
--

CREATE DOMAIN quantity AS numeric(20,4) DEFAULT 0
	CONSTRAINT quantity_is_positive CHECK ((VALUE >= (0)::numeric));


ALTER DOMAIN quantity OWNER TO postgres;

--
-- TOC entry 3520 (class 0 OID 0)
-- Dependencies: 729
-- Name: DOMAIN quantity; Type: COMMENT; Schema: common; Owner: postgres
--

COMMENT ON DOMAIN quantity IS 'quantity domain';


--
-- TOC entry 731 (class 1247 OID 76527)
-- Name: quantity_signed; Type: DOMAIN; Schema: common; Owner: postgres
--

CREATE DOMAIN quantity_signed AS numeric(20,4) DEFAULT 0;


ALTER DOMAIN quantity_signed OWNER TO postgres;

--
-- TOC entry 3521 (class 0 OID 0)
-- Dependencies: 731
-- Name: DOMAIN quantity_signed; Type: COMMENT; Schema: common; Owner: postgres
--

COMMENT ON DOMAIN quantity_signed IS 'quantity signed domain';


--
-- TOC entry 732 (class 1247 OID 76529)
-- Name: uom_domain_kind; Type: TYPE; Schema: common; Owner: postgres
--

CREATE TYPE uom_domain_kind AS ENUM (
    'LENGHT',
    'MASS',
    'QUANTITY',
    'VOLUME'
);


ALTER TYPE uom_domain_kind OWNER TO postgres;

--
-- TOC entry 735 (class 1247 OID 76539)
-- Name: uom_head; Type: TYPE; Schema: common; Owner: postgres
--

CREATE TYPE uom_head AS (
	uom_code character varying,
	uom_domain uom_domain_kind,
	base_uom_code character varying,
	factor numeric
);


ALTER TYPE uom_head OWNER TO postgres;

SET search_path = facility, pg_catalog;

--
-- TOC entry 272 (class 1255 OID 76540)
-- Name: destroy(bigint); Type: FUNCTION; Schema: facility; Owner: postgres
--

CREATE FUNCTION destroy(__document_id bigint) RETURNS void
    LANGUAGE plpgsql
    AS $$
BEGIN
  DELETE FROM facility.information WHERE id = __document_id;
END;
$$;


ALTER FUNCTION facility.destroy(__document_id bigint) OWNER TO postgres;

--
-- TOC entry 288 (class 1255 OID 76541)
-- Name: get_head(bigint); Type: FUNCTION; Schema: facility; Owner: postgres
--

CREATE FUNCTION get_head(__document_id bigint) RETURNS common.facility_head
    LANGUAGE plpgsql
    AS $$
DECLARE
BEGIN
  RETURN 
    (information.id, 
    information.gid, 
    information.facility_code, 
    information.version_num, 
    information.display_name, 
    information.published_date, 
    information.parent_facility_code, 
    information.facility_type)::common.facility_head
  FROM 
    facility.information
  WHERE 
    information.id = __document_id;
END;
$$;


ALTER FUNCTION facility.get_head(__document_id bigint) OWNER TO postgres;

--
-- TOC entry 289 (class 1255 OID 76542)
-- Name: get_head_batch(common.facility_kind); Type: FUNCTION; Schema: facility; Owner: postgres
--

CREATE FUNCTION get_head_batch(__facility_type common.facility_kind DEFAULT NULL::common.facility_kind) RETURNS common.facility_head[]
    LANGUAGE plpgsql
    AS $$
DECLARE
BEGIN
  IF (__facility_type IS NULL) THEN
    RETURN
      ARRAY (
        SELECT
          (information.id, 
          information.gid, 
          information.facility_code, 
          information.version_num, 
          information.display_name, 
          information.published_date, 
          information.parent_facility_code, 
          information.facility_type)::common.facility_head
        FROM 
          facility.information
      );
  ELSE
    RETURN 
      ARRAY (
        SELECT
          (information.id, 
          information.gid, 
          information.facility_code, 
          information.version_num, 
          information.display_name, 
          information.published_date, 
          information.parent_facility_code, 
          information.facility_type)::common.facility_head
        FROM 
          facility.information
        WHERE 
          information.facility_type = __facility_type
      );
  END IF;
END;
$$;


ALTER FUNCTION facility.get_head_batch(__facility_type common.facility_kind) OWNER TO postgres;

--
-- TOC entry 290 (class 1255 OID 76543)
-- Name: init(common.facility_head); Type: FUNCTION; Schema: facility; Owner: postgres
--

CREATE FUNCTION init(__head common.facility_head) RETURNS bigint
    LANGUAGE plpgsql
    AS $$
DECLARE
  _information_id bigint;
BEGIN


  CASE __head.facility_type
    WHEN 'ENTERPRISE'::common.facility_kind THEN 
      INSERT INTO
        facility.enterprise (
          id, 
          gid, 
          facility_code, 
          version_num, 
          display_name, 
          published_date, 
          parent_facility_code, 
          facility_type)
      VALUES (
        DEFAULT,
        __head.gid,
        __head.facility_code,
        DEFAULT,
        __head.display_name,
        __head.document_date,
        __head.parent_facility_code,
        __head.facility_type)
      RETURNING id INTO _information_id;

    WHEN 'SITE'::common.facility_kind THEN
      INSERT INTO
        facility.site (
          id, 
          gid, 
          facility_code, 
          version_num, 
          display_name, 
          published_date, 
          parent_facility_code, 
          facility_type)
      VALUES (
        DEFAULT,
        __head.gid,
        __head.facility_code,
        DEFAULT,
        __head.display_name,
        __head.document_date,
        __head.parent_facility_code,
        __head.facility_type)
      RETURNING id INTO _information_id;

    WHEN 'AREA'::common.facility_kind THEN 
      INSERT INTO
        facility.area (
          id, 
          gid, 
          facility_code, 
          version_num, 
          display_name, 
          published_date, 
          parent_facility_code, 
          facility_type)
      VALUES (
        DEFAULT,
        __head.gid,
        __head.facility_code,
        DEFAULT,
        __head.display_name,
        __head.document_date,
        __head.parent_facility_code,
        __head.facility_type)
      RETURNING id INTO _information_id;

    WHEN 'LINE'::common.facility_kind THEN 
      INSERT INTO
        facility.line (
          id, 
          gid, 
          facility_code, 
          version_num, 
          display_name, 
          published_date, 
          parent_facility_code, 
          facility_type)
      VALUES (
        DEFAULT,
        __head.gid,
        __head.facility_code,
        DEFAULT,
        __head.display_name,
        __head.document_date,
        __head.parent_facility_code,
        __head.facility_type)
      RETURNING id INTO _information_id;

    WHEN 'ZONE'::common.facility_kind THEN 
      INSERT INTO
        facility.zone (
          id, 
          gid, 
          facility_code, 
          version_num, 
          display_name, 
          published_date, 
          parent_facility_code, 
          facility_type)
      VALUES (
        DEFAULT,
        __head.gid,
        __head.facility_code,
        DEFAULT,
        __head.display_name,
        __head.document_date,
        __head.parent_facility_code,
        __head.facility_type)
      RETURNING id INTO _information_id;

    ELSE
      RAISE EXCEPTION 'unsupported facility_type %', __head.facility_type;

    END CASE;

    RETURN _information_id;

END;
$$;


ALTER FUNCTION facility.init(__head common.facility_head) OWNER TO postgres;

--
-- TOC entry 291 (class 1255 OID 76544)
-- Name: reinit(common.facility_head); Type: FUNCTION; Schema: facility; Owner: postgres
--

CREATE FUNCTION reinit(__head common.facility_head) RETURNS void
    LANGUAGE plpgsql
    AS $$
DECLARE
BEGIN
  --DELETE FROM facility.information WHERE id = __head.document_id;

  CASE __head.facility_type
    WHEN 'ENTERPRISE'::common.facility_kind THEN 
      UPDATE
        facility.enterprise
      SET 
        --facility_code = __head.facility_code, 
        --version_num = __head.version_num, 
        display_name = __head.display_name, 
        published_date = __head.document_date, 
        parent_facility_code = __head.parent_facility_code
      WHERE
        id = __head.document_id;

    WHEN 'SITE'::common.facility_kind THEN
      UPDATE
        facility.site
      SET 
        --facility_code = __head.facility_code, 
        --version_num = __head.version_num, 
        display_name = __head.display_name, 
        published_date = __head.document_date, 
        parent_facility_code = __head.parent_facility_code
      WHERE
        id = __head.document_id;

    WHEN 'AREA'::common.facility_kind THEN 
      UPDATE
        facility.area
      SET 
        --facility_code = __head.facility_code, 
        --version_num = __head.version_num, 
        display_name = __head.display_name, 
        published_date = __head.document_date, 
        parent_facility_code = __head.parent_facility_code
      WHERE
        id = __head.document_id;

    WHEN 'LINE'::common.facility_kind THEN 
      UPDATE
        facility.line
      SET 
        --facility_code = __head.facility_code, 
        --version_num = __head.version_num, 
        display_name = __head.display_name, 
        published_date = __head.document_date, 
        parent_facility_code = __head.parent_facility_code
      WHERE
        id = __head.document_id;

    WHEN 'ZONE'::common.facility_kind THEN 
      UPDATE
        facility.zone
      SET 
        --facility_code = __head.facility_code, 
        --version_num = __head.version_num, 
        display_name = __head.display_name, 
        published_date = __head.document_date, 
        parent_facility_code = __head.parent_facility_code
      WHERE
        id = __head.document_id;

    ELSE
      RAISE EXCEPTION 'unsupported facility_type %', __head.facility_type;

    END CASE;

END;
$$;


ALTER FUNCTION facility.reinit(__head common.facility_head) OWNER TO postgres;

SET search_path = inventory, pg_catalog;

--
-- TOC entry 292 (class 1255 OID 76545)
-- Name: convert_quantity(character varying, integer, common.quantity, character varying, character varying); Type: FUNCTION; Schema: inventory; Owner: postgres
--

CREATE FUNCTION convert_quantity(_part_code character varying, _version_num integer, _quantity common.quantity, _uom_code_from character varying, _uom_code_to character varying) RETURNS double precision
    LANGUAGE plpgsql
    AS $$

DECLARE
  __uom_domain_to character varying;
  __uom_domain_from character varying;
  __unit_conversion_factors common.unit_conversion_type[];
  __m common.unit_conversion_type;
  __exponentiation integer DEFAULT 1;

BEGIN

  /*
  case
    when __array @> ARRAY[30] then
      raise notice 'msg %', 0;
    when __array @> ARRAY[20] then
      raise notice 'msg %', 1;
    when __array @> ARRAY[10] then
      raise notice 'msg %', 0;
  end case;

  raise NOTICE 'array dump %', __unit_conversion_factors;
  raise NOTICE 'array unnest %', unnest(array[__unit_conversion_factors[1]]);


  case when __unit_conversion_factors @> ARRAY[(_uom_code_from,_uom_code_to,null)::mdm.unit_conversion_type] THEN
  RAISE NOTICE 'ok %', __unit_conversion_factors;
  else RAISE NOTICE 'not ok %', __unit_conversion_factors;
  end case
  
  */

  -- визначити домен одиниці виміру, до якої приводимо
  __uom_domain_to := uom.get_domain(_uom_code := _uom_code_to);
  -- визначити домен одиниці виміру, з якої приводимо
  __uom_domain_from := uom.get_domain(_uom_code := _uom_code_from);

  --RAISE NOTICE 'conversion from % to %', __uom_domain_to, __uom_domain_from;

  -- якщо той самий домен, то використовуємо коефіцієнт Сі
  IF (__uom_domain_from = __uom_domain_to) THEN
    --RAISE NOTICE 'formula = % * %', _quantity, mdm.get_factor(_uom_code_from, _uom_code_to);
    RETURN _quantity * uom.get_factor(_uom_code_from, _uom_code_to);
  END IF;

    __unit_conversion_factors := inventory.get_uom_conversion_factors(
      _part_code := _part_code,
      _version_num := _version_num,
      _uom_domain_from := __uom_domain_from,
      _uom_domain_to := __uom_domain_to);

    -- логіка перетворення з основного домену в додатковий
    IF (array_ndims(__unit_conversion_factors) >= 1) THEN

      FOREACH __m IN
        ARRAY __unit_conversion_factors
      LOOP 
        IF (__m.uom_code_from = _uom_code_from AND __m.uom_code_to = _uom_code_to) THEN
          RAISE NOTICE 'full forward match % to % = %',_uom_code_from, _uom_code_to, __m.factor;
          RETURN _quantity * (__m.factor ^ __exponentiation);
        END IF;
      END LOOP;

      FOREACH __m IN
        ARRAY __unit_conversion_factors
      LOOP 
        IF ( __m.uom_code_from = _uom_code_from) THEN
          RAISE NOTICE 'partial forward _from_ match % to % = %',_uom_code_from, __m.uom_code_to, __m.factor;
          RETURN _quantity *  
            (__m.factor ^ __exponentiation) *
            uom.get_factor(_uom_code_to, __m.uom_code_to);
        END IF;
      END LOOP;

      FOREACH __m IN
        ARRAY __unit_conversion_factors
      LOOP 
        IF ( __m.uom_code_to = _uom_code_to) THEN
          RAISE NOTICE 'partial forward _to_ match % to % = %',__m.uom_code_from, _uom_code_to, __m.factor;
          RETURN _quantity * 
            (__m.factor ^ __exponentiation) * 
            uom.get_factor(_uom_code_from, __m.uom_code_from);
        END IF;
      END LOOP;

      RAISE NOTICE 'finally forward match % to % = %', 
        __unit_conversion_factors[1].uom_code_from, 
        __unit_conversion_factors[1].uom_code_to, 
        __unit_conversion_factors[1].factor;
      RETURN _quantity * 
        uom.get_factor(_uom_code_from, __unit_conversion_factors[1].uom_code_from) * 
        (__unit_conversion_factors[1].factor ^ __exponentiation) *
        uom.get_factor(__unit_conversion_factors[1].uom_code_to, _uom_code_to);

    -- логіка перетворення з додаткового в основний домен
    ELSE
      __unit_conversion_factors := inventory.get_uom_conversion_factors(
        _part_code := _part_code,
        _version_num := _version_num,
        _uom_domain_from := __uom_domain_to,
        _uom_domain_to := __uom_domain_from);

      IF (array_ndims(__unit_conversion_factors) >= 1) THEN
        __exponentiation := -1;

        FOREACH __m IN
          ARRAY __unit_conversion_factors
        LOOP 
          IF (__m.uom_code_from = _uom_code_to AND __m.uom_code_to = _uom_code_from) THEN
            RAISE NOTICE 'full reverse match % to % = %',_uom_code_from, _uom_code_to, __m.factor;
            RETURN _quantity * (__m.factor ^ __exponentiation);
          END IF;
        END LOOP;

        FOREACH __m IN
          ARRAY __unit_conversion_factors
        LOOP 
          IF ( __m.uom_code_from = _uom_code_to) THEN
            RAISE NOTICE 'partial reverse _from_ match % to % = %',_uom_code_from, __m.uom_code_to, __m.factor;
            RETURN _quantity *  
              (__m.factor ^ __exponentiation) *
              uom.get_factor(_uom_code_from ,  __m.uom_code_to);
          END IF;
        END LOOP;

        FOREACH __m IN
          ARRAY __unit_conversion_factors
        LOOP 
          IF ( __m.uom_code_to = _uom_code_from) THEN
            RAISE NOTICE 'partial reverse _to_ match % to % = %',__m.uom_code_to, _uom_code_from, __m.factor;
            RETURN _quantity * 
              (__m.factor ^ __exponentiation) * 
              uom.get_factor(_uom_code_to, __m.uom_code_from);
          END IF;
        END LOOP;

        RAISE NOTICE 'finally reverse match % to % = %',
          __unit_conversion_factors[1].uom_code_from,
          __unit_conversion_factors[1].uom_code_to,
          __unit_conversion_factors[1].factor;
        RETURN _quantity * 
          uom.get_factor(_uom_code_from ,  __unit_conversion_factors[1].uom_code_to) *
          (__unit_conversion_factors[1].factor ^ __exponentiation) *
          uom.get_factor(__unit_conversion_factors[1].uom_code_from, _uom_code_to);

      ELSE
        --RETURN 987654321;
        RAISE EXCEPTION 'no conversion factor found for measure domains % and % for % version %',
          __uom_domain_from,
          __uom_domain_to, 
          _part_code,
          _version_num;
          
      END IF;

    END IF;

END;

$$;


ALTER FUNCTION inventory.convert_quantity(_part_code character varying, _version_num integer, _quantity common.quantity, _uom_code_from character varying, _uom_code_to character varying) OWNER TO postgres;

--
-- TOC entry 293 (class 1255 OID 76546)
-- Name: destroy(bigint); Type: FUNCTION; Schema: inventory; Owner: postgres
--

CREATE FUNCTION destroy(__document_id bigint) RETURNS void
    LANGUAGE plpgsql
    AS $$
BEGIN
  DELETE FROM inventory.definition WHERE id = __document_id;
END;
$$;


ALTER FUNCTION inventory.destroy(__document_id bigint) OWNER TO postgres;

--
-- TOC entry 294 (class 1255 OID 76547)
-- Name: get_base_uom(character varying, integer); Type: FUNCTION; Schema: inventory; Owner: postgres
--

CREATE FUNCTION get_base_uom(_part_code character varying, _version_num integer) RETURNS character varying
    LANGUAGE plpgsql
    AS $$
BEGIN
  RETURN 
    definition.uom_code
  FROM 
    inventory.information, 
    inventory.definition
  WHERE 
    information.id = definition.information_id AND
    information.part_code = _part_code AND 
    definition.version_num = _version_num;

END;
$$;


ALTER FUNCTION inventory.get_base_uom(_part_code character varying, _version_num integer) OWNER TO postgres;

--
-- TOC entry 295 (class 1255 OID 76548)
-- Name: get_document(bigint); Type: FUNCTION; Schema: inventory; Owner: postgres
--

CREATE FUNCTION get_document(__document_id bigint) RETURNS common.inventory_document
    LANGUAGE plpgsql
    AS $$
BEGIN
  RETURN
    (inventory.get_head(__document_id),
    inventory.get_meas_spec(__document_id),
    inventory.get_kind_spec(__document_id))::common.inventory_document;
END
$$;


ALTER FUNCTION inventory.get_document(__document_id bigint) OWNER TO postgres;

--
-- TOC entry 296 (class 1255 OID 76549)
-- Name: get_head(bigint); Type: FUNCTION; Schema: inventory; Owner: postgres
--

CREATE FUNCTION get_head(__document_id bigint) RETURNS common.inventory_head
    LANGUAGE plpgsql
    AS $$
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
$$;


ALTER FUNCTION inventory.get_head(__document_id bigint) OWNER TO postgres;

--
-- TOC entry 297 (class 1255 OID 76550)
-- Name: get_head_batch(); Type: FUNCTION; Schema: inventory; Owner: postgres
--

CREATE FUNCTION get_head_batch() RETURNS common.inventory_head[]
    LANGUAGE plpgsql
    AS $$
DECLARE
BEGIN
  RETURN 
    ARRAY (
      SELECT
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
        information.id = definition.information_id --AND
        --definition.id = __document_id
    );
END;
$$;


ALTER FUNCTION inventory.get_head_batch() OWNER TO postgres;

--
-- TOC entry 298 (class 1255 OID 76551)
-- Name: get_kind_spec(bigint); Type: FUNCTION; Schema: inventory; Owner: postgres
--

CREATE FUNCTION get_kind_spec(__document_id bigint) RETURNS common.inventory_kind[]
    LANGUAGE plpgsql
    AS $$
BEGIN
  RETURN
    ARRAY (
      SELECT 
        variety.inventory_type
      FROM 
        inventory.variety
      WHERE 
        variety.definition_id = __document_id
    );
END
$$;


ALTER FUNCTION inventory.get_kind_spec(__document_id bigint) OWNER TO postgres;

--
-- TOC entry 299 (class 1255 OID 76552)
-- Name: get_meas_spec(bigint); Type: FUNCTION; Schema: inventory; Owner: postgres
--

CREATE FUNCTION get_meas_spec(__document_id bigint) RETURNS common.unit_conversion_type[]
    LANGUAGE plpgsql
    AS $$
BEGIN
  RETURN
    ARRAY (
      SELECT 
        (definition.uom_code, 
        measurement.uom_code, 
        measurement.factor)::common.unit_conversion_type
      FROM 
        inventory.definition, 
        inventory.measurement
      WHERE 
        definition.id = measurement.definition_id AND 
        definition.id = __document_id
    );
END
$$;


ALTER FUNCTION inventory.get_meas_spec(__document_id bigint) OWNER TO postgres;

--
-- TOC entry 300 (class 1255 OID 76553)
-- Name: get_uom_conversion_factors(character varying, integer, character varying, character varying); Type: FUNCTION; Schema: inventory; Owner: postgres
--

CREATE FUNCTION get_uom_conversion_factors(_part_code character varying, _version_num integer, _uom_domain_from character varying, _uom_domain_to character varying) RETURNS common.unit_conversion_type[]
    LANGUAGE plpgsql
    AS $$
DECLARE  
BEGIN

  RETURN 
    ARRAY (
      SELECT
        (definition.uom_code, 
        measurement.uom_code, 
        measurement.factor)::common.unit_conversion_type
      FROM 
        inventory.definition, 
        inventory.measurement, 
        inventory.information, 
        uom.information uom_from, 
        uom.information uom_to
      WHERE 
        definition.id = measurement.definition_id AND
        information.id = definition.information_id AND
        uom_from.uom_code = definition.uom_code AND
        uom_to.uom_code = measurement.uom_code AND
        information.part_code = _part_code AND 
        definition.version_num = _version_num AND 
        uom_from.uom_domain = _uom_domain_from AND 
        uom_to.uom_domain = _uom_domain_to
      );

END
$$;


ALTER FUNCTION inventory.get_uom_conversion_factors(_part_code character varying, _version_num integer, _uom_domain_from character varying, _uom_domain_to character varying) OWNER TO postgres;

--
-- TOC entry 301 (class 1255 OID 76554)
-- Name: init(common.inventory_head, common.unit_conversion_type[], common.inventory_kind[]); Type: FUNCTION; Schema: inventory; Owner: postgres
--

CREATE FUNCTION init(__head common.inventory_head, __meas common.unit_conversion_type[], __kind common.inventory_kind[]) RETURNS bigint
    LANGUAGE plpgsql
    AS $$
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
$$;


ALTER FUNCTION inventory.init(__head common.inventory_head, __meas common.unit_conversion_type[], __kind common.inventory_kind[]) OWNER TO postgres;

--
-- TOC entry 302 (class 1255 OID 76555)
-- Name: reinit(bigint, common.unit_conversion_type[], common.inventory_kind[]); Type: FUNCTION; Schema: inventory; Owner: postgres
--

CREATE FUNCTION reinit(__document_id bigint, __meas common.unit_conversion_type[], __kind common.inventory_kind[]) RETURNS void
    LANGUAGE plpgsql
    AS $$
DECLARE
BEGIN

  DELETE FROM
    inventory.measurement
  WHERE
    definition_id = __document_id;
  
  DELETE FROM
    inventory.variety
  WHERE
    definition_id = __document_id;

  PERFORM inventory.set_meas_spec(__document_id, __meas);
  PERFORM inventory.set_kind_spec(__document_id, __kind);

END;
$$;


ALTER FUNCTION inventory.reinit(__document_id bigint, __meas common.unit_conversion_type[], __kind common.inventory_kind[]) OWNER TO postgres;

--
-- TOC entry 303 (class 1255 OID 76556)
-- Name: set_kind_spec(bigint, common.inventory_kind[]); Type: FUNCTION; Schema: inventory; Owner: postgres
--

CREATE FUNCTION set_kind_spec(__document_id bigint, __inventory_kinds common.inventory_kind[]) RETURNS void
    LANGUAGE plpgsql
    AS $$
DECLARE
  _inventory_kind common.inventory_kind;
BEGIN
  FOREACH _inventory_kind IN
    ARRAY __inventory_kinds
  LOOP
    INSERT INTO 
      inventory.variety (
        definition_id,
        inventory_type)
    VALUES (
      __document_id,
      _inventory_kind);
  END LOOP;
END
$$;


ALTER FUNCTION inventory.set_kind_spec(__document_id bigint, __inventory_kinds common.inventory_kind[]) OWNER TO postgres;

--
-- TOC entry 304 (class 1255 OID 76557)
-- Name: set_meas_spec(bigint, common.unit_conversion_type[]); Type: FUNCTION; Schema: inventory; Owner: postgres
--

CREATE FUNCTION set_meas_spec(__document_id bigint, __uom_conversion_factors common.unit_conversion_type[]) RETURNS void
    LANGUAGE plpgsql
    AS $$
DECLARE
  _uom_conversion_factor common.unit_conversion_type;
BEGIN
  FOREACH _uom_conversion_factor IN 
    ARRAY __uom_conversion_factors
  LOOP
    INSERT INTO 
      inventory.measurement (
        definition_id,
        uom_code,
        factor)
    VALUES (
      __document_id,
      _uom_conversion_factor.uom_code_to,
      _uom_conversion_factor.factor);
  END LOOP;
END
$$;


ALTER FUNCTION inventory.set_meas_spec(__document_id bigint, __uom_conversion_factors common.unit_conversion_type[]) OWNER TO postgres;

SET search_path = pgunit, pg_catalog;

--
-- TOC entry 305 (class 1255 OID 76558)
-- Name: assert_array_equals(anyelement, anyelement, character varying); Type: FUNCTION; Schema: pgunit; Owner: postgres
--

CREATE FUNCTION assert_array_equals(_expected anyelement, _actual anyelement, _message character varying) RETURNS void
    LANGUAGE plpgsql
    AS $$
BEGIN
  IF _expected IS NULL THEN
    RAISE EXCEPTION '#incorrect_expected_value NULL';
  END IF;
  IF NOT (_expected::varchar[] @> _actual::varchar[] AND _actual::varchar[] @> _expected::varchar[])
     OR _actual IS NULL
     OR (array_dims(_expected) <> array_dims(_actual))
  THEN
    RAISE EXCEPTION E'#assert_array_equals\n%\nExpected: %\nActual: %', _message, _expected, _actual;
  END IF;
END;
$$;


ALTER FUNCTION pgunit.assert_array_equals(_expected anyelement, _actual anyelement, _message character varying) OWNER TO postgres;

--
-- TOC entry 306 (class 1255 OID 76559)
-- Name: assert_equals(anyelement, anyelement, character varying); Type: FUNCTION; Schema: pgunit; Owner: postgres
--

CREATE FUNCTION assert_equals(_expected anyelement, _actual anyelement, _message character varying) RETURNS void
    LANGUAGE plpgsql
    AS $$
BEGIN
  IF _expected IS NULL THEN
    RAISE EXCEPTION '#incorrect_expected_value NULL';
  END IF;
  IF _expected IS DISTINCT FROM _actual THEN
    RAISE EXCEPTION E'#assert_equals\n%\nExpected: %\nActual: %', _message, _expected, _actual;
  END IF;
END;
$$;


ALTER FUNCTION pgunit.assert_equals(_expected anyelement, _actual anyelement, _message character varying) OWNER TO postgres;

--
-- TOC entry 307 (class 1255 OID 76560)
-- Name: assert_false(boolean, character varying); Type: FUNCTION; Schema: pgunit; Owner: postgres
--

CREATE FUNCTION assert_false(_value boolean, _message character varying) RETURNS void
    LANGUAGE plpgsql
    AS $$
BEGIN
  IF _value OR _value IS NULL THEN
    RAISE EXCEPTION E'#assert_false\n%\nValue: %', _message, _value;
  END IF;
END;
$$;


ALTER FUNCTION pgunit.assert_false(_value boolean, _message character varying) OWNER TO postgres;

--
-- TOC entry 308 (class 1255 OID 76561)
-- Name: assert_not_equals(anyelement, anyelement, character varying); Type: FUNCTION; Schema: pgunit; Owner: postgres
--

CREATE FUNCTION assert_not_equals(_expected anyelement, _actual anyelement, _message character varying) RETURNS void
    LANGUAGE plpgsql
    AS $$
BEGIN
  IF _expected IS NULL THEN
    RAISE EXCEPTION '#incorrect_expected_value NULL';
  END IF;
  IF _expected IS NOT DISTINCT FROM _actual THEN
    RAISE EXCEPTION E'#assert_not_equals\n%\nExpected: %\nActual: %', _message, _expected, _actual;
  END IF;
END;
$$;


ALTER FUNCTION pgunit.assert_not_equals(_expected anyelement, _actual anyelement, _message character varying) OWNER TO postgres;

--
-- TOC entry 309 (class 1255 OID 76562)
-- Name: assert_not_null(anyelement, character varying); Type: FUNCTION; Schema: pgunit; Owner: postgres
--

CREATE FUNCTION assert_not_null(_value anyelement, _message character varying) RETURNS void
    LANGUAGE plpgsql
    AS $$
BEGIN
  IF _value IS NULL THEN
    RAISE EXCEPTION E'#assert_not_null\n%', _message;
  END IF;
END;
$$;


ALTER FUNCTION pgunit.assert_not_null(_value anyelement, _message character varying) OWNER TO postgres;

--
-- TOC entry 310 (class 1255 OID 76563)
-- Name: assert_null(anyelement, character varying); Type: FUNCTION; Schema: pgunit; Owner: postgres
--

CREATE FUNCTION assert_null(_value anyelement, _message character varying) RETURNS void
    LANGUAGE plpgsql
    AS $$
BEGIN
  IF _value IS NOT NULL THEN
    RAISE EXCEPTION E'#assert_null\n%\nValue: %', _message, _value;
  END IF;
END;
$$;


ALTER FUNCTION pgunit.assert_null(_value anyelement, _message character varying) OWNER TO postgres;

--
-- TOC entry 311 (class 1255 OID 76564)
-- Name: assert_true(boolean, character varying); Type: FUNCTION; Schema: pgunit; Owner: postgres
--

CREATE FUNCTION assert_true(_value boolean, _message character varying) RETURNS void
    LANGUAGE plpgsql
    AS $$
BEGIN
  IF NOT _value OR _value IS NULL THEN
    RAISE EXCEPTION E'#assert_true\n%\nValue: %', _message, _value;
  END IF;
END;
$$;


ALTER FUNCTION pgunit.assert_true(_value boolean, _message character varying) OWNER TO postgres;

--
-- TOC entry 312 (class 1255 OID 76565)
-- Name: fail(character varying); Type: FUNCTION; Schema: pgunit; Owner: postgres
--

CREATE FUNCTION fail(_message character varying) RETURNS void
    LANGUAGE plpgsql
    AS $$
BEGIN
  RAISE EXCEPTION E'#fail\n%', _message;
END;
$$;


ALTER FUNCTION pgunit.fail(_message character varying) OWNER TO postgres;

--
-- TOC entry 313 (class 1255 OID 76566)
-- Name: run_test(character varying); Type: FUNCTION; Schema: pgunit; Owner: postgres
--

CREATE FUNCTION run_test(_sp character varying) RETURNS character varying
    LANGUAGE plpgsql
    AS $$
BEGIN
  EXECUTE 'SELECT ' || _sp;
  RAISE EXCEPTION '#OK';
EXCEPTION
  WHEN others THEN
    RETURN SQLERRM;
END;
$$;


ALTER FUNCTION pgunit.run_test(_sp character varying) OWNER TO postgres;

--
-- TOC entry 314 (class 1255 OID 76567)
-- Name: test_assert_array_equals(); Type: FUNCTION; Schema: pgunit; Owner: postgres
--

CREATE FUNCTION test_assert_array_equals() RETURNS void
    LANGUAGE plpgsql
    AS $$
DECLARE
  _message  varchar;
BEGIN
  _message := 'qazwsxedc';

  -- EMPTY ARRAYS

  PERFORM pgunit.assert_array_equals('{}'::varchar[], '{}'::varchar[], _message);

  BEGIN
    PERFORM pgunit.assert_array_equals('{}'::varchar[], array['1']::varchar[], _message);
    RAISE EXCEPTION 'Epic fail. Line: 18';
  EXCEPTION
    WHEN others THEN
      IF SQLERRM NOT ILIKE E'#assert_array_equals\n%' THEN
        RAISE;
      END IF;
  END;

  BEGIN
    PERFORM pgunit.assert_array_equals(array['1']::varchar[], '{}'::varchar[], _message);
    RAISE EXCEPTION 'Epic fail. Line: 28';
  EXCEPTION
    WHEN others THEN
      IF SQLERRM NOT ILIKE E'#assert_array_equals\n%' THEN
        RAISE;
      END IF;
  END;

  BEGIN
    PERFORM pgunit.assert_array_equals(array['1']::varchar[], NULL::varchar[], _message);
    RAISE EXCEPTION 'Epic fail. Line: 38';
  EXCEPTION
    WHEN others THEN
      IF SQLERRM NOT ILIKE E'#assert_array_equals\n%' THEN
        RAISE;
      END IF;
  END;

  BEGIN
    PERFORM pgunit.assert_array_equals('{}'::varchar[], NULL::varchar[], _message);
    RAISE EXCEPTION 'Epic fail. Line: 48';
  EXCEPTION
    WHEN others THEN
      IF SQLERRM NOT ILIKE E'#assert_array_equals\n%' THEN
        RAISE;
      END IF;
  END;

  BEGIN
    PERFORM pgunit.assert_array_equals(NULL::varchar[], array['1']::varchar[], _message);
    RAISE EXCEPTION 'Epic fail. Line: 58';
  EXCEPTION
    WHEN others THEN
      IF SQLERRM NOT ILIKE E'#incorrect_expected_value %' THEN
        RAISE;
      END IF;
  END;

  -- UNARY ARRAY

  PERFORM pgunit.assert_array_equals(array['1']::varchar[], array['1']::varchar[], _message);

  BEGIN
    PERFORM pgunit.assert_array_equals(array['2']::varchar[], array['1']::varchar[], _message);
    RAISE EXCEPTION 'Epic fail. Line: 72';
  EXCEPTION
    WHEN others THEN
      IF SQLERRM NOT ILIKE E'#assert_array_equals\n%' THEN
        RAISE;
      END IF;
  END;

  -- ARRAYS

  PERFORM pgunit.assert_array_equals(array['1', '2']::varchar[], array['1', '2']::varchar[], _message);
  PERFORM pgunit.assert_array_equals(array['2', '1']::varchar[], array['1', '2']::varchar[], _message);
  PERFORM pgunit.assert_array_equals(array['1', '2', '3']::varchar[], array['1', '3', '2']::varchar[], _message);


  BEGIN
    PERFORM pgunit.assert_array_equals(array['1', '2', '3']::varchar[], array['1', '3', '2', '2']::varchar[], _message);
    RAISE EXCEPTION 'Epic fail. Line: 77';
  EXCEPTION
  WHEN others THEN
    IF SQLERRM NOT ILIKE E'#assert_array_equals\n%' THEN
      RAISE;
    END IF;
  END;


  BEGIN
    PERFORM pgunit.assert_array_equals(array['1', '2', '3']::varchar[], array['1', '2', '2']::varchar[], _message);
    RAISE EXCEPTION 'Epic fail. Line: 89';
  EXCEPTION
    WHEN others THEN
      IF SQLERRM NOT ILIKE E'#assert_array_equals\n%' THEN
        RAISE;
      END IF;
  END;

  BEGIN
    PERFORM pgunit.assert_array_equals(array['1', '2', '3']::varchar[], array['4', '5', '6']::varchar[], _message);
    RAISE EXCEPTION 'Epic fail. Line: 99';
  EXCEPTION
    WHEN others THEN
      IF SQLERRM NOT ILIKE E'#assert_array_equals\n%' THEN
        RAISE;
      END IF;
  END;
END;
$$;


ALTER FUNCTION pgunit.test_assert_array_equals() OWNER TO postgres;

--
-- TOC entry 315 (class 1255 OID 76568)
-- Name: test_assert_equals(); Type: FUNCTION; Schema: pgunit; Owner: postgres
--

CREATE FUNCTION test_assert_equals() RETURNS void
    LANGUAGE plpgsql
    AS $$
DECLARE

  _message  varchar;
BEGIN
  _message := 'qazwsxedc';

  -- INT

  PERFORM pgunit.assert_equals(1::int, 1::int, _message);

  BEGIN
    PERFORM pgunit.assert_equals(1::int, 2::int, _message);
    RAISE EXCEPTION 'Epic fail. Line: 18';
  EXCEPTION
    WHEN others THEN
      IF SQLERRM NOT ILIKE E'#assert_equals\n%' THEN
        RAISE;
      END IF;
  END;

  BEGIN
    PERFORM pgunit.assert_equals(1::int, NULL::int, _message);
    RAISE EXCEPTION 'Epic fail. Line: 28';
  EXCEPTION
    WHEN others THEN
      IF SQLERRM NOT ILIKE E'#assert_equals\n%' THEN
        RAISE;
      END IF;
  END;

  -- INT8

  PERFORM pgunit.assert_equals(1::int8, 1::int8, _message);

  BEGIN
    PERFORM pgunit.assert_equals(1::int8, 2::int8, _message);
    RAISE EXCEPTION 'Epic fail. Line: 42';
  EXCEPTION
    WHEN others THEN
      IF SQLERRM NOT ILIKE E'#assert_equals\n%' THEN
        RAISE;
      END IF;
  END;

  -- NUMERIC

  PERFORM pgunit.assert_equals(1.1::numeric, 1.1::numeric, _message);

  BEGIN
    PERFORM pgunit.assert_equals(1.1::numeric, 1.2::numeric, _message);
    RAISE EXCEPTION 'Epic fail. Line: 56';
  EXCEPTION
    WHEN others THEN
      IF SQLERRM NOT ILIKE E'#assert_equals\n%' THEN
        RAISE;
      END IF;
  END;

  -- VARCHAR

  PERFORM pgunit.assert_equals('1.1'::varchar, '1.1'::varchar, _message);

  BEGIN
    PERFORM pgunit.assert_equals('1.1'::varchar, '1.1 '::varchar, _message);
    RAISE EXCEPTION 'Epic fail. Line: 70';
  EXCEPTION
    WHEN others THEN
      IF SQLERRM NOT ILIKE E'#assert_equals\n%' THEN
        RAISE;
      END IF;
  END;

  -- TEXT

  PERFORM pgunit.assert_equals('1.1'::text, '1.1'::text, _message);

  BEGIN
    PERFORM pgunit.assert_equals('1.1'::text, '1.1 '::text, _message);
    RAISE EXCEPTION 'Epic fail. Line: 84';
  EXCEPTION
    WHEN others THEN
      IF SQLERRM NOT ILIKE E'#assert_equals\n%' THEN
        RAISE;
      END IF;
  END;
END;
$$;


ALTER FUNCTION pgunit.test_assert_equals() OWNER TO postgres;

--
-- TOC entry 316 (class 1255 OID 76569)
-- Name: test_assert_false(); Type: FUNCTION; Schema: pgunit; Owner: postgres
--

CREATE FUNCTION test_assert_false() RETURNS void
    LANGUAGE plpgsql
    AS $$
DECLARE

  _message  varchar;
BEGIN
  _message := 'qazwsxedc';

  PERFORM pgunit.assert_false(False, _message);

  BEGIN
    PERFORM pgunit.assert_false(True, _message);
    RAISE EXCEPTION 'Epic fail. Line: 16';
  EXCEPTION
    WHEN others THEN
      IF SQLERRM NOT ILIKE E'#assert_false\n%' THEN
        RAISE;
      END IF;
  END;

  BEGIN
    PERFORM pgunit.assert_false(NULL::boolean, _message);
    RAISE EXCEPTION 'Epic fail. Line: 26';
  EXCEPTION
    WHEN others THEN
      IF SQLERRM NOT ILIKE E'#assert_false\n%' THEN
        RAISE;
      END IF;
  END;

END;
$$;


ALTER FUNCTION pgunit.test_assert_false() OWNER TO postgres;

--
-- TOC entry 317 (class 1255 OID 76570)
-- Name: test_assert_not_null(); Type: FUNCTION; Schema: pgunit; Owner: postgres
--

CREATE FUNCTION test_assert_not_null() RETURNS void
    LANGUAGE plpgsql
    AS $$
DECLARE

  _message  varchar;
BEGIN
  _message := 'qazwsxedc';

  -- INT4

  PERFORM pgunit.assert_not_null(1::int4, _message);

  BEGIN
    PERFORM pgunit.assert_not_null(NULL::int4, _message);
    RAISE EXCEPTION 'Epic fail. Line: 18';
  EXCEPTION
    WHEN others THEN
      IF SQLERRM NOT ILIKE E'#assert_not_null\n%' THEN
        RAISE;
      END IF;
  END;

  -- INT8

  PERFORM pgunit.assert_not_null(1::int8, _message);

  BEGIN
    PERFORM pgunit.assert_not_null(NULL::int8, _message);
    RAISE EXCEPTION 'Epic fail. Line: 32';
  EXCEPTION
    WHEN others THEN
      IF SQLERRM NOT ILIKE E'#assert_not_null\n%' THEN
        RAISE;
      END IF;
  END;

  -- NUMERIC

  PERFORM pgunit.assert_not_null(1.1::numeric, _message);

  BEGIN
    PERFORM pgunit.assert_not_null(NULL::numeric, _message);
    RAISE EXCEPTION 'Epic fail. Line: 46';
  EXCEPTION
    WHEN others THEN
      IF SQLERRM NOT ILIKE E'#assert_not_null\n%' THEN
        RAISE;
      END IF;
  END;

  -- VARCHAR

  PERFORM pgunit.assert_not_null('1.1'::varchar, _message);

  BEGIN
    PERFORM pgunit.assert_not_null(NULL::varchar, _message);
    RAISE EXCEPTION 'Epic fail. Line: 60';
  EXCEPTION
    WHEN others THEN
      IF SQLERRM NOT ILIKE E'#assert_not_null\n%' THEN
        RAISE;
      END IF;
  END;

  -- TEXT

  PERFORM pgunit.assert_not_null('1.1'::text, _message);

  BEGIN
    PERFORM pgunit.assert_not_null(NULL::text, _message);
    RAISE EXCEPTION 'Epic fail. Line: 74';
  EXCEPTION
    WHEN others THEN
      IF SQLERRM NOT ILIKE E'#assert_not_null\n%' THEN
        RAISE;
      END IF;
  END;
END;
$$;


ALTER FUNCTION pgunit.test_assert_not_null() OWNER TO postgres;

--
-- TOC entry 318 (class 1255 OID 76571)
-- Name: test_assert_null(); Type: FUNCTION; Schema: pgunit; Owner: postgres
--

CREATE FUNCTION test_assert_null() RETURNS void
    LANGUAGE plpgsql
    AS $$
DECLARE

  _message  varchar;
BEGIN
  _message := 'qazwsxedc';

  -- INT4

  PERFORM pgunit.assert_null(NULL::int4, _message);

  BEGIN
    PERFORM pgunit.assert_null(1::int4, _message);
    RAISE EXCEPTION 'Epic fail. Line: 18';
  EXCEPTION
    WHEN others THEN
      IF SQLERRM NOT ILIKE E'#assert_null\n%' THEN
        RAISE;
      END IF;
  END;

  -- INT8

  PERFORM pgunit.assert_null(NULL::int8, _message);


  BEGIN
    PERFORM pgunit.assert_null(1::int8, _message);
    RAISE EXCEPTION 'Epic fail. Line: 33';
  EXCEPTION
    WHEN others THEN
      IF SQLERRM NOT ILIKE E'#assert_null\n%' THEN
        RAISE;
      END IF;
  END;

  -- NUMERIC

  PERFORM pgunit.assert_null(NULL::numeric, _message);

  BEGIN
    PERFORM pgunit.assert_null(1.1::numeric, _message);
    RAISE EXCEPTION 'Epic fail. Line: 47';
  EXCEPTION
    WHEN others THEN
      IF SQLERRM NOT ILIKE E'#assert_null\n%' THEN
        RAISE;
      END IF;
  END;

  -- VARCHAR

  PERFORM pgunit.assert_null(NULL::varchar, _message);

  BEGIN
    PERFORM pgunit.assert_null('1.1'::varchar, _message);
    RAISE EXCEPTION 'Epic fail. Line: 61';
  EXCEPTION
    WHEN others THEN
      IF SQLERRM NOT ILIKE E'#assert_null\n%' THEN
        RAISE;
      END IF;
  END;

  -- TEXT

  PERFORM pgunit.assert_null(NULL::text, _message);

  BEGIN
    PERFORM pgunit.assert_null('1.1'::text, _message);
    RAISE EXCEPTION 'Epic fail. Line: 75';
  EXCEPTION
    WHEN others THEN
      IF SQLERRM NOT ILIKE E'#assert_null\n%' THEN
        RAISE;
      END IF;
  END;
END;
$$;


ALTER FUNCTION pgunit.test_assert_null() OWNER TO postgres;

--
-- TOC entry 319 (class 1255 OID 76572)
-- Name: test_assert_true(); Type: FUNCTION; Schema: pgunit; Owner: postgres
--

CREATE FUNCTION test_assert_true() RETURNS void
    LANGUAGE plpgsql
    AS $$
DECLARE
  _message  varchar;
BEGIN
  _message := 'qazwsxedc';

  PERFORM pgunit.assert_true(True, _message);

  BEGIN
    PERFORM pgunit.assert_true(False, _message);
    RAISE EXCEPTION 'Epic fail. Line: 16';
  EXCEPTION
    WHEN others THEN
      IF SQLERRM NOT ILIKE E'#assert_true\n%' THEN
        RAISE;
      END IF;
  END;

  BEGIN
    PERFORM pgunit.assert_true(NULL::boolean, _message);
    RAISE EXCEPTION 'Epic fail. Line: 26';
  EXCEPTION
    WHEN others THEN
      IF SQLERRM NOT ILIKE E'#assert_true\n%' THEN
        RAISE;
      END IF;
  END;
END;
$$;


ALTER FUNCTION pgunit.test_assert_true() OWNER TO postgres;

--
-- TOC entry 320 (class 1255 OID 76573)
-- Name: test_fail(); Type: FUNCTION; Schema: pgunit; Owner: postgres
--

CREATE FUNCTION test_fail() RETURNS void
    LANGUAGE plpgsql
    AS $$
DECLARE
  _message  text;
BEGIN
  _message := 'qazwxedc';
  BEGIN
    PERFORM pgunit.fail(_message);
    RAISE EXCEPTION 'Epic fail. Line: 14';
  EXCEPTION
    WHEN others THEN
      IF SQLERRM NOT ILIKE E'#fail\n%' THEN
        RAISE;
      END IF;
  END;
END;
$$;


ALTER FUNCTION pgunit.test_fail() OWNER TO postgres;

SET search_path = tests, pg_catalog;

--
-- TOC entry 321 (class 1255 OID 76574)
-- Name: _load_data(); Type: FUNCTION; Schema: tests; Owner: postgres
--

CREATE FUNCTION _load_data() RETURNS void
    LANGUAGE plpgsql
    AS $$
BEGIN

  INSERT INTO uom.information VALUES ('kg', 'MASS', 'kg', 1);
  INSERT INTO uom.information VALUES ('m', 'LENGHT', 'm', 1);
  INSERT INTO uom.information VALUES ('pcs', 'QUANTITY', 'pcs', 1);
  INSERT INTO uom.information VALUES ('g', 'MASS', 'kg', 0.0010);
  INSERT INTO uom.information VALUES ('t', 'MASS', 'kg', 1000);
  INSERT INTO uom.information VALUES ('mm', 'LENGHT', 'm', 0.0010);
  INSERT INTO uom.information VALUES ('km', 'LENGHT', 'm', 1000);
  INSERT INTO uom.information VALUES ('cm', 'LENGHT', 'm', 0.0100);
  INSERT INTO uom.information VALUES ('l', 'VOLUME', 'l', 1);
  INSERT INTO uom.information VALUES ('ml', 'VOLUME', 'l', 0.0010);

  INSERT INTO facility.area VALUES (3, '00f11b88-fc89-11e7-b381-d4bed939923a', 'A01', 1, 'A01', '2018-01-18', 'S01', 'AREA');
  INSERT INTO facility.area VALUES (11, '2f3546bc-fca3-11e7-9533-d4bed939923a', 'A04', 1, 'A04', '2018-01-18', 'S01', 'AREA');
  INSERT INTO facility.line VALUES (4, '1e749946-fc89-11e7-b4dd-d4bed939923a', 'L01', 1, 'L01', '2018-01-18', 'A01', 'LINE');
  INSERT INTO facility.line VALUES (6, 'f0f0aacc-fca2-11e7-952e-d4bed939923a', 'L02', 1, 'L02', '2018-01-18', 'A01', 'LINE');
  INSERT INTO facility.line VALUES (7, 'fcead30c-fca2-11e7-952f-d4bed939923a', 'L03', 1, 'L03', '2018-01-18', 'A01', 'LINE');
  INSERT INTO facility.line VALUES (9, '087b7910-fca3-11e7-9531-d4bed939923a', 'L04', 1, 'L04', '2018-01-18', 'A01', 'LINE');
  INSERT INTO facility.site VALUES (2, 'e975ae6a-fc88-11e7-a8d5-d4bed939923a', 'S01', 1, 'S01', '2018-01-18', 'E01', 'SITE');
  INSERT INTO facility.site VALUES (12, '38c2ed2e-fca3-11e7-9534-d4bed939923a', 'S04', 1, 'S04', '2018-01-18', 'E01', 'SITE');

  INSERT INTO inventory.definition VALUES (1, 'c9000ec8-fa3a-11e7-9489-d4bed939923a', 'fl-16-50', 1, '2018-01-15', NULL, NULL, 'PROPOSED', '2018-01-15 23:26:44.534271+02', 1, 'pcs');
  INSERT INTO inventory.definition VALUES (2, 'd83fb96a-fa3a-11e7-948a-d4bed939923a', 'fl-25-50', 1, '2018-01-15', NULL, NULL, 'PROPOSED', '2018-01-15 23:27:10.118984+02', 2, 'pcs');
  INSERT INTO inventory.definition VALUES (3, '9d521068-fa3b-11e7-ac45-d4bed939923a', 'pipe-076x3', 1, '2018-01-15', NULL, NULL, 'PROPOSED', '2018-01-15 23:32:40.748622+02', 4, 'kg');
  INSERT INTO inventory.information VALUES (1, 'a711da30-fa3a-11e7-8e63-d4bed939923a', '22.16.050-001', 'fl-16-50', '2018-01-15');
  INSERT INTO inventory.information VALUES (2, 'b39a3ff4-fa3a-11e7-8e64-d4bed939923a', '22.25.050-001', 'fl-25-50', '2018-01-15');
  INSERT INTO inventory.information VALUES (3, 'f08b5682-fa3a-11e7-86da-d4bed939923a', '22.40.050-001', 'fl-40-50', '2018-01-15');
  INSERT INTO inventory.information VALUES (4, '7edbcfd4-fa3b-11e7-b771-d4bed939923a', 'pipe-076x3', 'pipe-076x3', '2018-01-15');
  INSERT INTO inventory.measurement VALUES (1, 'pcs', 1);
  INSERT INTO inventory.measurement VALUES (2, 'pcs', 1);
  INSERT INTO inventory.measurement VALUES (3, 'm', 25);
  INSERT INTO inventory.variety VALUES (1, 'PART');
  INSERT INTO inventory.variety VALUES (1, 'PRODUCIBLE');
  INSERT INTO inventory.variety VALUES (1, 'SALABLE');
  INSERT INTO inventory.variety VALUES (1, 'STORABLE');
  INSERT INTO inventory.variety VALUES (2, 'PART');
  INSERT INTO inventory.variety VALUES (2, 'PRODUCIBLE');
  INSERT INTO inventory.variety VALUES (2, 'SALABLE');
  INSERT INTO inventory.variety VALUES (2, 'STORABLE');
  INSERT INTO inventory.variety VALUES (3, 'STORABLE');
  INSERT INTO inventory.variety VALUES (3, 'BUYABLE');
  INSERT INTO inventory.variety VALUES (3, 'CONSUMABLE');
  INSERT INTO inventory.variety VALUES (3, 'PRIMAL');

END;
$$;


ALTER FUNCTION tests._load_data() OWNER TO postgres;

--
-- TOC entry 322 (class 1255 OID 76575)
-- Name: _reset_data(); Type: FUNCTION; Schema: tests; Owner: postgres
--

CREATE FUNCTION _reset_data() RETURNS void
    LANGUAGE plpgsql
    AS $$
BEGIN
  /*
  SELECT 'TRUNCATE TABLE ' || table_schema || '.' ||table_name || ' CASCADE;'
  FROM information_schema.tables
  WHERE table_schema NOT IN ('pg_catalog', 'information_schema', 'public', 'tests', 'common')
  ORDER BY table_schema,table_name;
  */
  TRUNCATE TABLE equipment.information CASCADE;
  TRUNCATE TABLE facility.area CASCADE;
  TRUNCATE TABLE facility.enterprise CASCADE;
  TRUNCATE TABLE facility.information CASCADE;
  TRUNCATE TABLE facility.line CASCADE;
  TRUNCATE TABLE facility.site CASCADE;
  TRUNCATE TABLE facility.zone CASCADE;
  TRUNCATE TABLE inventory.definition CASCADE;
  TRUNCATE TABLE inventory.information CASCADE;
  TRUNCATE TABLE inventory.measurement CASCADE;
  TRUNCATE TABLE inventory.variety CASCADE;
  TRUNCATE TABLE personnel.information CASCADE;
  TRUNCATE TABLE tooling.information CASCADE;
  TRUNCATE TABLE transactor.customer CASCADE;
  TRUNCATE TABLE transactor.information CASCADE;
  TRUNCATE TABLE transactor.supplier CASCADE;
  --TRUNCATE TABLE uom.assignment CASCADE;
  --TRUNCATE TABLE uom.information CASCADE;
  /*
  SELECT 'ALTER SEQUENCE ' || sequence_schema || '.' || sequence_name || ' RESTART WITH 1;'
  FROM information_schema.sequences
  WHERE sequence_catalog = 'mdm' AND sequence_schema != 'common'
  ORDER by sequence_schema, sequence_name;
  */
  ALTER SEQUENCE equipment.information_id_seq RESTART WITH 1;
  ALTER SEQUENCE facility.information_id_seq RESTART WITH 1;
  ALTER SEQUENCE inventory.definition_id_seq RESTART WITH 1;
  ALTER SEQUENCE inventory.information_id_seq RESTART WITH 1;
  ALTER SEQUENCE personnel.information_id_seq RESTART WITH 1;
  ALTER SEQUENCE tooling.information_id_seq RESTART WITH 1;
  ALTER SEQUENCE transactor.information_id_seq RESTART WITH 1;
  ALTER SEQUENCE uom.information_id_seq RESTART WITH 1;
  ALTER SEQUENCE uom.uom_role_uom_role_id_seq RESTART WITH 1;
END;
$$;


ALTER FUNCTION tests._reset_data() OWNER TO postgres;

--
-- TOC entry 323 (class 1255 OID 76576)
-- Name: _run_all(); Type: FUNCTION; Schema: tests; Owner: postgres
--

CREATE FUNCTION _run_all() RETURNS void
    LANGUAGE plpgsql
    AS $$
DECLARE
  _result text;
  _routines record;
  --_function_to_run text;
  _ok_count int DEFAULT 0;
  _error_count int DEFAULT 0;
  _failed_tests text[];
BEGIN
  SET search_path = tests, pg_catalog;
  SET client_min_messages = 'debug';
  FOR _routines IN
    SELECT
      routines.routine_name || '()' AS _function_to_run
    FROM
      information_schema.routines
    WHERE
      routines.specific_schema = 'tests' AND routines.routine_name like '\_\_%'
    ORDER BY
      routines.specific_schema, routines.routine_name
  LOOP
    _result := pgunit.run_test(_routines._function_to_run);
    RAISE NOTICE 'PERFORMING: % , RESULT: %', _routines._function_to_run, _result;
    IF (_result = '#OK') THEN
      _ok_count := _ok_count + 1;
    ELSE
      _error_count := _error_count + 1;
      _failed_tests := array_append(_failed_tests, _routines._function_to_run);
    END IF;
  END LOOP;
  RAISE NOTICE 'OK - %; ERROR - %;', _ok_count, _error_count;
  IF (_error_count > 0) THEN
  RAISE NOTICE 'FAILED: %;', _failed_tests;
  END IF;
END;
$$;


ALTER FUNCTION tests._run_all() OWNER TO postgres;

SET search_path = uom, pg_catalog;

--
-- TOC entry 324 (class 1255 OID 76577)
-- Name: get_domain(character varying); Type: FUNCTION; Schema: uom; Owner: postgres
--

CREATE FUNCTION get_domain(_uom_code character varying) RETURNS character varying
    LANGUAGE plpgsql
    AS $$
BEGIN

  RETURN uom_domain FROM uom.information WHERE uom_code = _uom_code;

END;
$$;


ALTER FUNCTION uom.get_domain(_uom_code character varying) OWNER TO postgres;

--
-- TOC entry 325 (class 1255 OID 76578)
-- Name: get_factor(character varying, character varying); Type: FUNCTION; Schema: uom; Owner: postgres
--

CREATE FUNCTION get_factor(_uom_code_src character varying, _uom_code_dst character varying) RETURNS double precision
    LANGUAGE plpgsql
    AS $$
DECLARE
  __factor_1 double precision;
  __factor_2 double precision;
  __uom_domain_from character varying;
  __uom_domain_to character varying;

BEGIN

  -- визначити домен одиниці виміру, з якої приводимо
  __uom_domain_from := uom.get_domain(_uom_code := _uom_code_src);

  -- визначити домен одиниці виміру, до якої приводимо
  __uom_domain_to := uom.get_domain(_uom_code := _uom_code_dst);

  IF (__uom_domain_from = __uom_domain_to) THEN
    -- привести з вказаної одиниці до базової Сі = *
    __factor_1 := factor
      FROM 
        uom.information
      WHERE 
        uom_code = _uom_code_src;

    -- привести з базової Сі до вказаної = /
    __factor_2 := factor
      FROM 
        uom.information
      WHERE 
        uom_code = _uom_code_dst;

    RETURN __factor_1 / __factor_2;

  ELSE
    RAISE EXCEPTION 'units of measure are not in the same domain: "%" and "%"', _uom_code_src, _uom_code_dst;
    --RETURN NULL;
  END IF;

END;
$$;


ALTER FUNCTION uom.get_factor(_uom_code_src character varying, _uom_code_dst character varying) OWNER TO postgres;

--
-- TOC entry 326 (class 1255 OID 76579)
-- Name: get_head(character varying); Type: FUNCTION; Schema: uom; Owner: postgres
--

CREATE FUNCTION get_head(__uom_code character varying) RETURNS common.uom_head
    LANGUAGE plpgsql
    AS $$
DECLARE
BEGIN
  RETURN 
    (information.uom_code, 
    information.uom_domain, 
    information.base_uom_code, 
    information.factor)::common.uom_head
  FROM 
    uom.information
  WHERE 
    information.uom_code = __uom_code;
END;
$$;


ALTER FUNCTION uom.get_head(__uom_code character varying) OWNER TO postgres;

--
-- TOC entry 327 (class 1255 OID 76580)
-- Name: get_head_batch(common.uom_domain_kind); Type: FUNCTION; Schema: uom; Owner: postgres
--

CREATE FUNCTION get_head_batch(__uom_domain common.uom_domain_kind DEFAULT NULL::common.uom_domain_kind) RETURNS common.uom_head[]
    LANGUAGE plpgsql
    AS $$
DECLARE
BEGIN
  IF (__uom_domain IS NULL) THEN
    RETURN
      ARRAY (
        SELECT 
          (information.uom_code, 
          information.uom_domain, 
          information.base_uom_code, 
          information.factor)::common.uom_head
        FROM 
          uom.information
      );
  ELSE
    RETURN 
      ARRAY (
        SELECT 
          (information.uom_code, 
          information.uom_domain, 
          information.base_uom_code, 
          information.factor)::common.uom_head
        FROM 
          uom.information
        WHERE 
          information.uom_domain = __uom_domain
      );
  END IF;
END;
$$;


ALTER FUNCTION uom.get_head_batch(__uom_domain common.uom_domain_kind) OWNER TO postgres;

SET search_path = common, pg_catalog;

SET default_tablespace = '';

SET default_with_oids = false;

--
-- TOC entry 209 (class 1259 OID 76581)
-- Name: settings; Type: TABLE; Schema: common; Owner: postgres
--

CREATE TABLE settings (
    parameter_name character varying NOT NULL,
    parameter_value character varying
);


ALTER TABLE settings OWNER TO postgres;

SET search_path = equipment, pg_catalog;

--
-- TOC entry 210 (class 1259 OID 76587)
-- Name: information; Type: TABLE; Schema: equipment; Owner: postgres
--

CREATE TABLE information (
    id bigint NOT NULL,
    gid uuid DEFAULT public.uuid_generate_v1() NOT NULL,
    equipment_code character varying NOT NULL,
    version_num integer NOT NULL,
    display_name character varying NOT NULL,
    published_date date DEFAULT now() NOT NULL
);


ALTER TABLE information OWNER TO postgres;

--
-- TOC entry 211 (class 1259 OID 76595)
-- Name: information_id_seq; Type: SEQUENCE; Schema: equipment; Owner: postgres
--

CREATE SEQUENCE information_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE information_id_seq OWNER TO postgres;

--
-- TOC entry 3522 (class 0 OID 0)
-- Dependencies: 211
-- Name: information_id_seq; Type: SEQUENCE OWNED BY; Schema: equipment; Owner: postgres
--

ALTER SEQUENCE information_id_seq OWNED BY information.id;


SET search_path = facility, pg_catalog;

--
-- TOC entry 212 (class 1259 OID 76597)
-- Name: information; Type: TABLE; Schema: facility; Owner: postgres
--

CREATE TABLE information (
    id bigint NOT NULL,
    gid uuid DEFAULT public.uuid_generate_v1() NOT NULL,
    facility_code character varying NOT NULL,
    version_num integer DEFAULT 1 NOT NULL,
    display_name character varying NOT NULL,
    published_date date DEFAULT now() NOT NULL,
    parent_facility_code character varying,
    facility_type common.facility_kind NOT NULL
);


ALTER TABLE information OWNER TO postgres;

--
-- TOC entry 3523 (class 0 OID 0)
-- Dependencies: 212
-- Name: COLUMN information.facility_type; Type: COMMENT; Schema: facility; Owner: postgres
--

COMMENT ON COLUMN information.facility_type IS 'PERA organization level';


--
-- TOC entry 213 (class 1259 OID 76606)
-- Name: area; Type: TABLE; Schema: facility; Owner: postgres
--

CREATE TABLE area (
    CONSTRAINT area_facility_type_check CHECK ((facility_type = 'AREA'::common.facility_kind))
)
INHERITS (information);


ALTER TABLE area OWNER TO postgres;

--
-- TOC entry 3524 (class 0 OID 0)
-- Dependencies: 213
-- Name: TABLE area; Type: COMMENT; Schema: facility; Owner: postgres
--

COMMENT ON TABLE area IS 'PERA model level-2';


--
-- TOC entry 214 (class 1259 OID 76616)
-- Name: enterprise; Type: TABLE; Schema: facility; Owner: postgres
--

CREATE TABLE enterprise (
    CONSTRAINT enterprise_facility_type_check CHECK ((facility_type = 'ENTERPRISE'::common.facility_kind))
)
INHERITS (information);


ALTER TABLE enterprise OWNER TO postgres;

--
-- TOC entry 3525 (class 0 OID 0)
-- Dependencies: 214
-- Name: TABLE enterprise; Type: COMMENT; Schema: facility; Owner: postgres
--

COMMENT ON TABLE enterprise IS 'PERA model level-4';


--
-- TOC entry 215 (class 1259 OID 76626)
-- Name: information_id_seq; Type: SEQUENCE; Schema: facility; Owner: postgres
--

CREATE SEQUENCE information_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE information_id_seq OWNER TO postgres;

--
-- TOC entry 3526 (class 0 OID 0)
-- Dependencies: 215
-- Name: information_id_seq; Type: SEQUENCE OWNED BY; Schema: facility; Owner: postgres
--

ALTER SEQUENCE information_id_seq OWNED BY information.id;


--
-- TOC entry 216 (class 1259 OID 76628)
-- Name: line; Type: TABLE; Schema: facility; Owner: postgres
--

CREATE TABLE line (
    CONSTRAINT line_facility_type_check CHECK ((facility_type = 'LINE'::common.facility_kind))
)
INHERITS (information);


ALTER TABLE line OWNER TO postgres;

--
-- TOC entry 3527 (class 0 OID 0)
-- Dependencies: 216
-- Name: TABLE line; Type: COMMENT; Schema: facility; Owner: postgres
--

COMMENT ON TABLE line IS 'PERA model level-1 (production line)';


--
-- TOC entry 217 (class 1259 OID 76638)
-- Name: site; Type: TABLE; Schema: facility; Owner: postgres
--

CREATE TABLE site (
    CONSTRAINT site_facility_type_check CHECK ((facility_type = 'SITE'::common.facility_kind)),
    CONSTRAINT site_parent_facility_code_check CHECK ((parent_facility_code IS NOT NULL))
)
INHERITS (information);


ALTER TABLE site OWNER TO postgres;

--
-- TOC entry 3528 (class 0 OID 0)
-- Dependencies: 217
-- Name: TABLE site; Type: COMMENT; Schema: facility; Owner: postgres
--

COMMENT ON TABLE site IS 'PERA model level-3';


--
-- TOC entry 218 (class 1259 OID 76649)
-- Name: zone; Type: TABLE; Schema: facility; Owner: postgres
--

CREATE TABLE zone (
    CONSTRAINT zone_facility_type_check CHECK ((facility_type = 'ZONE'::common.facility_kind))
)
INHERITS (information);


ALTER TABLE zone OWNER TO postgres;

--
-- TOC entry 3529 (class 0 OID 0)
-- Dependencies: 218
-- Name: TABLE zone; Type: COMMENT; Schema: facility; Owner: postgres
--

COMMENT ON TABLE zone IS 'PERA model level-1 (storge zone)';


SET search_path = inventory, pg_catalog;

--
-- TOC entry 219 (class 1259 OID 76659)
-- Name: definition; Type: TABLE; Schema: inventory; Owner: postgres
--

CREATE TABLE definition (
    id bigint NOT NULL,
    gid uuid DEFAULT public.uuid_generate_v1() NOT NULL,
    display_name character varying,
    version_num integer DEFAULT 1 NOT NULL,
    published_date date DEFAULT now() NOT NULL,
    prev_fsmt common.document_fsmt,
    prev_fsmt_date timestamp with time zone,
    curr_fsmt common.document_fsmt DEFAULT 'PROPOSED'::common.document_fsmt NOT NULL,
    curr_fsmt_date timestamp with time zone DEFAULT now() NOT NULL,
    information_id bigint,
    uom_code character varying DEFAULT 'pcs'::character varying NOT NULL
);


ALTER TABLE definition OWNER TO postgres;

--
-- TOC entry 220 (class 1259 OID 76671)
-- Name: definition_id_seq; Type: SEQUENCE; Schema: inventory; Owner: postgres
--

CREATE SEQUENCE definition_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE definition_id_seq OWNER TO postgres;

--
-- TOC entry 3530 (class 0 OID 0)
-- Dependencies: 220
-- Name: definition_id_seq; Type: SEQUENCE OWNED BY; Schema: inventory; Owner: postgres
--

ALTER SEQUENCE definition_id_seq OWNED BY definition.id;


--
-- TOC entry 221 (class 1259 OID 76673)
-- Name: information; Type: TABLE; Schema: inventory; Owner: postgres
--

CREATE TABLE information (
    id bigint NOT NULL,
    gid uuid DEFAULT public.uuid_generate_v1() NOT NULL,
    part_code character varying NOT NULL,
    display_name character varying,
    published_date date DEFAULT now() NOT NULL
);


ALTER TABLE information OWNER TO postgres;

--
-- TOC entry 222 (class 1259 OID 76681)
-- Name: information_id_seq; Type: SEQUENCE; Schema: inventory; Owner: postgres
--

CREATE SEQUENCE information_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE information_id_seq OWNER TO postgres;

--
-- TOC entry 3531 (class 0 OID 0)
-- Dependencies: 222
-- Name: information_id_seq; Type: SEQUENCE OWNED BY; Schema: inventory; Owner: postgres
--

ALTER SEQUENCE information_id_seq OWNED BY information.id;


--
-- TOC entry 223 (class 1259 OID 76683)
-- Name: measurement; Type: TABLE; Schema: inventory; Owner: postgres
--

CREATE TABLE measurement (
    definition_id bigint NOT NULL,
    uom_code character varying NOT NULL,
    factor numeric
);


ALTER TABLE measurement OWNER TO postgres;

--
-- TOC entry 224 (class 1259 OID 76689)
-- Name: variety; Type: TABLE; Schema: inventory; Owner: postgres
--

CREATE TABLE variety (
    definition_id bigint NOT NULL,
    inventory_type common.inventory_kind NOT NULL
);


ALTER TABLE variety OWNER TO postgres;

SET search_path = personnel, pg_catalog;

--
-- TOC entry 225 (class 1259 OID 76692)
-- Name: information; Type: TABLE; Schema: personnel; Owner: postgres
--

CREATE TABLE information (
    id bigint NOT NULL,
    gid uuid DEFAULT public.uuid_generate_v1() NOT NULL,
    personnel_code character varying NOT NULL,
    version_num integer NOT NULL,
    display_name character varying NOT NULL,
    published_date date DEFAULT now() NOT NULL
);


ALTER TABLE information OWNER TO postgres;

--
-- TOC entry 226 (class 1259 OID 76700)
-- Name: information_id_seq; Type: SEQUENCE; Schema: personnel; Owner: postgres
--

CREATE SEQUENCE information_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE information_id_seq OWNER TO postgres;

--
-- TOC entry 3532 (class 0 OID 0)
-- Dependencies: 226
-- Name: information_id_seq; Type: SEQUENCE OWNED BY; Schema: personnel; Owner: postgres
--

ALTER SEQUENCE information_id_seq OWNED BY information.id;


SET search_path = tests, pg_catalog;

--
-- TOC entry 227 (class 1259 OID 76702)
-- Name: pgunit_covarage; Type: VIEW; Schema: tests; Owner: postgres
--

CREATE VIEW pgunit_covarage AS
 SELECT ((('__'::text || (routines.specific_schema)::text) || '__'::text) || (routines.routine_name)::text) AS _function_to_run
   FROM information_schema.routines
  WHERE (((routines.specific_schema)::text <> ALL (ARRAY[('tests'::character varying)::text, ('pgunit'::character varying)::text, ('public'::character varying)::text, ('pg_catalog'::character varying)::text, ('information_schema'::character varying)::text])) AND ((routines.routine_name)::text !~~ 'disall%'::text))
EXCEPT
 SELECT routines.routine_name AS _function_to_run
   FROM information_schema.routines
  WHERE (((routines.specific_schema)::text = 'tests'::text) AND ((routines.routine_name)::text ~~ '\_\_%'::text))
  ORDER BY 1;


ALTER TABLE pgunit_covarage OWNER TO postgres;

--
-- TOC entry 228 (class 1259 OID 76707)
-- Name: plpgsql_check_all; Type: VIEW; Schema: tests; Owner: postgres
--

CREATE VIEW plpgsql_check_all AS
 SELECT ((ss.pcf).functionid)::regprocedure AS functionid,
    (ss.pcf).lineno AS lineno,
    (ss.pcf).statement AS statement,
    (ss.pcf).sqlstate AS sqlstate,
    (ss.pcf).message AS message,
    (ss.pcf).detail AS detail,
    (ss.pcf).hint AS hint,
    (ss.pcf).level AS level,
    (ss.pcf)."position" AS "position",
    (ss.pcf).query AS query,
    (ss.pcf).context AS context
   FROM ( SELECT public.plpgsql_check_function_tb((pg_proc.oid)::regprocedure, (COALESCE(pg_trigger.tgrelid, (0)::oid))::regclass) AS pcf
           FROM (pg_proc
             LEFT JOIN pg_trigger ON ((pg_trigger.tgfoid = pg_proc.oid)))
          WHERE ((pg_proc.prolang = ( SELECT lang.oid
                   FROM pg_language lang
                  WHERE (lang.lanname = 'plpgsql'::name))) AND (pg_proc.pronamespace <> ( SELECT nsp.oid
                   FROM pg_namespace nsp
                  WHERE (nsp.nspname = 'pg_catalog'::name))) AND ((pg_proc.prorettype <> ( SELECT typ.oid
                   FROM pg_type typ
                  WHERE (typ.typname = 'trigger'::name))) OR (pg_trigger.tgfoid IS NOT NULL)))
         OFFSET 0) ss
  ORDER BY (((ss.pcf).functionid)::regprocedure)::text, (ss.pcf).lineno;


ALTER TABLE plpgsql_check_all OWNER TO postgres;

--
-- TOC entry 229 (class 1259 OID 76712)
-- Name: plpgsql_check_nontriggered; Type: VIEW; Schema: tests; Owner: postgres
--

CREATE VIEW plpgsql_check_nontriggered AS
 SELECT p.oid,
    p.proname,
    public.plpgsql_check_function((p.oid)::regprocedure) AS plpgsql_check_function
   FROM ((pg_namespace n
     JOIN pg_proc p ON ((p.pronamespace = n.oid)))
     JOIN pg_language l ON ((p.prolang = l.oid)))
  WHERE ((l.lanname = 'plpgsql'::name) AND (p.prorettype <> (2279)::oid));


ALTER TABLE plpgsql_check_nontriggered OWNER TO postgres;

SET search_path = tooling, pg_catalog;

--
-- TOC entry 230 (class 1259 OID 76717)
-- Name: information; Type: TABLE; Schema: tooling; Owner: postgres
--

CREATE TABLE information (
    id bigint NOT NULL,
    gid uuid DEFAULT public.uuid_generate_v1() NOT NULL,
    tooling_code character varying NOT NULL,
    version_num integer NOT NULL,
    display_name character varying NOT NULL,
    published_date date DEFAULT now() NOT NULL
);


ALTER TABLE information OWNER TO postgres;

--
-- TOC entry 231 (class 1259 OID 76725)
-- Name: information_id_seq; Type: SEQUENCE; Schema: tooling; Owner: postgres
--

CREATE SEQUENCE information_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE information_id_seq OWNER TO postgres;

--
-- TOC entry 3533 (class 0 OID 0)
-- Dependencies: 231
-- Name: information_id_seq; Type: SEQUENCE OWNED BY; Schema: tooling; Owner: postgres
--

ALTER SEQUENCE information_id_seq OWNED BY information.id;


SET search_path = transactor, pg_catalog;

--
-- TOC entry 232 (class 1259 OID 76727)
-- Name: information; Type: TABLE; Schema: transactor; Owner: postgres
--

CREATE TABLE information (
    id bigint NOT NULL,
    gid uuid DEFAULT public.uuid_generate_v1() NOT NULL,
    transactor_code character varying NOT NULL,
    version_num integer NOT NULL,
    display_name character varying NOT NULL,
    published_date date DEFAULT now() NOT NULL
);


ALTER TABLE information OWNER TO postgres;

--
-- TOC entry 233 (class 1259 OID 76735)
-- Name: customer; Type: TABLE; Schema: transactor; Owner: postgres
--

CREATE TABLE customer (
)
INHERITS (information);


ALTER TABLE customer OWNER TO postgres;

--
-- TOC entry 234 (class 1259 OID 76743)
-- Name: information_id_seq; Type: SEQUENCE; Schema: transactor; Owner: postgres
--

CREATE SEQUENCE information_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE information_id_seq OWNER TO postgres;

--
-- TOC entry 3534 (class 0 OID 0)
-- Dependencies: 234
-- Name: information_id_seq; Type: SEQUENCE OWNED BY; Schema: transactor; Owner: postgres
--

ALTER SEQUENCE information_id_seq OWNED BY information.id;


--
-- TOC entry 235 (class 1259 OID 76745)
-- Name: supplier; Type: TABLE; Schema: transactor; Owner: postgres
--

CREATE TABLE supplier (
)
INHERITS (information);


ALTER TABLE supplier OWNER TO postgres;

SET search_path = uom, pg_catalog;

--
-- TOC entry 236 (class 1259 OID 76753)
-- Name: assignment; Type: TABLE; Schema: uom; Owner: postgres
--

CREATE TABLE assignment (
    uom_role_id bigint NOT NULL,
    uom_role_code character varying(100),
    uom_role_name character varying(300)
);


ALTER TABLE assignment OWNER TO postgres;

--
-- TOC entry 3535 (class 0 OID 0)
-- Dependencies: 236
-- Name: TABLE assignment; Type: COMMENT; Schema: uom; Owner: postgres
--

COMMENT ON TABLE assignment IS 'uom role';


--
-- TOC entry 237 (class 1259 OID 76756)
-- Name: information; Type: TABLE; Schema: uom; Owner: postgres
--

CREATE TABLE information (
    uom_code character varying(4) NOT NULL,
    uom_domain common.uom_domain_kind,
    base_uom_code character varying,
    factor numeric,
    id bigint NOT NULL
);


ALTER TABLE information OWNER TO postgres;

--
-- TOC entry 238 (class 1259 OID 76762)
-- Name: information_id_seq; Type: SEQUENCE; Schema: uom; Owner: postgres
--

CREATE SEQUENCE information_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE information_id_seq OWNER TO postgres;

--
-- TOC entry 3536 (class 0 OID 0)
-- Dependencies: 238
-- Name: information_id_seq; Type: SEQUENCE OWNED BY; Schema: uom; Owner: postgres
--

ALTER SEQUENCE information_id_seq OWNED BY information.id;


--
-- TOC entry 239 (class 1259 OID 76764)
-- Name: uom_role_uom_role_id_seq; Type: SEQUENCE; Schema: uom; Owner: postgres
--

CREATE SEQUENCE uom_role_uom_role_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE uom_role_uom_role_id_seq OWNER TO postgres;

--
-- TOC entry 3537 (class 0 OID 0)
-- Dependencies: 239
-- Name: uom_role_uom_role_id_seq; Type: SEQUENCE OWNED BY; Schema: uom; Owner: postgres
--

ALTER SEQUENCE uom_role_uom_role_id_seq OWNED BY assignment.uom_role_id;


SET search_path = equipment, pg_catalog;

--
-- TOC entry 3225 (class 2604 OID 76766)
-- Name: information id; Type: DEFAULT; Schema: equipment; Owner: postgres
--

ALTER TABLE ONLY information ALTER COLUMN id SET DEFAULT nextval('information_id_seq'::regclass);


SET search_path = facility, pg_catalog;

--
-- TOC entry 3230 (class 2604 OID 76767)
-- Name: area id; Type: DEFAULT; Schema: facility; Owner: postgres
--

ALTER TABLE ONLY area ALTER COLUMN id SET DEFAULT nextval('information_id_seq'::regclass);


--
-- TOC entry 3231 (class 2604 OID 76768)
-- Name: area gid; Type: DEFAULT; Schema: facility; Owner: postgres
--

ALTER TABLE ONLY area ALTER COLUMN gid SET DEFAULT public.uuid_generate_v1();


--
-- TOC entry 3232 (class 2604 OID 76769)
-- Name: area version_num; Type: DEFAULT; Schema: facility; Owner: postgres
--

ALTER TABLE ONLY area ALTER COLUMN version_num SET DEFAULT 1;


--
-- TOC entry 3233 (class 2604 OID 76770)
-- Name: area published_date; Type: DEFAULT; Schema: facility; Owner: postgres
--

ALTER TABLE ONLY area ALTER COLUMN published_date SET DEFAULT now();


--
-- TOC entry 3235 (class 2604 OID 76771)
-- Name: enterprise id; Type: DEFAULT; Schema: facility; Owner: postgres
--

ALTER TABLE ONLY enterprise ALTER COLUMN id SET DEFAULT nextval('information_id_seq'::regclass);


--
-- TOC entry 3236 (class 2604 OID 76772)
-- Name: enterprise gid; Type: DEFAULT; Schema: facility; Owner: postgres
--

ALTER TABLE ONLY enterprise ALTER COLUMN gid SET DEFAULT public.uuid_generate_v1();


--
-- TOC entry 3237 (class 2604 OID 76773)
-- Name: enterprise version_num; Type: DEFAULT; Schema: facility; Owner: postgres
--

ALTER TABLE ONLY enterprise ALTER COLUMN version_num SET DEFAULT 1;


--
-- TOC entry 3238 (class 2604 OID 76774)
-- Name: enterprise published_date; Type: DEFAULT; Schema: facility; Owner: postgres
--

ALTER TABLE ONLY enterprise ALTER COLUMN published_date SET DEFAULT now();


--
-- TOC entry 3229 (class 2604 OID 76775)
-- Name: information id; Type: DEFAULT; Schema: facility; Owner: postgres
--

ALTER TABLE ONLY information ALTER COLUMN id SET DEFAULT nextval('information_id_seq'::regclass);


--
-- TOC entry 3240 (class 2604 OID 76776)
-- Name: line id; Type: DEFAULT; Schema: facility; Owner: postgres
--

ALTER TABLE ONLY line ALTER COLUMN id SET DEFAULT nextval('information_id_seq'::regclass);


--
-- TOC entry 3241 (class 2604 OID 76777)
-- Name: line gid; Type: DEFAULT; Schema: facility; Owner: postgres
--

ALTER TABLE ONLY line ALTER COLUMN gid SET DEFAULT public.uuid_generate_v1();


--
-- TOC entry 3242 (class 2604 OID 76778)
-- Name: line version_num; Type: DEFAULT; Schema: facility; Owner: postgres
--

ALTER TABLE ONLY line ALTER COLUMN version_num SET DEFAULT 1;


--
-- TOC entry 3243 (class 2604 OID 76779)
-- Name: line published_date; Type: DEFAULT; Schema: facility; Owner: postgres
--

ALTER TABLE ONLY line ALTER COLUMN published_date SET DEFAULT now();


--
-- TOC entry 3245 (class 2604 OID 76780)
-- Name: site id; Type: DEFAULT; Schema: facility; Owner: postgres
--

ALTER TABLE ONLY site ALTER COLUMN id SET DEFAULT nextval('information_id_seq'::regclass);


--
-- TOC entry 3246 (class 2604 OID 76781)
-- Name: site gid; Type: DEFAULT; Schema: facility; Owner: postgres
--

ALTER TABLE ONLY site ALTER COLUMN gid SET DEFAULT public.uuid_generate_v1();


--
-- TOC entry 3247 (class 2604 OID 76782)
-- Name: site version_num; Type: DEFAULT; Schema: facility; Owner: postgres
--

ALTER TABLE ONLY site ALTER COLUMN version_num SET DEFAULT 1;


--
-- TOC entry 3248 (class 2604 OID 76783)
-- Name: site published_date; Type: DEFAULT; Schema: facility; Owner: postgres
--

ALTER TABLE ONLY site ALTER COLUMN published_date SET DEFAULT now();


--
-- TOC entry 3251 (class 2604 OID 76784)
-- Name: zone id; Type: DEFAULT; Schema: facility; Owner: postgres
--

ALTER TABLE ONLY zone ALTER COLUMN id SET DEFAULT nextval('information_id_seq'::regclass);


--
-- TOC entry 3252 (class 2604 OID 76785)
-- Name: zone gid; Type: DEFAULT; Schema: facility; Owner: postgres
--

ALTER TABLE ONLY zone ALTER COLUMN gid SET DEFAULT public.uuid_generate_v1();


--
-- TOC entry 3253 (class 2604 OID 76786)
-- Name: zone version_num; Type: DEFAULT; Schema: facility; Owner: postgres
--

ALTER TABLE ONLY zone ALTER COLUMN version_num SET DEFAULT 1;


--
-- TOC entry 3254 (class 2604 OID 76787)
-- Name: zone published_date; Type: DEFAULT; Schema: facility; Owner: postgres
--

ALTER TABLE ONLY zone ALTER COLUMN published_date SET DEFAULT now();


SET search_path = inventory, pg_catalog;

--
-- TOC entry 3262 (class 2604 OID 76788)
-- Name: definition id; Type: DEFAULT; Schema: inventory; Owner: postgres
--

ALTER TABLE ONLY definition ALTER COLUMN id SET DEFAULT nextval('definition_id_seq'::regclass);


--
-- TOC entry 3265 (class 2604 OID 76789)
-- Name: information id; Type: DEFAULT; Schema: inventory; Owner: postgres
--

ALTER TABLE ONLY information ALTER COLUMN id SET DEFAULT nextval('information_id_seq'::regclass);


SET search_path = personnel, pg_catalog;

--
-- TOC entry 3268 (class 2604 OID 76790)
-- Name: information id; Type: DEFAULT; Schema: personnel; Owner: postgres
--

ALTER TABLE ONLY information ALTER COLUMN id SET DEFAULT nextval('information_id_seq'::regclass);


SET search_path = tooling, pg_catalog;

--
-- TOC entry 3271 (class 2604 OID 76791)
-- Name: information id; Type: DEFAULT; Schema: tooling; Owner: postgres
--

ALTER TABLE ONLY information ALTER COLUMN id SET DEFAULT nextval('information_id_seq'::regclass);


SET search_path = transactor, pg_catalog;

--
-- TOC entry 3275 (class 2604 OID 76792)
-- Name: customer id; Type: DEFAULT; Schema: transactor; Owner: postgres
--

ALTER TABLE ONLY customer ALTER COLUMN id SET DEFAULT nextval('information_id_seq'::regclass);


--
-- TOC entry 3276 (class 2604 OID 76793)
-- Name: customer gid; Type: DEFAULT; Schema: transactor; Owner: postgres
--

ALTER TABLE ONLY customer ALTER COLUMN gid SET DEFAULT public.uuid_generate_v1();


--
-- TOC entry 3277 (class 2604 OID 76794)
-- Name: customer published_date; Type: DEFAULT; Schema: transactor; Owner: postgres
--

ALTER TABLE ONLY customer ALTER COLUMN published_date SET DEFAULT now();


--
-- TOC entry 3274 (class 2604 OID 76795)
-- Name: information id; Type: DEFAULT; Schema: transactor; Owner: postgres
--

ALTER TABLE ONLY information ALTER COLUMN id SET DEFAULT nextval('information_id_seq'::regclass);


--
-- TOC entry 3278 (class 2604 OID 76796)
-- Name: supplier id; Type: DEFAULT; Schema: transactor; Owner: postgres
--

ALTER TABLE ONLY supplier ALTER COLUMN id SET DEFAULT nextval('information_id_seq'::regclass);


--
-- TOC entry 3279 (class 2604 OID 76797)
-- Name: supplier gid; Type: DEFAULT; Schema: transactor; Owner: postgres
--

ALTER TABLE ONLY supplier ALTER COLUMN gid SET DEFAULT public.uuid_generate_v1();


--
-- TOC entry 3280 (class 2604 OID 76798)
-- Name: supplier published_date; Type: DEFAULT; Schema: transactor; Owner: postgres
--

ALTER TABLE ONLY supplier ALTER COLUMN published_date SET DEFAULT now();


SET search_path = uom, pg_catalog;

--
-- TOC entry 3281 (class 2604 OID 76799)
-- Name: assignment uom_role_id; Type: DEFAULT; Schema: uom; Owner: postgres
--

ALTER TABLE ONLY assignment ALTER COLUMN uom_role_id SET DEFAULT nextval('uom_role_uom_role_id_seq'::regclass);


--
-- TOC entry 3282 (class 2604 OID 76800)
-- Name: information id; Type: DEFAULT; Schema: uom; Owner: postgres
--

ALTER TABLE ONLY information ALTER COLUMN id SET DEFAULT nextval('information_id_seq'::regclass);


SET search_path = common, pg_catalog;

--
-- TOC entry 3481 (class 0 OID 76581)
-- Dependencies: 209
-- Data for Name: settings; Type: TABLE DATA; Schema: common; Owner: postgres
--



SET search_path = equipment, pg_catalog;

--
-- TOC entry 3482 (class 0 OID 76587)
-- Dependencies: 210
-- Data for Name: information; Type: TABLE DATA; Schema: equipment; Owner: postgres
--



--
-- TOC entry 3538 (class 0 OID 0)
-- Dependencies: 211
-- Name: information_id_seq; Type: SEQUENCE SET; Schema: equipment; Owner: postgres
--

SELECT pg_catalog.setval('information_id_seq', 1, false);


SET search_path = facility, pg_catalog;

--
-- TOC entry 3485 (class 0 OID 76606)
-- Dependencies: 213
-- Data for Name: area; Type: TABLE DATA; Schema: facility; Owner: postgres
--

INSERT INTO area VALUES (3, '00f11b88-fc89-11e7-b381-d4bed939923a', 'A01', 1, 'A01', '2018-01-18', 'S01', 'AREA');
INSERT INTO area VALUES (11, '2f3546bc-fca3-11e7-9533-d4bed939923a', 'A04', 1, 'A04', '2018-01-18', 'S01', 'AREA');


--
-- TOC entry 3486 (class 0 OID 76616)
-- Dependencies: 214
-- Data for Name: enterprise; Type: TABLE DATA; Schema: facility; Owner: postgres
--

INSERT INTO enterprise VALUES (1, 'd344d486-fc88-11e7-aa48-d4bed939923a', 'E01', 1, 'E01', '2018-01-18', NULL, 'ENTERPRISE');


--
-- TOC entry 3484 (class 0 OID 76597)
-- Dependencies: 212
-- Data for Name: information; Type: TABLE DATA; Schema: facility; Owner: postgres
--



--
-- TOC entry 3539 (class 0 OID 0)
-- Dependencies: 215
-- Name: information_id_seq; Type: SEQUENCE SET; Schema: facility; Owner: postgres
--

SELECT pg_catalog.setval('information_id_seq', 14, true);


--
-- TOC entry 3488 (class 0 OID 76628)
-- Dependencies: 216
-- Data for Name: line; Type: TABLE DATA; Schema: facility; Owner: postgres
--

INSERT INTO line VALUES (4, '1e749946-fc89-11e7-b4dd-d4bed939923a', 'L01', 1, 'L01', '2018-01-18', 'A01', 'LINE');
INSERT INTO line VALUES (6, 'f0f0aacc-fca2-11e7-952e-d4bed939923a', 'L02', 1, 'L02', '2018-01-18', 'A01', 'LINE');
INSERT INTO line VALUES (7, 'fcead30c-fca2-11e7-952f-d4bed939923a', 'L03', 1, 'L03', '2018-01-18', 'A01', 'LINE');
INSERT INTO line VALUES (9, '087b7910-fca3-11e7-9531-d4bed939923a', 'L04', 1, 'L04', '2018-01-18', 'A01', 'LINE');


--
-- TOC entry 3489 (class 0 OID 76638)
-- Dependencies: 217
-- Data for Name: site; Type: TABLE DATA; Schema: facility; Owner: postgres
--

INSERT INTO site VALUES (2, 'e975ae6a-fc88-11e7-a8d5-d4bed939923a', 'S01', 1, 'S01', '2018-01-18', 'E01', 'SITE');
INSERT INTO site VALUES (12, '38c2ed2e-fca3-11e7-9534-d4bed939923a', 'S04', 1, 'Storage Zone of Area ARE-M10-ZX1BB0', '2019-01-01', 'E01', 'SITE');


--
-- TOC entry 3490 (class 0 OID 76649)
-- Dependencies: 218
-- Data for Name: zone; Type: TABLE DATA; Schema: facility; Owner: postgres
--



SET search_path = inventory, pg_catalog;

--
-- TOC entry 3491 (class 0 OID 76659)
-- Dependencies: 219
-- Data for Name: definition; Type: TABLE DATA; Schema: inventory; Owner: postgres
--

INSERT INTO definition VALUES (1, 'c9000ec8-fa3a-11e7-9489-d4bed939923a', 'fl-16-50', 1, '2018-01-15', NULL, NULL, 'PROPOSED', '2018-01-15 23:26:44.534271+02', 1, 'pcs');
INSERT INTO definition VALUES (2, 'd83fb96a-fa3a-11e7-948a-d4bed939923a', 'fl-25-50', 1, '2018-01-15', NULL, NULL, 'PROPOSED', '2018-01-15 23:27:10.118984+02', 2, 'pcs');
INSERT INTO definition VALUES (3, '9d521068-fa3b-11e7-ac45-d4bed939923a', 'pipe-076x3', 1, '2018-01-15', NULL, NULL, 'PROPOSED', '2018-01-15 23:32:40.748622+02', 4, 'kg');
INSERT INTO definition VALUES (4, '8ad6bc7e-ffd4-11e7-8d5f-d4bed939923a', '11с31п-50х40', 1, '2018-01-23', NULL, NULL, 'PROPOSED', '2018-01-23 02:29:58.499502+02', 5, 'pcs');
INSERT INTO definition VALUES (5, 'b4aa3972-ffd4-11e7-8d61-d4bed939923a', '11с31п-40х32', 1, '2018-01-23', NULL, NULL, 'PROPOSED', '2018-01-23 02:31:08.728593+02', 6, 'pcs');
INSERT INTO definition VALUES (6, 'c3a211d4-ffd4-11e7-8d63-d4bed939923a', '11с31п-32х25', 1, '2018-01-23', NULL, NULL, 'PROPOSED', '2018-01-23 02:31:33.840983+02', 7, 'pcs');
INSERT INTO definition VALUES (7, 'cb12116c-ffd4-11e7-8d65-d4bed939923a', '11с31п-25х20', 1, '2018-01-23', NULL, NULL, 'PROPOSED', '2018-01-23 02:31:46.318946+02', 8, 'pcs');
INSERT INTO definition VALUES (8, 'd1827e6a-ffd4-11e7-8d67-d4bed939923a', '11с31п-20х15', 1, '2018-01-23', NULL, NULL, 'PROPOSED', '2018-01-23 02:31:57.122162+02', 9, 'pcs');
INSERT INTO definition VALUES (18, '3a7328ec-0b39-11e8-97ad-54ab3aa56755', 'Flange-DN500', 1, '2017-02-01', NULL, NULL, 'PROPOSED', '2018-02-06 14:28:25.639971+02', 10, 'pcs');


--
-- TOC entry 3540 (class 0 OID 0)
-- Dependencies: 220
-- Name: definition_id_seq; Type: SEQUENCE SET; Schema: inventory; Owner: postgres
--

SELECT pg_catalog.setval('definition_id_seq', 20, true);


--
-- TOC entry 3493 (class 0 OID 76673)
-- Dependencies: 221
-- Data for Name: information; Type: TABLE DATA; Schema: inventory; Owner: postgres
--

INSERT INTO information VALUES (2, 'b39a3ff4-fa3a-11e7-8e64-d4bed939923a', '22.25.050-001', 'fl-25-50', '2018-01-15');
INSERT INTO information VALUES (3, 'f08b5682-fa3a-11e7-86da-d4bed939923a', '22.40.050-001', 'fl-40-50', '2018-01-15');
INSERT INTO information VALUES (4, '7edbcfd4-fa3b-11e7-b771-d4bed939923a', 'pipe-076x3', 'pipe-076x3', '2018-01-15');
INSERT INTO information VALUES (5, '8ad6a072-ffd4-11e7-8d5e-d4bed939923a', '11.31.050-001', '11с31п-50х40', '2018-01-23');
INSERT INTO information VALUES (6, 'b4aa3576-ffd4-11e7-8d60-d4bed939923a', '11.31.040-001', '11с31п-40х32', '2018-01-23');
INSERT INTO information VALUES (7, 'c3a20aae-ffd4-11e7-8d62-d4bed939923a', '11.31.032-001', '11с31п-32х25', '2018-01-23');
INSERT INTO information VALUES (8, 'cb1209e2-ffd4-11e7-8d64-d4bed939923a', '11.31.025-001', '11с31п-25х20', '2018-01-23');
INSERT INTO information VALUES (9, 'd1827690-ffd4-11e7-8d66-d4bed939923a', '11.31.020-001', 'Valve 11с31п, Dn "20х15"', '2018-01-23');
INSERT INTO information VALUES (1, 'a711da30-fa3a-11e7-8e63-d4bed939923a', '22.16.050-001', 'f l 16 50', '2018-01-15');
INSERT INTO information VALUES (10, 'ef9d3ee0-0b36-11e8-97a1-54ab3aa56755', '22.16.500-001', 'Flange DN500', '2017-02-01');


--
-- TOC entry 3541 (class 0 OID 0)
-- Dependencies: 222
-- Name: information_id_seq; Type: SEQUENCE SET; Schema: inventory; Owner: postgres
--

SELECT pg_catalog.setval('information_id_seq', 12, true);


--
-- TOC entry 3495 (class 0 OID 76683)
-- Dependencies: 223
-- Data for Name: measurement; Type: TABLE DATA; Schema: inventory; Owner: postgres
--

INSERT INTO measurement VALUES (1, 'pcs', 1);
INSERT INTO measurement VALUES (2, 'pcs', 1);
INSERT INTO measurement VALUES (3, 'm', 25);
INSERT INTO measurement VALUES (4, 'pcs', 1);
INSERT INTO measurement VALUES (5, 'pcs', 1);
INSERT INTO measurement VALUES (6, 'pcs', 1);
INSERT INTO measurement VALUES (7, 'pcs', 1);
INSERT INTO measurement VALUES (8, 'pcs', 1);
INSERT INTO measurement VALUES (18, 'kg', 1);
INSERT INTO measurement VALUES (18, 'g', 1000);


--
-- TOC entry 3496 (class 0 OID 76689)
-- Dependencies: 224
-- Data for Name: variety; Type: TABLE DATA; Schema: inventory; Owner: postgres
--

INSERT INTO variety VALUES (1, 'PART');
INSERT INTO variety VALUES (1, 'PRODUCIBLE');
INSERT INTO variety VALUES (1, 'SALABLE');
INSERT INTO variety VALUES (1, 'STORABLE');
INSERT INTO variety VALUES (2, 'PART');
INSERT INTO variety VALUES (2, 'PRODUCIBLE');
INSERT INTO variety VALUES (2, 'SALABLE');
INSERT INTO variety VALUES (2, 'STORABLE');
INSERT INTO variety VALUES (3, 'STORABLE');
INSERT INTO variety VALUES (3, 'BUYABLE');
INSERT INTO variety VALUES (3, 'CONSUMABLE');
INSERT INTO variety VALUES (3, 'PRIMAL');
INSERT INTO variety VALUES (4, 'PRODUCIBLE');
INSERT INTO variety VALUES (4, 'ASSEMBLY');
INSERT INTO variety VALUES (4, 'STORABLE');
INSERT INTO variety VALUES (5, 'PRODUCIBLE');
INSERT INTO variety VALUES (5, 'ASSEMBLY');
INSERT INTO variety VALUES (5, 'STORABLE');
INSERT INTO variety VALUES (6, 'PRODUCIBLE');
INSERT INTO variety VALUES (6, 'ASSEMBLY');
INSERT INTO variety VALUES (6, 'STORABLE');
INSERT INTO variety VALUES (7, 'PRODUCIBLE');
INSERT INTO variety VALUES (7, 'ASSEMBLY');
INSERT INTO variety VALUES (7, 'STORABLE');
INSERT INTO variety VALUES (8, 'PRODUCIBLE');
INSERT INTO variety VALUES (8, 'ASSEMBLY');
INSERT INTO variety VALUES (8, 'STORABLE');
INSERT INTO variety VALUES (8, 'CONSUMABLE');
INSERT INTO variety VALUES (8, 'SALABLE');
INSERT INTO variety VALUES (18, 'ASSEMBLY');
INSERT INTO variety VALUES (18, 'STORABLE');


SET search_path = personnel, pg_catalog;

--
-- TOC entry 3497 (class 0 OID 76692)
-- Dependencies: 225
-- Data for Name: information; Type: TABLE DATA; Schema: personnel; Owner: postgres
--



--
-- TOC entry 3542 (class 0 OID 0)
-- Dependencies: 226
-- Name: information_id_seq; Type: SEQUENCE SET; Schema: personnel; Owner: postgres
--

SELECT pg_catalog.setval('information_id_seq', 1, false);


SET search_path = tooling, pg_catalog;

--
-- TOC entry 3499 (class 0 OID 76717)
-- Dependencies: 230
-- Data for Name: information; Type: TABLE DATA; Schema: tooling; Owner: postgres
--



--
-- TOC entry 3543 (class 0 OID 0)
-- Dependencies: 231
-- Name: information_id_seq; Type: SEQUENCE SET; Schema: tooling; Owner: postgres
--

SELECT pg_catalog.setval('information_id_seq', 1, false);


SET search_path = transactor, pg_catalog;

--
-- TOC entry 3502 (class 0 OID 76735)
-- Dependencies: 233
-- Data for Name: customer; Type: TABLE DATA; Schema: transactor; Owner: postgres
--



--
-- TOC entry 3501 (class 0 OID 76727)
-- Dependencies: 232
-- Data for Name: information; Type: TABLE DATA; Schema: transactor; Owner: postgres
--



--
-- TOC entry 3544 (class 0 OID 0)
-- Dependencies: 234
-- Name: information_id_seq; Type: SEQUENCE SET; Schema: transactor; Owner: postgres
--

SELECT pg_catalog.setval('information_id_seq', 1, false);


--
-- TOC entry 3504 (class 0 OID 76745)
-- Dependencies: 235
-- Data for Name: supplier; Type: TABLE DATA; Schema: transactor; Owner: postgres
--



SET search_path = uom, pg_catalog;

--
-- TOC entry 3505 (class 0 OID 76753)
-- Dependencies: 236
-- Data for Name: assignment; Type: TABLE DATA; Schema: uom; Owner: postgres
--



--
-- TOC entry 3506 (class 0 OID 76756)
-- Dependencies: 237
-- Data for Name: information; Type: TABLE DATA; Schema: uom; Owner: postgres
--

INSERT INTO information VALUES ('kg', 'MASS', 'kg', 1, 1);
INSERT INTO information VALUES ('m', 'LENGHT', 'm', 1, 2);
INSERT INTO information VALUES ('pcs', 'QUANTITY', 'pcs', 1, 3);
INSERT INTO information VALUES ('g', 'MASS', 'kg', 0.001, 4);
INSERT INTO information VALUES ('t', 'MASS', 'kg', 1000, 5);
INSERT INTO information VALUES ('mm', 'LENGHT', 'm', 0.001, 6);
INSERT INTO information VALUES ('km', 'LENGHT', 'm', 1000, 7);
INSERT INTO information VALUES ('cm', 'LENGHT', 'm', 0.01, 8);
INSERT INTO information VALUES ('l', 'VOLUME', 'l', 1, 9);
INSERT INTO information VALUES ('ml', 'VOLUME', 'l', 0.001, 10);


--
-- TOC entry 3545 (class 0 OID 0)
-- Dependencies: 238
-- Name: information_id_seq; Type: SEQUENCE SET; Schema: uom; Owner: postgres
--

SELECT pg_catalog.setval('information_id_seq', 10, true);


--
-- TOC entry 3546 (class 0 OID 0)
-- Dependencies: 239
-- Name: uom_role_uom_role_id_seq; Type: SEQUENCE SET; Schema: uom; Owner: postgres
--

SELECT pg_catalog.setval('uom_role_uom_role_id_seq', 1, false);


SET search_path = common, pg_catalog;

--
-- TOC entry 3284 (class 2606 OID 76802)
-- Name: settings wms_settings_pkey; Type: CONSTRAINT; Schema: common; Owner: postgres
--

ALTER TABLE ONLY settings
    ADD CONSTRAINT wms_settings_pkey PRIMARY KEY (parameter_name);


SET search_path = equipment, pg_catalog;

--
-- TOC entry 3286 (class 2606 OID 76804)
-- Name: information information_equipment_code_version_num_key; Type: CONSTRAINT; Schema: equipment; Owner: postgres
--

ALTER TABLE ONLY information
    ADD CONSTRAINT information_equipment_code_version_num_key UNIQUE (equipment_code, version_num);


--
-- TOC entry 3288 (class 2606 OID 76806)
-- Name: information information_gid_key; Type: CONSTRAINT; Schema: equipment; Owner: postgres
--

ALTER TABLE ONLY information
    ADD CONSTRAINT information_gid_key UNIQUE (gid);


--
-- TOC entry 3290 (class 2606 OID 76808)
-- Name: information information_pkey; Type: CONSTRAINT; Schema: equipment; Owner: postgres
--

ALTER TABLE ONLY information
    ADD CONSTRAINT information_pkey PRIMARY KEY (id);


SET search_path = facility, pg_catalog;

--
-- TOC entry 3294 (class 2606 OID 76810)
-- Name: area area_facility_code_key; Type: CONSTRAINT; Schema: facility; Owner: postgres
--

ALTER TABLE ONLY area
    ADD CONSTRAINT area_facility_code_key UNIQUE (facility_code);


--
-- TOC entry 3296 (class 2606 OID 76812)
-- Name: area area_pkey; Type: CONSTRAINT; Schema: facility; Owner: postgres
--

ALTER TABLE ONLY area
    ADD CONSTRAINT area_pkey PRIMARY KEY (id);


--
-- TOC entry 3298 (class 2606 OID 76814)
-- Name: enterprise enterprise_facility_code_key; Type: CONSTRAINT; Schema: facility; Owner: postgres
--

ALTER TABLE ONLY enterprise
    ADD CONSTRAINT enterprise_facility_code_key UNIQUE (facility_code);


--
-- TOC entry 3300 (class 2606 OID 76816)
-- Name: enterprise enterprise_pkey; Type: CONSTRAINT; Schema: facility; Owner: postgres
--

ALTER TABLE ONLY enterprise
    ADD CONSTRAINT enterprise_pkey PRIMARY KEY (id);


--
-- TOC entry 3292 (class 2606 OID 76818)
-- Name: information information_pkey; Type: CONSTRAINT; Schema: facility; Owner: postgres
--

ALTER TABLE ONLY information
    ADD CONSTRAINT information_pkey PRIMARY KEY (id);


--
-- TOC entry 3302 (class 2606 OID 76820)
-- Name: line line_facility_code_key; Type: CONSTRAINT; Schema: facility; Owner: postgres
--

ALTER TABLE ONLY line
    ADD CONSTRAINT line_facility_code_key UNIQUE (facility_code);


--
-- TOC entry 3304 (class 2606 OID 76822)
-- Name: line line_pkey; Type: CONSTRAINT; Schema: facility; Owner: postgres
--

ALTER TABLE ONLY line
    ADD CONSTRAINT line_pkey PRIMARY KEY (id);


--
-- TOC entry 3306 (class 2606 OID 76824)
-- Name: site site_facility_code_key; Type: CONSTRAINT; Schema: facility; Owner: postgres
--

ALTER TABLE ONLY site
    ADD CONSTRAINT site_facility_code_key UNIQUE (facility_code);


--
-- TOC entry 3308 (class 2606 OID 76826)
-- Name: site site_pkey; Type: CONSTRAINT; Schema: facility; Owner: postgres
--

ALTER TABLE ONLY site
    ADD CONSTRAINT site_pkey PRIMARY KEY (id);


--
-- TOC entry 3310 (class 2606 OID 76828)
-- Name: zone zone_facility_code_key; Type: CONSTRAINT; Schema: facility; Owner: postgres
--

ALTER TABLE ONLY zone
    ADD CONSTRAINT zone_facility_code_key UNIQUE (facility_code);


--
-- TOC entry 3312 (class 2606 OID 76830)
-- Name: zone zone_pkey; Type: CONSTRAINT; Schema: facility; Owner: postgres
--

ALTER TABLE ONLY zone
    ADD CONSTRAINT zone_pkey PRIMARY KEY (id);


SET search_path = inventory, pg_catalog;

--
-- TOC entry 3314 (class 2606 OID 76832)
-- Name: definition definition_gid_key; Type: CONSTRAINT; Schema: inventory; Owner: postgres
--

ALTER TABLE ONLY definition
    ADD CONSTRAINT definition_gid_key UNIQUE (gid);


--
-- TOC entry 3316 (class 2606 OID 76834)
-- Name: definition definition_information_id_version_num_key; Type: CONSTRAINT; Schema: inventory; Owner: postgres
--

ALTER TABLE ONLY definition
    ADD CONSTRAINT definition_information_id_version_num_key UNIQUE (information_id, version_num);


--
-- TOC entry 3318 (class 2606 OID 76836)
-- Name: definition definition_pkey; Type: CONSTRAINT; Schema: inventory; Owner: postgres
--

ALTER TABLE ONLY definition
    ADD CONSTRAINT definition_pkey PRIMARY KEY (id);


--
-- TOC entry 3320 (class 2606 OID 76838)
-- Name: information information_gid_key; Type: CONSTRAINT; Schema: inventory; Owner: postgres
--

ALTER TABLE ONLY information
    ADD CONSTRAINT information_gid_key UNIQUE (gid);


--
-- TOC entry 3322 (class 2606 OID 76840)
-- Name: information information_part_code; Type: CONSTRAINT; Schema: inventory; Owner: postgres
--

ALTER TABLE ONLY information
    ADD CONSTRAINT information_part_code UNIQUE (part_code);


--
-- TOC entry 3324 (class 2606 OID 76842)
-- Name: information information_pkey; Type: CONSTRAINT; Schema: inventory; Owner: postgres
--

ALTER TABLE ONLY information
    ADD CONSTRAINT information_pkey PRIMARY KEY (id);


--
-- TOC entry 3328 (class 2606 OID 76844)
-- Name: variety kind_pkey; Type: CONSTRAINT; Schema: inventory; Owner: postgres
--

ALTER TABLE ONLY variety
    ADD CONSTRAINT kind_pkey PRIMARY KEY (definition_id, inventory_type);


--
-- TOC entry 3326 (class 2606 OID 76846)
-- Name: measurement measurement_pkey; Type: CONSTRAINT; Schema: inventory; Owner: postgres
--

ALTER TABLE ONLY measurement
    ADD CONSTRAINT measurement_pkey PRIMARY KEY (definition_id, uom_code);


SET search_path = personnel, pg_catalog;

--
-- TOC entry 3330 (class 2606 OID 76848)
-- Name: information information_gid_key; Type: CONSTRAINT; Schema: personnel; Owner: postgres
--

ALTER TABLE ONLY information
    ADD CONSTRAINT information_gid_key UNIQUE (gid);


--
-- TOC entry 3332 (class 2606 OID 76850)
-- Name: information information_personnel_code_version_num_key; Type: CONSTRAINT; Schema: personnel; Owner: postgres
--

ALTER TABLE ONLY information
    ADD CONSTRAINT information_personnel_code_version_num_key UNIQUE (personnel_code, version_num);


--
-- TOC entry 3334 (class 2606 OID 76852)
-- Name: information information_pkey; Type: CONSTRAINT; Schema: personnel; Owner: postgres
--

ALTER TABLE ONLY information
    ADD CONSTRAINT information_pkey PRIMARY KEY (id);


SET search_path = tooling, pg_catalog;

--
-- TOC entry 3336 (class 2606 OID 76854)
-- Name: information information_gid_key; Type: CONSTRAINT; Schema: tooling; Owner: postgres
--

ALTER TABLE ONLY information
    ADD CONSTRAINT information_gid_key UNIQUE (gid);


--
-- TOC entry 3338 (class 2606 OID 76857)
-- Name: information information_pkey; Type: CONSTRAINT; Schema: tooling; Owner: postgres
--

ALTER TABLE ONLY information
    ADD CONSTRAINT information_pkey PRIMARY KEY (id);


--
-- TOC entry 3340 (class 2606 OID 76859)
-- Name: information information_tooling_code_version_num_key; Type: CONSTRAINT; Schema: tooling; Owner: postgres
--

ALTER TABLE ONLY information
    ADD CONSTRAINT information_tooling_code_version_num_key UNIQUE (tooling_code, version_num);


SET search_path = transactor, pg_catalog;

--
-- TOC entry 3342 (class 2606 OID 76861)
-- Name: information information_gid_key; Type: CONSTRAINT; Schema: transactor; Owner: postgres
--

ALTER TABLE ONLY information
    ADD CONSTRAINT information_gid_key UNIQUE (gid);


--
-- TOC entry 3344 (class 2606 OID 76863)
-- Name: information information_pkey; Type: CONSTRAINT; Schema: transactor; Owner: postgres
--

ALTER TABLE ONLY information
    ADD CONSTRAINT information_pkey PRIMARY KEY (id);


--
-- TOC entry 3346 (class 2606 OID 76865)
-- Name: information information_transactor_code_version_num_key; Type: CONSTRAINT; Schema: transactor; Owner: postgres
--

ALTER TABLE ONLY information
    ADD CONSTRAINT information_transactor_code_version_num_key UNIQUE (transactor_code, version_num);


SET search_path = uom, pg_catalog;

--
-- TOC entry 3352 (class 2606 OID 76867)
-- Name: information uom_pkey; Type: CONSTRAINT; Schema: uom; Owner: postgres
--

ALTER TABLE ONLY information
    ADD CONSTRAINT uom_pkey PRIMARY KEY (uom_code);


--
-- TOC entry 3348 (class 2606 OID 76869)
-- Name: assignment uom_role_pkey; Type: CONSTRAINT; Schema: uom; Owner: postgres
--

ALTER TABLE ONLY assignment
    ADD CONSTRAINT uom_role_pkey PRIMARY KEY (uom_role_id);


--
-- TOC entry 3350 (class 2606 OID 76871)
-- Name: assignment uom_role_uom_role_code_key; Type: CONSTRAINT; Schema: uom; Owner: postgres
--

ALTER TABLE ONLY assignment
    ADD CONSTRAINT uom_role_uom_role_code_key UNIQUE (uom_role_code);


SET search_path = facility, pg_catalog;

--
-- TOC entry 3353 (class 2606 OID 76872)
-- Name: area area_parent_facility_code_fkey; Type: FK CONSTRAINT; Schema: facility; Owner: postgres
--

ALTER TABLE ONLY area
    ADD CONSTRAINT area_parent_facility_code_fkey FOREIGN KEY (parent_facility_code) REFERENCES site(facility_code) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- TOC entry 3354 (class 2606 OID 76877)
-- Name: line line_parent_facility_code_fkey; Type: FK CONSTRAINT; Schema: facility; Owner: postgres
--

ALTER TABLE ONLY line
    ADD CONSTRAINT line_parent_facility_code_fkey FOREIGN KEY (parent_facility_code) REFERENCES area(facility_code) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- TOC entry 3355 (class 2606 OID 76882)
-- Name: site site_parent_facility_code_fkey; Type: FK CONSTRAINT; Schema: facility; Owner: postgres
--

ALTER TABLE ONLY site
    ADD CONSTRAINT site_parent_facility_code_fkey FOREIGN KEY (parent_facility_code) REFERENCES enterprise(facility_code) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- TOC entry 3356 (class 2606 OID 76887)
-- Name: zone zone_parent_facility_code_fkey; Type: FK CONSTRAINT; Schema: facility; Owner: postgres
--

ALTER TABLE ONLY zone
    ADD CONSTRAINT zone_parent_facility_code_fkey FOREIGN KEY (parent_facility_code) REFERENCES area(facility_code);


SET search_path = inventory, pg_catalog;

--
-- TOC entry 3357 (class 2606 OID 76892)
-- Name: definition definition_information_id_fkey; Type: FK CONSTRAINT; Schema: inventory; Owner: postgres
--

ALTER TABLE ONLY definition
    ADD CONSTRAINT definition_information_id_fkey FOREIGN KEY (information_id) REFERENCES information(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- TOC entry 3358 (class 2606 OID 76897)
-- Name: measurement measurement_definition_id_fkey; Type: FK CONSTRAINT; Schema: inventory; Owner: postgres
--

ALTER TABLE ONLY measurement
    ADD CONSTRAINT measurement_definition_id_fkey FOREIGN KEY (definition_id) REFERENCES definition(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- TOC entry 3359 (class 2606 OID 76902)
-- Name: variety variety_definition_id_fkey; Type: FK CONSTRAINT; Schema: inventory; Owner: postgres
--

ALTER TABLE ONLY variety
    ADD CONSTRAINT variety_definition_id_fkey FOREIGN KEY (definition_id) REFERENCES definition(id) ON UPDATE CASCADE ON DELETE CASCADE;


SET search_path = uom, pg_catalog;

--
-- TOC entry 3360 (class 2606 OID 76907)
-- Name: information uom_base_uom_code_fkey; Type: FK CONSTRAINT; Schema: uom; Owner: postgres
--

ALTER TABLE ONLY information
    ADD CONSTRAINT uom_base_uom_code_fkey FOREIGN KEY (base_uom_code) REFERENCES information(uom_code);


-- Completed on 2018-02-17 23:23:57 EET

--
-- PostgreSQL database dump complete
--

