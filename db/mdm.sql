--
-- PostgreSQL database dump
--

-- Dumped from database version 9.6.7
-- Dumped by pg_dump version 9.6.7

-- Started on 2018-05-18 10:29:47 EEST

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SET check_function_bodies = false;
SET client_min_messages = warning;
SET row_security = off;

--
-- TOC entry 15 (class 2615 OID 354699)
-- Name: common; Type: SCHEMA; Schema: -; Owner: postgres
--

CREATE SCHEMA common;


ALTER SCHEMA common OWNER TO postgres;

--
-- TOC entry 10 (class 2615 OID 354700)
-- Name: equipment; Type: SCHEMA; Schema: -; Owner: postgres
--

CREATE SCHEMA equipment;


ALTER SCHEMA equipment OWNER TO postgres;

--
-- TOC entry 19 (class 2615 OID 354701)
-- Name: facility; Type: SCHEMA; Schema: -; Owner: postgres
--

CREATE SCHEMA facility;


ALTER SCHEMA facility OWNER TO postgres;

--
-- TOC entry 8 (class 2615 OID 354702)
-- Name: inventory; Type: SCHEMA; Schema: -; Owner: postgres
--

CREATE SCHEMA inventory;


ALTER SCHEMA inventory OWNER TO postgres;

--
-- TOC entry 13 (class 2615 OID 354703)
-- Name: personnel; Type: SCHEMA; Schema: -; Owner: postgres
--

CREATE SCHEMA personnel;


ALTER SCHEMA personnel OWNER TO postgres;

--
-- TOC entry 14 (class 2615 OID 354704)
-- Name: pgunit; Type: SCHEMA; Schema: -; Owner: postgres
--

CREATE SCHEMA pgunit;


ALTER SCHEMA pgunit OWNER TO postgres;

--
-- TOC entry 20 (class 2615 OID 354705)
-- Name: tests; Type: SCHEMA; Schema: -; Owner: postgres
--

CREATE SCHEMA tests;


ALTER SCHEMA tests OWNER TO postgres;

--
-- TOC entry 11 (class 2615 OID 354706)
-- Name: tooling; Type: SCHEMA; Schema: -; Owner: postgres
--

CREATE SCHEMA tooling;


ALTER SCHEMA tooling OWNER TO postgres;

--
-- TOC entry 16 (class 2615 OID 354707)
-- Name: transactor; Type: SCHEMA; Schema: -; Owner: postgres
--

CREATE SCHEMA transactor;


ALTER SCHEMA transactor OWNER TO postgres;

--
-- TOC entry 21 (class 2615 OID 354708)
-- Name: uom; Type: SCHEMA; Schema: -; Owner: postgres
--

CREATE SCHEMA uom;


ALTER SCHEMA uom OWNER TO postgres;

--
-- TOC entry 2 (class 3079 OID 12393)
-- Name: plpgsql; Type: EXTENSION; Schema: -; Owner: 
--

CREATE EXTENSION IF NOT EXISTS plpgsql WITH SCHEMA pg_catalog;


--
-- TOC entry 2569 (class 0 OID 0)
-- Dependencies: 2
-- Name: EXTENSION plpgsql; Type: COMMENT; Schema: -; Owner: 
--

COMMENT ON EXTENSION plpgsql IS 'PL/pgSQL procedural language';


--
-- TOC entry 1 (class 3079 OID 354709)
-- Name: adminpack; Type: EXTENSION; Schema: -; Owner: 
--

CREATE EXTENSION IF NOT EXISTS adminpack WITH SCHEMA pg_catalog;


--
-- TOC entry 2570 (class 0 OID 0)
-- Dependencies: 1
-- Name: EXTENSION adminpack; Type: COMMENT; Schema: -; Owner: 
--

COMMENT ON EXTENSION adminpack IS 'administrative functions for PostgreSQL';


--
-- TOC entry 5 (class 3079 OID 354718)
-- Name: pldbgapi; Type: EXTENSION; Schema: -; Owner: 
--

CREATE EXTENSION IF NOT EXISTS pldbgapi WITH SCHEMA public;


--
-- TOC entry 2571 (class 0 OID 0)
-- Dependencies: 5
-- Name: EXTENSION pldbgapi; Type: COMMENT; Schema: -; Owner: 
--

COMMENT ON EXTENSION pldbgapi IS 'server-side support for debugging PL/pgSQL functions';


--
-- TOC entry 4 (class 3079 OID 354755)
-- Name: plpgsql_check; Type: EXTENSION; Schema: -; Owner: 
--

CREATE EXTENSION IF NOT EXISTS plpgsql_check WITH SCHEMA public;


--
-- TOC entry 2572 (class 0 OID 0)
-- Dependencies: 4
-- Name: EXTENSION plpgsql_check; Type: COMMENT; Schema: -; Owner: 
--

COMMENT ON EXTENSION plpgsql_check IS 'extended check for plpgsql functions';


--
-- TOC entry 3 (class 3079 OID 354760)
-- Name: uuid-ossp; Type: EXTENSION; Schema: -; Owner: 
--

CREATE EXTENSION IF NOT EXISTS "uuid-ossp" WITH SCHEMA public;


--
-- TOC entry 2573 (class 0 OID 0)
-- Dependencies: 3
-- Name: EXTENSION "uuid-ossp"; Type: COMMENT; Schema: -; Owner: 
--

COMMENT ON EXTENSION "uuid-ossp" IS 'generate universally unique identifiers (UUIDs)';


SET search_path = common, pg_catalog;

--
-- TOC entry 706 (class 1247 OID 354772)
-- Name: day_kind; Type: TYPE; Schema: common; Owner: postgres
--

CREATE TYPE day_kind AS ENUM (
    'WORKDAY',
    'HOLIDAY'
);


ALTER TYPE day_kind OWNER TO postgres;

--
-- TOC entry 709 (class 1247 OID 354778)
-- Name: document_fsmt; Type: TYPE; Schema: common; Owner: postgres
--

CREATE TYPE document_fsmt AS ENUM (
    'PROPOSED',
    'COMMITTED',
    'DECOMMITTED'
);


ALTER TYPE document_fsmt OWNER TO postgres;

--
-- TOC entry 712 (class 1247 OID 354786)
-- Name: document_kind; Type: TYPE; Schema: common; Owner: postgres
--

CREATE TYPE document_kind AS ENUM (
    'INVENTORY'
);


ALTER TYPE document_kind OWNER TO postgres;

--
-- TOC entry 715 (class 1247 OID 354790)
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
-- TOC entry 718 (class 1247 OID 354803)
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
-- TOC entry 721 (class 1247 OID 354806)
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
-- TOC entry 724 (class 1247 OID 354808)
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
-- TOC entry 727 (class 1247 OID 354827)
-- Name: unit_conversion_type; Type: TYPE; Schema: common; Owner: postgres
--

CREATE TYPE unit_conversion_type AS (
	uom_code_from character varying,
	uom_code_to character varying,
	factor numeric
);


ALTER TYPE unit_conversion_type OWNER TO postgres;

--
-- TOC entry 730 (class 1247 OID 354830)
-- Name: inventory_document; Type: TYPE; Schema: common; Owner: postgres
--

CREATE TYPE inventory_document AS (
	head inventory_head,
	meas unit_conversion_type[],
	kind inventory_kind[]
);


ALTER TYPE inventory_document OWNER TO postgres;

--
-- TOC entry 733 (class 1247 OID 354831)
-- Name: quantity; Type: DOMAIN; Schema: common; Owner: postgres
--

CREATE DOMAIN quantity AS numeric(20,4) DEFAULT 0
	CONSTRAINT quantity_is_positive CHECK ((VALUE >= (0)::numeric));


ALTER DOMAIN quantity OWNER TO postgres;

--
-- TOC entry 2574 (class 0 OID 0)
-- Dependencies: 733
-- Name: DOMAIN quantity; Type: COMMENT; Schema: common; Owner: postgres
--

COMMENT ON DOMAIN quantity IS 'quantity domain';


--
-- TOC entry 735 (class 1247 OID 354833)
-- Name: quantity_signed; Type: DOMAIN; Schema: common; Owner: postgres
--

CREATE DOMAIN quantity_signed AS numeric(20,4) DEFAULT 0;


ALTER DOMAIN quantity_signed OWNER TO postgres;

--
-- TOC entry 2575 (class 0 OID 0)
-- Dependencies: 735
-- Name: DOMAIN quantity_signed; Type: COMMENT; Schema: common; Owner: postgres
--

COMMENT ON DOMAIN quantity_signed IS 'quantity signed domain';


--
-- TOC entry 736 (class 1247 OID 354835)
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
-- TOC entry 739 (class 1247 OID 354845)
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
-- TOC entry 272 (class 1255 OID 354846)
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
-- TOC entry 288 (class 1255 OID 354847)
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
-- TOC entry 289 (class 1255 OID 354848)
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
-- TOC entry 290 (class 1255 OID 354849)
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
-- TOC entry 291 (class 1255 OID 354850)
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
-- TOC entry 292 (class 1255 OID 354851)
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
-- TOC entry 293 (class 1255 OID 354852)
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
-- TOC entry 294 (class 1255 OID 354853)
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
-- TOC entry 295 (class 1255 OID 354854)
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
-- TOC entry 296 (class 1255 OID 354855)
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
-- TOC entry 297 (class 1255 OID 354856)
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
-- TOC entry 298 (class 1255 OID 354857)
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
-- TOC entry 299 (class 1255 OID 354858)
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
-- TOC entry 300 (class 1255 OID 354859)
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
        uom_from.uom_domain = _uom_domain_from::common.uom_domain_kind AND 
        uom_to.uom_domain = _uom_domain_to::common.uom_domain_kind
      );

END
$$;


ALTER FUNCTION inventory.get_uom_conversion_factors(_part_code character varying, _version_num integer, _uom_domain_from character varying, _uom_domain_to character varying) OWNER TO postgres;

--
-- TOC entry 301 (class 1255 OID 354860)
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
-- TOC entry 302 (class 1255 OID 354861)
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
-- TOC entry 303 (class 1255 OID 354862)
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
-- TOC entry 304 (class 1255 OID 354863)
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
-- TOC entry 305 (class 1255 OID 354864)
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
-- TOC entry 306 (class 1255 OID 354865)
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
-- TOC entry 307 (class 1255 OID 354866)
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
-- TOC entry 308 (class 1255 OID 354867)
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
-- TOC entry 309 (class 1255 OID 354868)
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
-- TOC entry 310 (class 1255 OID 354869)
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
-- TOC entry 311 (class 1255 OID 354870)
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
-- TOC entry 312 (class 1255 OID 354871)
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
-- TOC entry 313 (class 1255 OID 354872)
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
-- TOC entry 314 (class 1255 OID 354873)
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
-- TOC entry 315 (class 1255 OID 354874)
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
-- TOC entry 316 (class 1255 OID 354875)
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
-- TOC entry 317 (class 1255 OID 354876)
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
-- TOC entry 318 (class 1255 OID 354877)
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
-- TOC entry 319 (class 1255 OID 354878)
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
-- TOC entry 320 (class 1255 OID 354879)
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
-- TOC entry 330 (class 1255 OID 354880)
-- Name: __inventory__destroy(); Type: FUNCTION; Schema: tests; Owner: postgres
--

CREATE FUNCTION __inventory__destroy() RETURNS void
    LANGUAGE plpgsql
    AS $$
DECLARE
  _head common.inventory_head;
BEGIN
  
  RAISE DEBUG '#trace Check __inventory__destroy()';

  INSERT INTO
    inventory.information
      (id, gid, part_code, display_name, published_date)
    VALUES
      (101, 'a711da30-fa3a-11e7-8e63-d4bed939923a', '22.16.050-001', 'fl-16-50', '2018-01-15'),
      (102, 'b39a3ff4-fa3a-11e7-8e64-d4bed939923a', '22.25.050-001', 'fl-25-50', '2018-01-15'),
      (103, 'f08b5682-fa3a-11e7-86da-d4bed939923a', '22.40.050-001', 'fl-40-50', '2018-01-15');

  INSERT INTO
    inventory.definition 
      (id, gid, display_name, version_num, published_date, prev_fsmt, prev_fsmt_date, curr_fsmt, curr_fsmt_date, information_id, uom_code)
    VALUES 
      (101, 'c9000ec8-fa3a-11e7-9489-d4bed939923a', 'fl-16-50', 1, '2018-01-10', NULL, NULL, 'DECOMMITTED', '2018-01-10', 101, 'pcs'),
      (102, 'd83fb96a-fa3a-11e7-948a-d4bed939923a', 'fl-25-50', 1, '2018-01-15', NULL, NULL, 'COMMITTED', '2018-01-15', 102, 'pcs'),
      (103, 'cf77e3ea-0b5c-4e62-be62-63704f4071b7', 'fl-25-50', 2, '2018-01-16', NULL, NULL, 'PROPOSED', '2018-01-16', 102, 'pcs'),
      (104, 'c792f74d-7e6e-4577-ad69-987f56af7af7', 'fl-40-50', 1, '2018-01-17', NULL, NULL, 'COMMITTED', '2018-01-17', 103, 'pcs');

  PERFORM inventory.destroy(101); -- + add not allowed delete test
  
  _head := inventory.get_head(101);
  PERFORM pgunit.assert_null(_head, 'Incorrect _head value');

  _head := inventory.get_head(103);
  PERFORM pgunit.assert_not_null(_head, 'Incorrect _head value');

END;
$$;


ALTER FUNCTION tests.__inventory__destroy() OWNER TO postgres;

--
-- TOC entry 323 (class 1255 OID 354881)
-- Name: __inventory__get_head(); Type: FUNCTION; Schema: tests; Owner: postgres
--

CREATE FUNCTION __inventory__get_head() RETURNS void
    LANGUAGE plpgsql
    AS $$
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
      (101, 'a711da30-fa3a-11e7-8e63-d4bed939923a', '22.16.050-001', 'fl-16-50', '2018-01-15'),
      (102, 'b39a3ff4-fa3a-11e7-8e64-d4bed939923a', '22.25.050-001', 'fl-25-50', '2018-01-15'),
      (103, 'f08b5682-fa3a-11e7-86da-d4bed939923a', '22.40.050-001', 'fl-40-50', '2018-01-15');

  INSERT INTO
    inventory.definition 
      (id, gid, display_name, version_num, published_date, prev_fsmt, prev_fsmt_date, curr_fsmt, curr_fsmt_date, information_id, uom_code)
    VALUES 
      (101, 'c9000ec8-fa3a-11e7-9489-d4bed939923a', 'fl-16-50', 1, '2018-01-10', NULL, NULL, 'DECOMMITTED', '2018-01-10', 101, 'pcs'),
      (102, 'd83fb96a-fa3a-11e7-948a-d4bed939923a', 'fl-25-50', 1, '2018-01-15', NULL, NULL, 'COMMITTED', '2018-01-15', 102, 'pcs'),
      (103, 'cf77e3ea-0b5c-4e62-be62-63704f4071b7', 'fl-25-50', 2, '2018-01-16', NULL, NULL, 'PROPOSED', '2018-01-16', 102, 'pcs'),
      (104, 'c792f74d-7e6e-4577-ad69-987f56af7af7', 'fl-40-50', 1, '2018-01-17', NULL, NULL, 'COMMITTED', '2018-01-17', 103, 'pcs');

  _head := inventory.get_head(103);
  PERFORM pgunit.assert_equals(_test_gid, _head.gid, 'Incorrect gid value');
  PERFORM pgunit.assert_equals(_test_display_name, _head.display_name, 'Incorrect display_name value');
  PERFORM pgunit.assert_equals(_test_part_code, _head.part_code, 'Incorrect part_code value');
  PERFORM pgunit.assert_equals(_test_document_date, _head.document_date, 'Incorrect document_date value');
  PERFORM pgunit.assert_equals(_test_version_num, _head.version_num, 'Incorrect version_num value');
  PERFORM pgunit.assert_equals(_test_uom_code, _head.uom_code, 'Incorrect uom_code value');
  PERFORM pgunit.assert_equals(_test_curr_fsmt, _head.curr_fsmt, 'Incorrect curr_fsmt value');
  PERFORM pgunit.assert_equals(_test_document_type, _head.document_type, 'Incorrect document_type value');


  _head := inventory.get_head(104);
  PERFORM pgunit.assert_not_equals(_test_gid, _head.gid, 'Incorrect gid value');
  
  _head := inventory.get_head(105);
  PERFORM pgunit.assert_null(_head, 'Incorrect _head value');

END;
$$;


ALTER FUNCTION tests.__inventory__get_head() OWNER TO postgres;

--
-- TOC entry 331 (class 1255 OID 354882)
-- Name: __inventory__init(); Type: FUNCTION; Schema: tests; Owner: postgres
--

CREATE FUNCTION __inventory__init() RETURNS void
    LANGUAGE plpgsql
    AS $$
DECLARE
  _test_head CONSTANT common.inventory_head[] := ARRAY[(103, 'cf77e3ea-0b5c-4e62-be62-63704f4071b7', 'fl-25-50', '20.25.50-001', 2, '2018-01-16', 'pcs', 'PROPOSED', 'INVENTORY')]::common.inventory_head[];
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
$$;


ALTER FUNCTION tests.__inventory__init() OWNER TO postgres;

--
-- TOC entry 324 (class 1255 OID 354883)
-- Name: __inventory__reinit(); Type: FUNCTION; Schema: tests; Owner: postgres
--

CREATE FUNCTION __inventory__reinit() RETURNS void
    LANGUAGE plpgsql
    AS $$
DECLARE
  _test_head CONSTANT common.inventory_head[] := ARRAY[(103, 'cf77e3ea-0b5c-4e62-be62-63704f4071b7', 'fl-25-50', '20.25.50-001', 2, '2018-01-16', 'pcs', 'PROPOSED', 'INVENTORY')]::common.inventory_head[];
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
$$;


ALTER FUNCTION tests.__inventory__reinit() OWNER TO postgres;

--
-- TOC entry 321 (class 1255 OID 354884)
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
-- TOC entry 322 (class 1255 OID 354885)
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
-- TOC entry 325 (class 1255 OID 354886)
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
-- TOC entry 326 (class 1255 OID 354887)
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
-- TOC entry 327 (class 1255 OID 354888)
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
-- TOC entry 328 (class 1255 OID 354889)
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
-- TOC entry 329 (class 1255 OID 354890)
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
-- TOC entry 209 (class 1259 OID 354891)
-- Name: settings; Type: TABLE; Schema: common; Owner: postgres
--

CREATE TABLE settings (
    parameter_name character varying NOT NULL,
    parameter_value character varying
);


ALTER TABLE settings OWNER TO postgres;

SET search_path = equipment, pg_catalog;

--
-- TOC entry 210 (class 1259 OID 354897)
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
-- TOC entry 211 (class 1259 OID 354905)
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
-- TOC entry 2576 (class 0 OID 0)
-- Dependencies: 211
-- Name: information_id_seq; Type: SEQUENCE OWNED BY; Schema: equipment; Owner: postgres
--

ALTER SEQUENCE information_id_seq OWNED BY information.id;


SET search_path = facility, pg_catalog;

--
-- TOC entry 212 (class 1259 OID 354907)
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
-- TOC entry 2577 (class 0 OID 0)
-- Dependencies: 212
-- Name: COLUMN information.facility_type; Type: COMMENT; Schema: facility; Owner: postgres
--

COMMENT ON COLUMN information.facility_type IS 'PERA organization level';


--
-- TOC entry 213 (class 1259 OID 354916)
-- Name: area; Type: TABLE; Schema: facility; Owner: postgres
--

CREATE TABLE area (
    CONSTRAINT area_facility_type_check CHECK ((facility_type = 'AREA'::common.facility_kind))
)
INHERITS (information);


ALTER TABLE area OWNER TO postgres;

--
-- TOC entry 2578 (class 0 OID 0)
-- Dependencies: 213
-- Name: TABLE area; Type: COMMENT; Schema: facility; Owner: postgres
--

COMMENT ON TABLE area IS 'PERA model level-2';


--
-- TOC entry 214 (class 1259 OID 354926)
-- Name: enterprise; Type: TABLE; Schema: facility; Owner: postgres
--

CREATE TABLE enterprise (
    CONSTRAINT enterprise_facility_type_check CHECK ((facility_type = 'ENTERPRISE'::common.facility_kind))
)
INHERITS (information);


ALTER TABLE enterprise OWNER TO postgres;

--
-- TOC entry 2579 (class 0 OID 0)
-- Dependencies: 214
-- Name: TABLE enterprise; Type: COMMENT; Schema: facility; Owner: postgres
--

COMMENT ON TABLE enterprise IS 'PERA model level-4';


--
-- TOC entry 215 (class 1259 OID 354936)
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
-- TOC entry 2580 (class 0 OID 0)
-- Dependencies: 215
-- Name: information_id_seq; Type: SEQUENCE OWNED BY; Schema: facility; Owner: postgres
--

ALTER SEQUENCE information_id_seq OWNED BY information.id;


--
-- TOC entry 216 (class 1259 OID 354938)
-- Name: line; Type: TABLE; Schema: facility; Owner: postgres
--

CREATE TABLE line (
    CONSTRAINT line_facility_type_check CHECK ((facility_type = 'LINE'::common.facility_kind))
)
INHERITS (information);


ALTER TABLE line OWNER TO postgres;

--
-- TOC entry 2581 (class 0 OID 0)
-- Dependencies: 216
-- Name: TABLE line; Type: COMMENT; Schema: facility; Owner: postgres
--

COMMENT ON TABLE line IS 'PERA model level-1 (production line)';


--
-- TOC entry 217 (class 1259 OID 354948)
-- Name: site; Type: TABLE; Schema: facility; Owner: postgres
--

CREATE TABLE site (
    CONSTRAINT site_facility_type_check CHECK ((facility_type = 'SITE'::common.facility_kind)),
    CONSTRAINT site_parent_facility_code_check CHECK ((parent_facility_code IS NOT NULL))
)
INHERITS (information);


ALTER TABLE site OWNER TO postgres;

--
-- TOC entry 2582 (class 0 OID 0)
-- Dependencies: 217
-- Name: TABLE site; Type: COMMENT; Schema: facility; Owner: postgres
--

COMMENT ON TABLE site IS 'PERA model level-3';


--
-- TOC entry 218 (class 1259 OID 354959)
-- Name: zone; Type: TABLE; Schema: facility; Owner: postgres
--

CREATE TABLE zone (
    CONSTRAINT zone_facility_type_check CHECK ((facility_type = 'ZONE'::common.facility_kind))
)
INHERITS (information);


ALTER TABLE zone OWNER TO postgres;

--
-- TOC entry 2583 (class 0 OID 0)
-- Dependencies: 218
-- Name: TABLE zone; Type: COMMENT; Schema: facility; Owner: postgres
--

COMMENT ON TABLE zone IS 'PERA model level-1 (storge zone)';


SET search_path = inventory, pg_catalog;

--
-- TOC entry 219 (class 1259 OID 354969)
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
-- TOC entry 220 (class 1259 OID 354981)
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
-- TOC entry 2584 (class 0 OID 0)
-- Dependencies: 220
-- Name: definition_id_seq; Type: SEQUENCE OWNED BY; Schema: inventory; Owner: postgres
--

ALTER SEQUENCE definition_id_seq OWNED BY definition.id;


--
-- TOC entry 221 (class 1259 OID 354983)
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
-- TOC entry 222 (class 1259 OID 354991)
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
-- TOC entry 2585 (class 0 OID 0)
-- Dependencies: 222
-- Name: information_id_seq; Type: SEQUENCE OWNED BY; Schema: inventory; Owner: postgres
--

ALTER SEQUENCE information_id_seq OWNED BY information.id;


--
-- TOC entry 223 (class 1259 OID 354993)
-- Name: measurement; Type: TABLE; Schema: inventory; Owner: postgres
--

CREATE TABLE measurement (
    definition_id bigint NOT NULL,
    uom_code character varying NOT NULL,
    factor numeric
);


ALTER TABLE measurement OWNER TO postgres;

--
-- TOC entry 224 (class 1259 OID 354999)
-- Name: variety; Type: TABLE; Schema: inventory; Owner: postgres
--

CREATE TABLE variety (
    definition_id bigint NOT NULL,
    inventory_type common.inventory_kind NOT NULL
);


ALTER TABLE variety OWNER TO postgres;

SET search_path = personnel, pg_catalog;

--
-- TOC entry 225 (class 1259 OID 355002)
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
-- TOC entry 226 (class 1259 OID 355010)
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
-- TOC entry 2586 (class 0 OID 0)
-- Dependencies: 226
-- Name: information_id_seq; Type: SEQUENCE OWNED BY; Schema: personnel; Owner: postgres
--

ALTER SEQUENCE information_id_seq OWNED BY information.id;


SET search_path = tests, pg_catalog;

--
-- TOC entry 227 (class 1259 OID 355012)
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
-- TOC entry 228 (class 1259 OID 355017)
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
-- TOC entry 229 (class 1259 OID 355022)
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
-- TOC entry 230 (class 1259 OID 355027)
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
-- TOC entry 231 (class 1259 OID 355035)
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
-- TOC entry 2587 (class 0 OID 0)
-- Dependencies: 231
-- Name: information_id_seq; Type: SEQUENCE OWNED BY; Schema: tooling; Owner: postgres
--

ALTER SEQUENCE information_id_seq OWNED BY information.id;


SET search_path = transactor, pg_catalog;

--
-- TOC entry 232 (class 1259 OID 355037)
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
-- TOC entry 233 (class 1259 OID 355045)
-- Name: customer; Type: TABLE; Schema: transactor; Owner: postgres
--

CREATE TABLE customer (
)
INHERITS (information);


ALTER TABLE customer OWNER TO postgres;

--
-- TOC entry 234 (class 1259 OID 355053)
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
-- TOC entry 2588 (class 0 OID 0)
-- Dependencies: 234
-- Name: information_id_seq; Type: SEQUENCE OWNED BY; Schema: transactor; Owner: postgres
--

ALTER SEQUENCE information_id_seq OWNED BY information.id;


--
-- TOC entry 235 (class 1259 OID 355055)
-- Name: supplier; Type: TABLE; Schema: transactor; Owner: postgres
--

CREATE TABLE supplier (
)
INHERITS (information);


ALTER TABLE supplier OWNER TO postgres;

SET search_path = uom, pg_catalog;

--
-- TOC entry 236 (class 1259 OID 355063)
-- Name: assignment; Type: TABLE; Schema: uom; Owner: postgres
--

CREATE TABLE assignment (
    uom_role_id bigint NOT NULL,
    uom_role_code character varying(100),
    uom_role_name character varying(300)
);


ALTER TABLE assignment OWNER TO postgres;

--
-- TOC entry 2589 (class 0 OID 0)
-- Dependencies: 236
-- Name: TABLE assignment; Type: COMMENT; Schema: uom; Owner: postgres
--

COMMENT ON TABLE assignment IS 'uom role';


--
-- TOC entry 237 (class 1259 OID 355066)
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
-- TOC entry 238 (class 1259 OID 355072)
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
-- TOC entry 2590 (class 0 OID 0)
-- Dependencies: 238
-- Name: information_id_seq; Type: SEQUENCE OWNED BY; Schema: uom; Owner: postgres
--

ALTER SEQUENCE information_id_seq OWNED BY information.id;


--
-- TOC entry 239 (class 1259 OID 355074)
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
-- TOC entry 2591 (class 0 OID 0)
-- Dependencies: 239
-- Name: uom_role_uom_role_id_seq; Type: SEQUENCE OWNED BY; Schema: uom; Owner: postgres
--

ALTER SEQUENCE uom_role_uom_role_id_seq OWNED BY assignment.uom_role_id;


SET search_path = equipment, pg_catalog;

--
-- TOC entry 2279 (class 2604 OID 355076)
-- Name: information id; Type: DEFAULT; Schema: equipment; Owner: postgres
--

ALTER TABLE ONLY information ALTER COLUMN id SET DEFAULT nextval('information_id_seq'::regclass);


SET search_path = facility, pg_catalog;

--
-- TOC entry 2284 (class 2604 OID 355077)
-- Name: area id; Type: DEFAULT; Schema: facility; Owner: postgres
--

ALTER TABLE ONLY area ALTER COLUMN id SET DEFAULT nextval('information_id_seq'::regclass);


--
-- TOC entry 2285 (class 2604 OID 355078)
-- Name: area gid; Type: DEFAULT; Schema: facility; Owner: postgres
--

ALTER TABLE ONLY area ALTER COLUMN gid SET DEFAULT public.uuid_generate_v1();


--
-- TOC entry 2286 (class 2604 OID 355079)
-- Name: area version_num; Type: DEFAULT; Schema: facility; Owner: postgres
--

ALTER TABLE ONLY area ALTER COLUMN version_num SET DEFAULT 1;


--
-- TOC entry 2287 (class 2604 OID 355080)
-- Name: area published_date; Type: DEFAULT; Schema: facility; Owner: postgres
--

ALTER TABLE ONLY area ALTER COLUMN published_date SET DEFAULT now();


--
-- TOC entry 2289 (class 2604 OID 355081)
-- Name: enterprise id; Type: DEFAULT; Schema: facility; Owner: postgres
--

ALTER TABLE ONLY enterprise ALTER COLUMN id SET DEFAULT nextval('information_id_seq'::regclass);


--
-- TOC entry 2290 (class 2604 OID 355082)
-- Name: enterprise gid; Type: DEFAULT; Schema: facility; Owner: postgres
--

ALTER TABLE ONLY enterprise ALTER COLUMN gid SET DEFAULT public.uuid_generate_v1();


--
-- TOC entry 2291 (class 2604 OID 355083)
-- Name: enterprise version_num; Type: DEFAULT; Schema: facility; Owner: postgres
--

ALTER TABLE ONLY enterprise ALTER COLUMN version_num SET DEFAULT 1;


--
-- TOC entry 2292 (class 2604 OID 355084)
-- Name: enterprise published_date; Type: DEFAULT; Schema: facility; Owner: postgres
--

ALTER TABLE ONLY enterprise ALTER COLUMN published_date SET DEFAULT now();


--
-- TOC entry 2283 (class 2604 OID 355085)
-- Name: information id; Type: DEFAULT; Schema: facility; Owner: postgres
--

ALTER TABLE ONLY information ALTER COLUMN id SET DEFAULT nextval('information_id_seq'::regclass);


--
-- TOC entry 2294 (class 2604 OID 355086)
-- Name: line id; Type: DEFAULT; Schema: facility; Owner: postgres
--

ALTER TABLE ONLY line ALTER COLUMN id SET DEFAULT nextval('information_id_seq'::regclass);


--
-- TOC entry 2295 (class 2604 OID 355087)
-- Name: line gid; Type: DEFAULT; Schema: facility; Owner: postgres
--

ALTER TABLE ONLY line ALTER COLUMN gid SET DEFAULT public.uuid_generate_v1();


--
-- TOC entry 2296 (class 2604 OID 355088)
-- Name: line version_num; Type: DEFAULT; Schema: facility; Owner: postgres
--

ALTER TABLE ONLY line ALTER COLUMN version_num SET DEFAULT 1;


--
-- TOC entry 2297 (class 2604 OID 355089)
-- Name: line published_date; Type: DEFAULT; Schema: facility; Owner: postgres
--

ALTER TABLE ONLY line ALTER COLUMN published_date SET DEFAULT now();


--
-- TOC entry 2299 (class 2604 OID 355090)
-- Name: site id; Type: DEFAULT; Schema: facility; Owner: postgres
--

ALTER TABLE ONLY site ALTER COLUMN id SET DEFAULT nextval('information_id_seq'::regclass);


--
-- TOC entry 2300 (class 2604 OID 355091)
-- Name: site gid; Type: DEFAULT; Schema: facility; Owner: postgres
--

ALTER TABLE ONLY site ALTER COLUMN gid SET DEFAULT public.uuid_generate_v1();


--
-- TOC entry 2301 (class 2604 OID 355092)
-- Name: site version_num; Type: DEFAULT; Schema: facility; Owner: postgres
--

ALTER TABLE ONLY site ALTER COLUMN version_num SET DEFAULT 1;


--
-- TOC entry 2302 (class 2604 OID 355093)
-- Name: site published_date; Type: DEFAULT; Schema: facility; Owner: postgres
--

ALTER TABLE ONLY site ALTER COLUMN published_date SET DEFAULT now();


--
-- TOC entry 2305 (class 2604 OID 355094)
-- Name: zone id; Type: DEFAULT; Schema: facility; Owner: postgres
--

ALTER TABLE ONLY zone ALTER COLUMN id SET DEFAULT nextval('information_id_seq'::regclass);


--
-- TOC entry 2306 (class 2604 OID 355095)
-- Name: zone gid; Type: DEFAULT; Schema: facility; Owner: postgres
--

ALTER TABLE ONLY zone ALTER COLUMN gid SET DEFAULT public.uuid_generate_v1();


--
-- TOC entry 2307 (class 2604 OID 355096)
-- Name: zone version_num; Type: DEFAULT; Schema: facility; Owner: postgres
--

ALTER TABLE ONLY zone ALTER COLUMN version_num SET DEFAULT 1;


--
-- TOC entry 2308 (class 2604 OID 355097)
-- Name: zone published_date; Type: DEFAULT; Schema: facility; Owner: postgres
--

ALTER TABLE ONLY zone ALTER COLUMN published_date SET DEFAULT now();


SET search_path = inventory, pg_catalog;

--
-- TOC entry 2316 (class 2604 OID 355098)
-- Name: definition id; Type: DEFAULT; Schema: inventory; Owner: postgres
--

ALTER TABLE ONLY definition ALTER COLUMN id SET DEFAULT nextval('definition_id_seq'::regclass);


--
-- TOC entry 2319 (class 2604 OID 355099)
-- Name: information id; Type: DEFAULT; Schema: inventory; Owner: postgres
--

ALTER TABLE ONLY information ALTER COLUMN id SET DEFAULT nextval('information_id_seq'::regclass);


SET search_path = personnel, pg_catalog;

--
-- TOC entry 2322 (class 2604 OID 355100)
-- Name: information id; Type: DEFAULT; Schema: personnel; Owner: postgres
--

ALTER TABLE ONLY information ALTER COLUMN id SET DEFAULT nextval('information_id_seq'::regclass);


SET search_path = tooling, pg_catalog;

--
-- TOC entry 2325 (class 2604 OID 355101)
-- Name: information id; Type: DEFAULT; Schema: tooling; Owner: postgres
--

ALTER TABLE ONLY information ALTER COLUMN id SET DEFAULT nextval('information_id_seq'::regclass);


SET search_path = transactor, pg_catalog;

--
-- TOC entry 2329 (class 2604 OID 355102)
-- Name: customer id; Type: DEFAULT; Schema: transactor; Owner: postgres
--

ALTER TABLE ONLY customer ALTER COLUMN id SET DEFAULT nextval('information_id_seq'::regclass);


--
-- TOC entry 2330 (class 2604 OID 355103)
-- Name: customer gid; Type: DEFAULT; Schema: transactor; Owner: postgres
--

ALTER TABLE ONLY customer ALTER COLUMN gid SET DEFAULT public.uuid_generate_v1();


--
-- TOC entry 2331 (class 2604 OID 355104)
-- Name: customer published_date; Type: DEFAULT; Schema: transactor; Owner: postgres
--

ALTER TABLE ONLY customer ALTER COLUMN published_date SET DEFAULT now();


--
-- TOC entry 2328 (class 2604 OID 355105)
-- Name: information id; Type: DEFAULT; Schema: transactor; Owner: postgres
--

ALTER TABLE ONLY information ALTER COLUMN id SET DEFAULT nextval('information_id_seq'::regclass);


--
-- TOC entry 2332 (class 2604 OID 355106)
-- Name: supplier id; Type: DEFAULT; Schema: transactor; Owner: postgres
--

ALTER TABLE ONLY supplier ALTER COLUMN id SET DEFAULT nextval('information_id_seq'::regclass);


--
-- TOC entry 2333 (class 2604 OID 355107)
-- Name: supplier gid; Type: DEFAULT; Schema: transactor; Owner: postgres
--

ALTER TABLE ONLY supplier ALTER COLUMN gid SET DEFAULT public.uuid_generate_v1();


--
-- TOC entry 2334 (class 2604 OID 355108)
-- Name: supplier published_date; Type: DEFAULT; Schema: transactor; Owner: postgres
--

ALTER TABLE ONLY supplier ALTER COLUMN published_date SET DEFAULT now();


SET search_path = uom, pg_catalog;

--
-- TOC entry 2335 (class 2604 OID 355109)
-- Name: assignment uom_role_id; Type: DEFAULT; Schema: uom; Owner: postgres
--

ALTER TABLE ONLY assignment ALTER COLUMN uom_role_id SET DEFAULT nextval('uom_role_uom_role_id_seq'::regclass);


--
-- TOC entry 2336 (class 2604 OID 355110)
-- Name: information id; Type: DEFAULT; Schema: uom; Owner: postgres
--

ALTER TABLE ONLY information ALTER COLUMN id SET DEFAULT nextval('information_id_seq'::regclass);


SET search_path = common, pg_catalog;

--
-- TOC entry 2535 (class 0 OID 354891)
-- Dependencies: 209
-- Data for Name: settings; Type: TABLE DATA; Schema: common; Owner: postgres
--



SET search_path = equipment, pg_catalog;

--
-- TOC entry 2536 (class 0 OID 354897)
-- Dependencies: 210
-- Data for Name: information; Type: TABLE DATA; Schema: equipment; Owner: postgres
--



--
-- TOC entry 2592 (class 0 OID 0)
-- Dependencies: 211
-- Name: information_id_seq; Type: SEQUENCE SET; Schema: equipment; Owner: postgres
--

SELECT pg_catalog.setval('information_id_seq', 1, false);


SET search_path = facility, pg_catalog;

--
-- TOC entry 2539 (class 0 OID 354916)
-- Dependencies: 213
-- Data for Name: area; Type: TABLE DATA; Schema: facility; Owner: postgres
--



--
-- TOC entry 2540 (class 0 OID 354926)
-- Dependencies: 214
-- Data for Name: enterprise; Type: TABLE DATA; Schema: facility; Owner: postgres
--



--
-- TOC entry 2538 (class 0 OID 354907)
-- Dependencies: 212
-- Data for Name: information; Type: TABLE DATA; Schema: facility; Owner: postgres
--



--
-- TOC entry 2593 (class 0 OID 0)
-- Dependencies: 215
-- Name: information_id_seq; Type: SEQUENCE SET; Schema: facility; Owner: postgres
--

SELECT pg_catalog.setval('information_id_seq', 1, false);


--
-- TOC entry 2542 (class 0 OID 354938)
-- Dependencies: 216
-- Data for Name: line; Type: TABLE DATA; Schema: facility; Owner: postgres
--



--
-- TOC entry 2543 (class 0 OID 354948)
-- Dependencies: 217
-- Data for Name: site; Type: TABLE DATA; Schema: facility; Owner: postgres
--



--
-- TOC entry 2544 (class 0 OID 354959)
-- Dependencies: 218
-- Data for Name: zone; Type: TABLE DATA; Schema: facility; Owner: postgres
--



SET search_path = inventory, pg_catalog;

--
-- TOC entry 2545 (class 0 OID 354969)
-- Dependencies: 219
-- Data for Name: definition; Type: TABLE DATA; Schema: inventory; Owner: postgres
--



--
-- TOC entry 2594 (class 0 OID 0)
-- Dependencies: 220
-- Name: definition_id_seq; Type: SEQUENCE SET; Schema: inventory; Owner: postgres
--

SELECT pg_catalog.setval('definition_id_seq', 4, true);


--
-- TOC entry 2547 (class 0 OID 354983)
-- Dependencies: 221
-- Data for Name: information; Type: TABLE DATA; Schema: inventory; Owner: postgres
--



--
-- TOC entry 2595 (class 0 OID 0)
-- Dependencies: 222
-- Name: information_id_seq; Type: SEQUENCE SET; Schema: inventory; Owner: postgres
--

SELECT pg_catalog.setval('information_id_seq', 4, true);


--
-- TOC entry 2549 (class 0 OID 354993)
-- Dependencies: 223
-- Data for Name: measurement; Type: TABLE DATA; Schema: inventory; Owner: postgres
--



--
-- TOC entry 2550 (class 0 OID 354999)
-- Dependencies: 224
-- Data for Name: variety; Type: TABLE DATA; Schema: inventory; Owner: postgres
--



SET search_path = personnel, pg_catalog;

--
-- TOC entry 2551 (class 0 OID 355002)
-- Dependencies: 225
-- Data for Name: information; Type: TABLE DATA; Schema: personnel; Owner: postgres
--



--
-- TOC entry 2596 (class 0 OID 0)
-- Dependencies: 226
-- Name: information_id_seq; Type: SEQUENCE SET; Schema: personnel; Owner: postgres
--

SELECT pg_catalog.setval('information_id_seq', 1, false);


SET search_path = tooling, pg_catalog;

--
-- TOC entry 2553 (class 0 OID 355027)
-- Dependencies: 230
-- Data for Name: information; Type: TABLE DATA; Schema: tooling; Owner: postgres
--



--
-- TOC entry 2597 (class 0 OID 0)
-- Dependencies: 231
-- Name: information_id_seq; Type: SEQUENCE SET; Schema: tooling; Owner: postgres
--

SELECT pg_catalog.setval('information_id_seq', 1, false);


SET search_path = transactor, pg_catalog;

--
-- TOC entry 2556 (class 0 OID 355045)
-- Dependencies: 233
-- Data for Name: customer; Type: TABLE DATA; Schema: transactor; Owner: postgres
--



--
-- TOC entry 2555 (class 0 OID 355037)
-- Dependencies: 232
-- Data for Name: information; Type: TABLE DATA; Schema: transactor; Owner: postgres
--



--
-- TOC entry 2598 (class 0 OID 0)
-- Dependencies: 234
-- Name: information_id_seq; Type: SEQUENCE SET; Schema: transactor; Owner: postgres
--

SELECT pg_catalog.setval('information_id_seq', 1, false);


--
-- TOC entry 2558 (class 0 OID 355055)
-- Dependencies: 235
-- Data for Name: supplier; Type: TABLE DATA; Schema: transactor; Owner: postgres
--



SET search_path = uom, pg_catalog;

--
-- TOC entry 2559 (class 0 OID 355063)
-- Dependencies: 236
-- Data for Name: assignment; Type: TABLE DATA; Schema: uom; Owner: postgres
--



--
-- TOC entry 2560 (class 0 OID 355066)
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
-- TOC entry 2599 (class 0 OID 0)
-- Dependencies: 238
-- Name: information_id_seq; Type: SEQUENCE SET; Schema: uom; Owner: postgres
--

SELECT pg_catalog.setval('information_id_seq', 1, false);


--
-- TOC entry 2600 (class 0 OID 0)
-- Dependencies: 239
-- Name: uom_role_uom_role_id_seq; Type: SEQUENCE SET; Schema: uom; Owner: postgres
--

SELECT pg_catalog.setval('uom_role_uom_role_id_seq', 1, false);


SET search_path = common, pg_catalog;

--
-- TOC entry 2338 (class 2606 OID 355112)
-- Name: settings wms_settings_pkey; Type: CONSTRAINT; Schema: common; Owner: postgres
--

ALTER TABLE ONLY settings
    ADD CONSTRAINT wms_settings_pkey PRIMARY KEY (parameter_name);


SET search_path = equipment, pg_catalog;

--
-- TOC entry 2340 (class 2606 OID 355114)
-- Name: information information_equipment_code_version_num_key; Type: CONSTRAINT; Schema: equipment; Owner: postgres
--

ALTER TABLE ONLY information
    ADD CONSTRAINT information_equipment_code_version_num_key UNIQUE (equipment_code, version_num);


--
-- TOC entry 2342 (class 2606 OID 355116)
-- Name: information information_gid_key; Type: CONSTRAINT; Schema: equipment; Owner: postgres
--

ALTER TABLE ONLY information
    ADD CONSTRAINT information_gid_key UNIQUE (gid);


--
-- TOC entry 2344 (class 2606 OID 355118)
-- Name: information information_pkey; Type: CONSTRAINT; Schema: equipment; Owner: postgres
--

ALTER TABLE ONLY information
    ADD CONSTRAINT information_pkey PRIMARY KEY (id);


SET search_path = facility, pg_catalog;

--
-- TOC entry 2348 (class 2606 OID 355120)
-- Name: area area_facility_code_key; Type: CONSTRAINT; Schema: facility; Owner: postgres
--

ALTER TABLE ONLY area
    ADD CONSTRAINT area_facility_code_key UNIQUE (facility_code);


--
-- TOC entry 2350 (class 2606 OID 355122)
-- Name: area area_pkey; Type: CONSTRAINT; Schema: facility; Owner: postgres
--

ALTER TABLE ONLY area
    ADD CONSTRAINT area_pkey PRIMARY KEY (id);


--
-- TOC entry 2352 (class 2606 OID 355124)
-- Name: enterprise enterprise_facility_code_key; Type: CONSTRAINT; Schema: facility; Owner: postgres
--

ALTER TABLE ONLY enterprise
    ADD CONSTRAINT enterprise_facility_code_key UNIQUE (facility_code);


--
-- TOC entry 2354 (class 2606 OID 355126)
-- Name: enterprise enterprise_pkey; Type: CONSTRAINT; Schema: facility; Owner: postgres
--

ALTER TABLE ONLY enterprise
    ADD CONSTRAINT enterprise_pkey PRIMARY KEY (id);


--
-- TOC entry 2346 (class 2606 OID 355128)
-- Name: information information_pkey; Type: CONSTRAINT; Schema: facility; Owner: postgres
--

ALTER TABLE ONLY information
    ADD CONSTRAINT information_pkey PRIMARY KEY (id);


--
-- TOC entry 2356 (class 2606 OID 355130)
-- Name: line line_facility_code_key; Type: CONSTRAINT; Schema: facility; Owner: postgres
--

ALTER TABLE ONLY line
    ADD CONSTRAINT line_facility_code_key UNIQUE (facility_code);


--
-- TOC entry 2358 (class 2606 OID 355132)
-- Name: line line_pkey; Type: CONSTRAINT; Schema: facility; Owner: postgres
--

ALTER TABLE ONLY line
    ADD CONSTRAINT line_pkey PRIMARY KEY (id);


--
-- TOC entry 2360 (class 2606 OID 355134)
-- Name: site site_facility_code_key; Type: CONSTRAINT; Schema: facility; Owner: postgres
--

ALTER TABLE ONLY site
    ADD CONSTRAINT site_facility_code_key UNIQUE (facility_code);


--
-- TOC entry 2362 (class 2606 OID 355136)
-- Name: site site_pkey; Type: CONSTRAINT; Schema: facility; Owner: postgres
--

ALTER TABLE ONLY site
    ADD CONSTRAINT site_pkey PRIMARY KEY (id);


--
-- TOC entry 2364 (class 2606 OID 355138)
-- Name: zone zone_facility_code_key; Type: CONSTRAINT; Schema: facility; Owner: postgres
--

ALTER TABLE ONLY zone
    ADD CONSTRAINT zone_facility_code_key UNIQUE (facility_code);


--
-- TOC entry 2366 (class 2606 OID 355140)
-- Name: zone zone_pkey; Type: CONSTRAINT; Schema: facility; Owner: postgres
--

ALTER TABLE ONLY zone
    ADD CONSTRAINT zone_pkey PRIMARY KEY (id);


SET search_path = inventory, pg_catalog;

--
-- TOC entry 2368 (class 2606 OID 355142)
-- Name: definition definition_gid_key; Type: CONSTRAINT; Schema: inventory; Owner: postgres
--

ALTER TABLE ONLY definition
    ADD CONSTRAINT definition_gid_key UNIQUE (gid);


--
-- TOC entry 2370 (class 2606 OID 355144)
-- Name: definition definition_information_id_version_num_key; Type: CONSTRAINT; Schema: inventory; Owner: postgres
--

ALTER TABLE ONLY definition
    ADD CONSTRAINT definition_information_id_version_num_key UNIQUE (information_id, version_num);


--
-- TOC entry 2372 (class 2606 OID 355146)
-- Name: definition definition_pkey; Type: CONSTRAINT; Schema: inventory; Owner: postgres
--

ALTER TABLE ONLY definition
    ADD CONSTRAINT definition_pkey PRIMARY KEY (id);


--
-- TOC entry 2374 (class 2606 OID 355148)
-- Name: information information_gid_key; Type: CONSTRAINT; Schema: inventory; Owner: postgres
--

ALTER TABLE ONLY information
    ADD CONSTRAINT information_gid_key UNIQUE (gid);


--
-- TOC entry 2376 (class 2606 OID 355150)
-- Name: information information_part_code; Type: CONSTRAINT; Schema: inventory; Owner: postgres
--

ALTER TABLE ONLY information
    ADD CONSTRAINT information_part_code UNIQUE (part_code);


--
-- TOC entry 2378 (class 2606 OID 355152)
-- Name: information information_pkey; Type: CONSTRAINT; Schema: inventory; Owner: postgres
--

ALTER TABLE ONLY information
    ADD CONSTRAINT information_pkey PRIMARY KEY (id);


--
-- TOC entry 2382 (class 2606 OID 355154)
-- Name: variety kind_pkey; Type: CONSTRAINT; Schema: inventory; Owner: postgres
--

ALTER TABLE ONLY variety
    ADD CONSTRAINT kind_pkey PRIMARY KEY (definition_id, inventory_type);


--
-- TOC entry 2380 (class 2606 OID 355156)
-- Name: measurement measurement_pkey; Type: CONSTRAINT; Schema: inventory; Owner: postgres
--

ALTER TABLE ONLY measurement
    ADD CONSTRAINT measurement_pkey PRIMARY KEY (definition_id, uom_code);


SET search_path = personnel, pg_catalog;

--
-- TOC entry 2384 (class 2606 OID 355158)
-- Name: information information_gid_key; Type: CONSTRAINT; Schema: personnel; Owner: postgres
--

ALTER TABLE ONLY information
    ADD CONSTRAINT information_gid_key UNIQUE (gid);


--
-- TOC entry 2386 (class 2606 OID 355160)
-- Name: information information_personnel_code_version_num_key; Type: CONSTRAINT; Schema: personnel; Owner: postgres
--

ALTER TABLE ONLY information
    ADD CONSTRAINT information_personnel_code_version_num_key UNIQUE (personnel_code, version_num);


--
-- TOC entry 2388 (class 2606 OID 355162)
-- Name: information information_pkey; Type: CONSTRAINT; Schema: personnel; Owner: postgres
--

ALTER TABLE ONLY information
    ADD CONSTRAINT information_pkey PRIMARY KEY (id);


SET search_path = tooling, pg_catalog;

--
-- TOC entry 2390 (class 2606 OID 355164)
-- Name: information information_gid_key; Type: CONSTRAINT; Schema: tooling; Owner: postgres
--

ALTER TABLE ONLY information
    ADD CONSTRAINT information_gid_key UNIQUE (gid);


--
-- TOC entry 2392 (class 2606 OID 355166)
-- Name: information information_pkey; Type: CONSTRAINT; Schema: tooling; Owner: postgres
--

ALTER TABLE ONLY information
    ADD CONSTRAINT information_pkey PRIMARY KEY (id);


--
-- TOC entry 2394 (class 2606 OID 355168)
-- Name: information information_tooling_code_version_num_key; Type: CONSTRAINT; Schema: tooling; Owner: postgres
--

ALTER TABLE ONLY information
    ADD CONSTRAINT information_tooling_code_version_num_key UNIQUE (tooling_code, version_num);


SET search_path = transactor, pg_catalog;

--
-- TOC entry 2396 (class 2606 OID 355170)
-- Name: information information_gid_key; Type: CONSTRAINT; Schema: transactor; Owner: postgres
--

ALTER TABLE ONLY information
    ADD CONSTRAINT information_gid_key UNIQUE (gid);


--
-- TOC entry 2398 (class 2606 OID 355172)
-- Name: information information_pkey; Type: CONSTRAINT; Schema: transactor; Owner: postgres
--

ALTER TABLE ONLY information
    ADD CONSTRAINT information_pkey PRIMARY KEY (id);


--
-- TOC entry 2400 (class 2606 OID 355174)
-- Name: information information_transactor_code_version_num_key; Type: CONSTRAINT; Schema: transactor; Owner: postgres
--

ALTER TABLE ONLY information
    ADD CONSTRAINT information_transactor_code_version_num_key UNIQUE (transactor_code, version_num);


SET search_path = uom, pg_catalog;

--
-- TOC entry 2406 (class 2606 OID 355176)
-- Name: information uom_pkey; Type: CONSTRAINT; Schema: uom; Owner: postgres
--

ALTER TABLE ONLY information
    ADD CONSTRAINT uom_pkey PRIMARY KEY (uom_code);


--
-- TOC entry 2402 (class 2606 OID 355178)
-- Name: assignment uom_role_pkey; Type: CONSTRAINT; Schema: uom; Owner: postgres
--

ALTER TABLE ONLY assignment
    ADD CONSTRAINT uom_role_pkey PRIMARY KEY (uom_role_id);


--
-- TOC entry 2404 (class 2606 OID 355180)
-- Name: assignment uom_role_uom_role_code_key; Type: CONSTRAINT; Schema: uom; Owner: postgres
--

ALTER TABLE ONLY assignment
    ADD CONSTRAINT uom_role_uom_role_code_key UNIQUE (uom_role_code);


SET search_path = facility, pg_catalog;

--
-- TOC entry 2407 (class 2606 OID 355181)
-- Name: area area_parent_facility_code_fkey; Type: FK CONSTRAINT; Schema: facility; Owner: postgres
--

ALTER TABLE ONLY area
    ADD CONSTRAINT area_parent_facility_code_fkey FOREIGN KEY (parent_facility_code) REFERENCES site(facility_code) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- TOC entry 2408 (class 2606 OID 355186)
-- Name: line line_parent_facility_code_fkey; Type: FK CONSTRAINT; Schema: facility; Owner: postgres
--

ALTER TABLE ONLY line
    ADD CONSTRAINT line_parent_facility_code_fkey FOREIGN KEY (parent_facility_code) REFERENCES area(facility_code) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- TOC entry 2409 (class 2606 OID 355191)
-- Name: site site_parent_facility_code_fkey; Type: FK CONSTRAINT; Schema: facility; Owner: postgres
--

ALTER TABLE ONLY site
    ADD CONSTRAINT site_parent_facility_code_fkey FOREIGN KEY (parent_facility_code) REFERENCES enterprise(facility_code) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- TOC entry 2410 (class 2606 OID 355196)
-- Name: zone zone_parent_facility_code_fkey; Type: FK CONSTRAINT; Schema: facility; Owner: postgres
--

ALTER TABLE ONLY zone
    ADD CONSTRAINT zone_parent_facility_code_fkey FOREIGN KEY (parent_facility_code) REFERENCES area(facility_code);


SET search_path = inventory, pg_catalog;

--
-- TOC entry 2411 (class 2606 OID 355201)
-- Name: definition definition_information_id_fkey; Type: FK CONSTRAINT; Schema: inventory; Owner: postgres
--

ALTER TABLE ONLY definition
    ADD CONSTRAINT definition_information_id_fkey FOREIGN KEY (information_id) REFERENCES information(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- TOC entry 2412 (class 2606 OID 355206)
-- Name: measurement measurement_definition_id_fkey; Type: FK CONSTRAINT; Schema: inventory; Owner: postgres
--

ALTER TABLE ONLY measurement
    ADD CONSTRAINT measurement_definition_id_fkey FOREIGN KEY (definition_id) REFERENCES definition(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- TOC entry 2413 (class 2606 OID 355211)
-- Name: variety variety_definition_id_fkey; Type: FK CONSTRAINT; Schema: inventory; Owner: postgres
--

ALTER TABLE ONLY variety
    ADD CONSTRAINT variety_definition_id_fkey FOREIGN KEY (definition_id) REFERENCES definition(id) ON UPDATE CASCADE ON DELETE CASCADE;


SET search_path = uom, pg_catalog;

--
-- TOC entry 2414 (class 2606 OID 355216)
-- Name: information uom_base_uom_code_fkey; Type: FK CONSTRAINT; Schema: uom; Owner: postgres
--

ALTER TABLE ONLY information
    ADD CONSTRAINT uom_base_uom_code_fkey FOREIGN KEY (base_uom_code) REFERENCES information(uom_code);


-- Completed on 2018-05-18 10:29:47 EEST

--
-- PostgreSQL database dump complete
--

