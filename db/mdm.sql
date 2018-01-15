--
-- PostgreSQL database dump
--

-- Dumped from database version 9.6.6
-- Dumped by pg_dump version 9.6.6

-- Started on 2018-01-15 04:56:53 EET

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SET check_function_bodies = false;
SET client_min_messages = warning;
SET row_security = off;

--
-- TOC entry 22 (class 2615 OID 56246)
-- Name: common; Type: SCHEMA; Schema: -; Owner: postgres
--

CREATE SCHEMA common;


ALTER SCHEMA common OWNER TO postgres;

--
-- TOC entry 18 (class 2615 OID 56247)
-- Name: equipment; Type: SCHEMA; Schema: -; Owner: postgres
--

CREATE SCHEMA equipment;


ALTER SCHEMA equipment OWNER TO postgres;

--
-- TOC entry 9 (class 2615 OID 56248)
-- Name: facility; Type: SCHEMA; Schema: -; Owner: postgres
--

CREATE SCHEMA facility;


ALTER SCHEMA facility OWNER TO postgres;

--
-- TOC entry 14 (class 2615 OID 56249)
-- Name: inventory; Type: SCHEMA; Schema: -; Owner: postgres
--

CREATE SCHEMA inventory;


ALTER SCHEMA inventory OWNER TO postgres;

--
-- TOC entry 23 (class 2615 OID 56250)
-- Name: measurement; Type: SCHEMA; Schema: -; Owner: postgres
--

CREATE SCHEMA measurement;


ALTER SCHEMA measurement OWNER TO postgres;

--
-- TOC entry 20 (class 2615 OID 56251)
-- Name: personnel; Type: SCHEMA; Schema: -; Owner: postgres
--

CREATE SCHEMA personnel;


ALTER SCHEMA personnel OWNER TO postgres;

--
-- TOC entry 11 (class 2615 OID 56252)
-- Name: pgunit; Type: SCHEMA; Schema: -; Owner: postgres
--

CREATE SCHEMA pgunit;


ALTER SCHEMA pgunit OWNER TO postgres;

--
-- TOC entry 16 (class 2615 OID 56253)
-- Name: schedule; Type: SCHEMA; Schema: -; Owner: postgres
--

CREATE SCHEMA schedule;


ALTER SCHEMA schedule OWNER TO postgres;

--
-- TOC entry 12 (class 2615 OID 56254)
-- Name: tests; Type: SCHEMA; Schema: -; Owner: postgres
--

CREATE SCHEMA tests;


ALTER SCHEMA tests OWNER TO postgres;

--
-- TOC entry 8 (class 2615 OID 56255)
-- Name: tooling; Type: SCHEMA; Schema: -; Owner: postgres
--

CREATE SCHEMA tooling;


ALTER SCHEMA tooling OWNER TO postgres;

--
-- TOC entry 21 (class 2615 OID 56256)
-- Name: transactor; Type: SCHEMA; Schema: -; Owner: postgres
--

CREATE SCHEMA transactor;


ALTER SCHEMA transactor OWNER TO postgres;

--
-- TOC entry 13 (class 2615 OID 56257)
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
-- TOC entry 3387 (class 0 OID 0)
-- Dependencies: 2
-- Name: EXTENSION plpgsql; Type: COMMENT; Schema: -; Owner: 
--

COMMENT ON EXTENSION plpgsql IS 'PL/pgSQL procedural language';


--
-- TOC entry 1 (class 3079 OID 56258)
-- Name: adminpack; Type: EXTENSION; Schema: -; Owner: 
--

CREATE EXTENSION IF NOT EXISTS adminpack WITH SCHEMA pg_catalog;


--
-- TOC entry 3388 (class 0 OID 0)
-- Dependencies: 1
-- Name: EXTENSION adminpack; Type: COMMENT; Schema: -; Owner: 
--

COMMENT ON EXTENSION adminpack IS 'administrative functions for PostgreSQL';


--
-- TOC entry 5 (class 3079 OID 56267)
-- Name: pldbgapi; Type: EXTENSION; Schema: -; Owner: 
--

CREATE EXTENSION IF NOT EXISTS pldbgapi WITH SCHEMA public;


--
-- TOC entry 3389 (class 0 OID 0)
-- Dependencies: 5
-- Name: EXTENSION pldbgapi; Type: COMMENT; Schema: -; Owner: 
--

COMMENT ON EXTENSION pldbgapi IS 'server-side support for debugging PL/pgSQL functions';


--
-- TOC entry 4 (class 3079 OID 56304)
-- Name: plpgsql_check; Type: EXTENSION; Schema: -; Owner: 
--

CREATE EXTENSION IF NOT EXISTS plpgsql_check WITH SCHEMA public;


--
-- TOC entry 3390 (class 0 OID 0)
-- Dependencies: 4
-- Name: EXTENSION plpgsql_check; Type: COMMENT; Schema: -; Owner: 
--

COMMENT ON EXTENSION plpgsql_check IS 'extended check for plpgsql functions';


--
-- TOC entry 3 (class 3079 OID 56309)
-- Name: uuid-ossp; Type: EXTENSION; Schema: -; Owner: 
--

CREATE EXTENSION IF NOT EXISTS "uuid-ossp" WITH SCHEMA public;


--
-- TOC entry 3391 (class 0 OID 0)
-- Dependencies: 3
-- Name: EXTENSION "uuid-ossp"; Type: COMMENT; Schema: -; Owner: 
--

COMMENT ON EXTENSION "uuid-ossp" IS 'generate universally unique identifiers (UUIDs)';


SET search_path = common, pg_catalog;

--
-- TOC entry 685 (class 1247 OID 56321)
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
-- TOC entry 688 (class 1247 OID 56337)
-- Name: quantity; Type: DOMAIN; Schema: common; Owner: postgres
--

CREATE DOMAIN quantity AS numeric(20,4) DEFAULT 0
	CONSTRAINT quantity_is_positive CHECK ((VALUE >= (0)::numeric));


ALTER DOMAIN quantity OWNER TO postgres;

--
-- TOC entry 3392 (class 0 OID 0)
-- Dependencies: 688
-- Name: DOMAIN quantity; Type: COMMENT; Schema: common; Owner: postgres
--

COMMENT ON DOMAIN quantity IS 'quantity domain';


--
-- TOC entry 690 (class 1247 OID 56339)
-- Name: quantity_signed; Type: DOMAIN; Schema: common; Owner: postgres
--

CREATE DOMAIN quantity_signed AS numeric(20,4) DEFAULT 0;


ALTER DOMAIN quantity_signed OWNER TO postgres;

--
-- TOC entry 3393 (class 0 OID 0)
-- Dependencies: 690
-- Name: DOMAIN quantity_signed; Type: COMMENT; Schema: common; Owner: postgres
--

COMMENT ON DOMAIN quantity_signed IS 'quantity signed domain';


--
-- TOC entry 691 (class 1247 OID 56342)
-- Name: unit_conversion_type; Type: TYPE; Schema: common; Owner: postgres
--

CREATE TYPE unit_conversion_type AS (
	uom_code_from character varying,
	uom_code_to character varying,
	factor double precision
);


ALTER TYPE unit_conversion_type OWNER TO postgres;

--
-- TOC entry 278 (class 1255 OID 56343)
-- Name: foo(); Type: FUNCTION; Schema: common; Owner: postgres
--

CREATE FUNCTION foo() RETURNS integer
    LANGUAGE plpgsql
    AS $$

DECLARE
  __array integer[];

BEGIN
  __array[1] := 10;
  __array[2] := 20;
  __array[3] := 30;

  case
  when __array @> ARRAY[30] then
    raise notice 'msg %', 0;
  when __array @> ARRAY[20] then
    raise notice 'msg %', 1;
  when __array @> ARRAY[10] then
    raise notice 'msg %', 0;
  end case;

  return __array[2];

END;

$$;


ALTER FUNCTION common.foo() OWNER TO postgres;

--
-- TOC entry 279 (class 1255 OID 56344)
-- Name: get_param_measurement_apply_latency(); Type: FUNCTION; Schema: common; Owner: postgres
--

CREATE FUNCTION get_param_measurement_apply_latency() RETURNS interval
    LANGUAGE plpgsql
    AS $$
BEGIN
  RETURN parameter_value::interval
    FROM
      common.settings
    WHERE
      parameter_name = 'measurement_apply_latency';
END;
$$;


ALTER FUNCTION common.get_param_measurement_apply_latency() OWNER TO postgres;

SET search_path = inventory, pg_catalog;

--
-- TOC entry 280 (class 1255 OID 56345)
-- Name: get_base_uom(character varying); Type: FUNCTION; Schema: inventory; Owner: postgres
--

CREATE FUNCTION get_base_uom(_part_code character varying) RETURNS character varying
    LANGUAGE plpgsql
    AS $$
BEGIN
  RETURN uom_base_code
    FROM
      inventory.storable
    WHERE
      part_code = _part_code;
END;
$$;


ALTER FUNCTION inventory.get_base_uom(_part_code character varying) OWNER TO postgres;

SET search_path = measurement, pg_catalog;

--
-- TOC entry 281 (class 1255 OID 56346)
-- Name: convert_quantity(character varying, double precision, character varying, character varying, timestamp with time zone); Type: FUNCTION; Schema: measurement; Owner: postgres
--

CREATE FUNCTION convert_quantity(_part_code character varying, _quantity double precision, _uom_code_from character varying, _uom_code_to character varying, _valid_from_date timestamp with time zone DEFAULT NULL::timestamp with time zone) RETURNS double precision
    LANGUAGE plpgsql
    AS $$

DECLARE
  __uom_domain_to character varying;
  __uom_domain_from character varying;
  __unit_conversion_array common.unit_conversion_type[];
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

  raise NOTICE 'array dump %', __unit_conversion_array;
  raise NOTICE 'array unnest %', unnest(array[__unit_conversion_array[1]]);


  case when __unit_conversion_array @> ARRAY[(_uom_code_from,_uom_code_to,null)::mdm.unit_conversion_type] THEN
  RAISE NOTICE 'ok %', __unit_conversion_array;
  else RAISE NOTICE 'not ok %', __unit_conversion_array;
  end case
  
  */

  -- визначити домен одиниці виміру, до якої приводимо
  __uom_domain_to := uom.get_domain(_uom_code := _uom_code_to);
  -- визначити домен одиниці виміру, з якої приводимо
  __uom_domain_from := uom.get_domain(_uom_code := _uom_code_from);

  --RAISE NOTICE 'conversion from % to %', __uom_domain_to, __uom_domain_from;

  IF (_valid_from_date IS NULL) THEN
    _valid_from_date := now();
  END IF;

  -- якщо той самий домен, то використовуємо коефіцієнт Сі
  IF (__uom_domain_from = __uom_domain_to) THEN
    --RAISE NOTICE 'formula = % * %', _quantity, mdm.get_factor(_uom_code_from, _uom_code_to);
    RETURN _quantity * uom.get_factor(_uom_code_from, _uom_code_to);
  END IF;

    __unit_conversion_array := measurement.get_uom_conversion_factors(
      _part_code := _part_code,
      _uom_domain_from := __uom_domain_from,
      _uom_domain_to := __uom_domain_to,
      _valid_from_date := _valid_from_date);

    -- логіка перетворення з основного домену в додатковий
    IF (array_ndims(__unit_conversion_array) >= 1) THEN

      FOREACH __m IN
        ARRAY __unit_conversion_array
      LOOP 
        IF (__m.uom_code_from = _uom_code_from AND __m.uom_code_to = _uom_code_to) THEN
          RAISE NOTICE 'full forward match % to % = %',_uom_code_from, _uom_code_to, __m.factor;
          RETURN _quantity * (__m.factor ^ __exponentiation);
        END IF;
      END LOOP;

      FOREACH __m IN
        ARRAY __unit_conversion_array
      LOOP 
        IF ( __m.uom_code_from = _uom_code_from) THEN
          RAISE NOTICE 'partial forward _from_ match % to % = %',_uom_code_from, __m.uom_code_to, __m.factor;
          RETURN _quantity *  
            (__m.factor ^ __exponentiation) *
            uom.get_factor(_uom_code_to, __m.uom_code_to);
        END IF;
      END LOOP;

      FOREACH __m IN
        ARRAY __unit_conversion_array
      LOOP 
        IF ( __m.uom_code_to = _uom_code_to) THEN
          RAISE NOTICE 'partial forward _to_ match % to % = %',__m.uom_code_from, _uom_code_to, __m.factor;
          RETURN _quantity * 
            (__m.factor ^ __exponentiation) * 
            uom.get_factor(_uom_code_from, __m.uom_code_from);
        END IF;
      END LOOP;

      RAISE NOTICE 'finally forward match % to % = %', 
        __unit_conversion_array[1].uom_code_from, 
        __unit_conversion_array[1].uom_code_to, 
        __unit_conversion_array[1].factor;
      RETURN _quantity * 
        uom.get_factor(_uom_code_from, __unit_conversion_array[1].uom_code_from) * 
        (__unit_conversion_array[1].factor ^ __exponentiation) *
        uom.get_factor(__unit_conversion_array[1].uom_code_to, _uom_code_to);

    -- логіка перетворення з додаткового в основний домен
    ELSE
      __unit_conversion_array := measurement.get_uom_conversion_factors(
        _part_code := _part_code,
        _uom_domain_from := __uom_domain_to,
        _uom_domain_to := __uom_domain_from,
        _valid_from_date := _valid_from_date);

      IF (array_ndims(__unit_conversion_array) >= 1) THEN
        __exponentiation := -1;

        FOREACH __m IN
          ARRAY __unit_conversion_array
        LOOP 
          IF (__m.uom_code_from = _uom_code_to AND __m.uom_code_to = _uom_code_from) THEN
            RAISE NOTICE 'full reverse match % to % = %',_uom_code_from, _uom_code_to, __m.factor;
            RETURN _quantity * (__m.factor ^ __exponentiation);
          END IF;
        END LOOP;

        FOREACH __m IN
          ARRAY __unit_conversion_array
        LOOP 
          IF ( __m.uom_code_from = _uom_code_to) THEN
            RAISE NOTICE 'partial reverse _from_ match % to % = %',_uom_code_from, __m.uom_code_to, __m.factor;
            RETURN _quantity *  
              (__m.factor ^ __exponentiation) *
              uom.get_factor(_uom_code_from ,  __m.uom_code_to);
          END IF;
        END LOOP;

        FOREACH __m IN
          ARRAY __unit_conversion_array
        LOOP 
          IF ( __m.uom_code_to = _uom_code_from) THEN
            RAISE NOTICE 'partial reverse _to_ match % to % = %',__m.uom_code_to, _uom_code_from, __m.factor;
            RETURN _quantity * 
              (__m.factor ^ __exponentiation) * 
              uom.get_factor(_uom_code_to, __m.uom_code_from);
          END IF;
        END LOOP;

        RAISE NOTICE 'finally reverse match % to % = %',
          __unit_conversion_array[1].uom_code_from,
          __unit_conversion_array[1].uom_code_to,
          __unit_conversion_array[1].factor;
        RETURN _quantity * 
          uom.get_factor(_uom_code_from ,  __unit_conversion_array[1].uom_code_to) *
          (__unit_conversion_array[1].factor ^ __exponentiation) *
          uom.get_factor(__unit_conversion_array[1].uom_code_from, _uom_code_to);

      ELSE
        --RETURN 987654321;
        RAISE EXCEPTION 'no conversion factor found for measure domains % and % for % entity at %',
          __uom_domain_from,
          __uom_domain_to, 
          _part_code,
          _valid_from_date;
          
      END IF;

    END IF;

END;

$$;


ALTER FUNCTION measurement.convert_quantity(_part_code character varying, _quantity double precision, _uom_code_from character varying, _uom_code_to character varying, _valid_from_date timestamp with time zone) OWNER TO postgres;

--
-- TOC entry 282 (class 1255 OID 56347)
-- Name: create_factor(character varying, character varying, double precision, timestamp with time zone, timestamp with time zone); Type: FUNCTION; Schema: measurement; Owner: postgres
--

CREATE FUNCTION create_factor(_part_code character varying, _uom_code character varying, _factor double precision DEFAULT (1.0)::double precision, _end_date timestamp with time zone DEFAULT NULL::timestamp with time zone, _start_date timestamp with time zone DEFAULT NULL::timestamp with time zone) RETURNS void
    LANGUAGE plpgsql
    AS $$
DECLARE
  __prev_end_date timestamp with time zone;
BEGIN

  -- start_date IS NULL for conversion factors created on MDM node. This should not be NULL on holons
  IF (_start_date IS NULL) THEN
    _start_date := now() + common.get_param_measurement_apply_latency();
  END IF;

  -- define previous end date of measure conversion factor validity
  __prev_end_date := prev_end_date
    FROM
      measurement.information
    WHERE
      part_code = _part_code AND
      uom_code = _uom_code AND
      end_date IS NULL;
  
  -- if previous start date not exists, this is first time insertion
  IF NOT FOUND THEN
    --__prev_end_date := '1970-01-01'::timestamp with time zone;
    __prev_end_date := _start_date;
  END IF;

  INSERT INTO measurement.information
  (
    part_code,
    uom_code,
    uom_base_code,
    factor,
    prev_end_date,
    start_date,
    end_date
  )
  VALUES
  (
    _part_code,
    _uom_code,
    measurement.get_base_uom(_part_code),
    _factor,
    __prev_end_date,
    _start_date,
    _end_date
  );

END;
$$;


ALTER FUNCTION measurement.create_factor(_part_code character varying, _uom_code character varying, _factor double precision, _end_date timestamp with time zone, _start_date timestamp with time zone) OWNER TO postgres;

--
-- TOC entry 3394 (class 0 OID 0)
-- Dependencies: 282
-- Name: FUNCTION create_factor(_part_code character varying, _uom_code character varying, _factor double precision, _end_date timestamp with time zone, _start_date timestamp with time zone); Type: COMMENT; Schema: measurement; Owner: postgres
--

COMMENT ON FUNCTION create_factor(_part_code character varying, _uom_code character varying, _factor double precision, _end_date timestamp with time zone, _start_date timestamp with time zone) IS 'Helper for create new factor';


--
-- TOC entry 283 (class 1255 OID 56348)
-- Name: expire_factor(character varying, character varying, timestamp with time zone); Type: FUNCTION; Schema: measurement; Owner: postgres
--

CREATE FUNCTION expire_factor(_part_code character varying, _uom_code character varying, _end_date timestamp with time zone) RETURNS void
    LANGUAGE plpgsql
    AS $$
BEGIN

  UPDATE
    measurement.information
  SET 
    end_date = _end_date
  WHERE 
    part_code = _part_code AND
    uom_code = _uom_code AND
    end_date IS NULL;
  
END;
$$;


ALTER FUNCTION measurement.expire_factor(_part_code character varying, _uom_code character varying, _end_date timestamp with time zone) OWNER TO postgres;

--
-- TOC entry 3395 (class 0 OID 0)
-- Dependencies: 283
-- Name: FUNCTION expire_factor(_part_code character varying, _uom_code character varying, _end_date timestamp with time zone); Type: COMMENT; Schema: measurement; Owner: postgres
--

COMMENT ON FUNCTION expire_factor(_part_code character varying, _uom_code character varying, _end_date timestamp with time zone) IS 'Helper for expire factor';


--
-- TOC entry 284 (class 1255 OID 56349)
-- Name: get_base_uom(character varying, timestamp with time zone); Type: FUNCTION; Schema: measurement; Owner: postgres
--

CREATE FUNCTION get_base_uom(_part_code character varying, _valid_from_date timestamp with time zone DEFAULT NULL::timestamp with time zone) RETURNS character varying
    LANGUAGE plpgsql
    AS $$
BEGIN

  IF (_valid_from_date IS NOT NULL) THEN
    RETURN uom_base_code
      FROM
        measurement.information
      WHERE
        part_code = _part_code AND
        factor = 1 AND
        _valid_from_date BETWEEN start_date AND COALESCE (end_date, now());

  ELSE
    RETURN inventory.get_base_uom(_part_code := _part_code);
  END IF;
END;
$$;


ALTER FUNCTION measurement.get_base_uom(_part_code character varying, _valid_from_date timestamp with time zone) OWNER TO postgres;

--
-- TOC entry 285 (class 1255 OID 56350)
-- Name: get_uom_conversion_factors(character varying, character varying, character varying, timestamp with time zone); Type: FUNCTION; Schema: measurement; Owner: postgres
--

CREATE FUNCTION get_uom_conversion_factors(_part_code character varying, _uom_domain_from character varying, _uom_domain_to character varying, _valid_from_date timestamp with time zone DEFAULT now()) RETURNS common.unit_conversion_type[]
    LANGUAGE plpgsql
    AS $$
DECLARE
  __conversion_array common.unit_conversion_type[];
  __cursor_record RECORD;
  __idx integer DEFAULT 1;
  
BEGIN

  FOR __cursor_record IN
    SELECT
      meas.uom_base_code AS uom_code_from, 
      meas.uom_code AS uom_code_to,
      meas.factor AS factor
    FROM 
      measurement.information meas, 
      uom.information uom_from, 
      uom.information uom_to
    WHERE 
      uom_from.uom_code = meas.uom_base_code AND
      uom_to.uom_code = meas.uom_code AND
      meas.part_code = _part_code AND
      uom_from.uom_domain = _uom_domain_from AND 
      uom_to.uom_domain = _uom_domain_to AND
      _valid_from_date BETWEEN meas.start_date AND COALESCE (meas.end_date, now())
  LOOP
    --PERFORM array_append(__conversion_array, __cursor_record::mdm.unit_conversion_type);
    __conversion_array[__idx] := __cursor_record;
    __idx := __idx + 1;
  END LOOP;

  RETURN __conversion_array;

END
$$;


ALTER FUNCTION measurement.get_uom_conversion_factors(_part_code character varying, _uom_domain_from character varying, _uom_domain_to character varying, _valid_from_date timestamp with time zone) OWNER TO postgres;

--
-- TOC entry 286 (class 1255 OID 56351)
-- Name: replace_factor(character varying, character varying, double precision, timestamp with time zone, timestamp with time zone); Type: FUNCTION; Schema: measurement; Owner: postgres
--

CREATE FUNCTION replace_factor(_part_code character varying, _uom_code character varying, _factor double precision DEFAULT (1.0)::double precision, _end_date timestamp with time zone DEFAULT NULL::timestamp with time zone, _start_date timestamp with time zone DEFAULT NULL::timestamp with time zone) RETURNS void
    LANGUAGE plpgsql
    AS $$
DECLARE
  __prev_end_date timestamp with time zone;
BEGIN

  -- start_date IS NULL for conversion factors created on MDM node. This should not be NULL on holons
  IF (_start_date IS NULL) THEN
    _start_date := now() + common.get_param_measurement_apply_latency();
  END IF;

  -- define previous end date of measure conversion factor validity
  __prev_end_date := prev_end_date
    FROM
      measurement.information
    WHERE
      part_code = _part_code AND
      uom_code = _uom_code AND
      end_date IS NULL;
  
  -- if previous start date not exists, this is first time insertion
  IF NOT FOUND THEN
    --__prev_end_date := '1970-01-01'::timestamp with time zone;
    __prev_end_date := _start_date;
  END IF;

  PERFORM measurement.expire_factor(
    _part_code := _part_code,
    _uom_code := _uom_code,
    _end_date := _start_date);

  PERFORM measurement.create_factor(
    _part_code := _part_code,
    _uom_code := _uom_code,
    _factor := _factor,
    _end_date := _end_date,
    _start_date := _start_date);
  

END;
$$;


ALTER FUNCTION measurement.replace_factor(_part_code character varying, _uom_code character varying, _factor double precision, _end_date timestamp with time zone, _start_date timestamp with time zone) OWNER TO postgres;

--
-- TOC entry 3396 (class 0 OID 0)
-- Dependencies: 286
-- Name: FUNCTION replace_factor(_part_code character varying, _uom_code character varying, _factor double precision, _end_date timestamp with time zone, _start_date timestamp with time zone); Type: COMMENT; Schema: measurement; Owner: postgres
--

COMMENT ON FUNCTION replace_factor(_part_code character varying, _uom_code character varying, _factor double precision, _end_date timestamp with time zone, _start_date timestamp with time zone) IS 'Helper for substitute old factor with new value';


SET search_path = pgunit, pg_catalog;

--
-- TOC entry 287 (class 1255 OID 56352)
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
-- TOC entry 288 (class 1255 OID 56353)
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
-- TOC entry 289 (class 1255 OID 56354)
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
-- TOC entry 290 (class 1255 OID 56355)
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
-- TOC entry 291 (class 1255 OID 56356)
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
-- TOC entry 292 (class 1255 OID 56357)
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
-- TOC entry 293 (class 1255 OID 56358)
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
-- TOC entry 294 (class 1255 OID 56359)
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
-- TOC entry 295 (class 1255 OID 56360)
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
-- TOC entry 296 (class 1255 OID 56361)
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
-- TOC entry 297 (class 1255 OID 56362)
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
-- TOC entry 298 (class 1255 OID 56363)
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
-- TOC entry 299 (class 1255 OID 56364)
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
-- TOC entry 300 (class 1255 OID 56365)
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
-- TOC entry 301 (class 1255 OID 56366)
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
-- TOC entry 302 (class 1255 OID 56367)
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

SET search_path = schedule, pg_catalog;

--
-- TOC entry 303 (class 1255 OID 56368)
-- Name: get_date_of_julianized_day(integer); Type: FUNCTION; Schema: schedule; Owner: postgres
--

CREATE FUNCTION get_date_of_julianized_day(__jylianized_day integer) RETURNS date
    LANGUAGE plpgsql
    AS $$
DECLARE
  _julianized_day_date date;
BEGIN

  SELECT 
    calendar.calendar_date
  FROM 
    schedule.calendar
  WHERE 
    calendar.julianized_day = __jylianized_day
  ORDER BY
    calendar.calendar_date ASC
  LIMIT 1
  INTO
    _julianized_day_date;

  IF (NOT FOUND) THEN
    RAISE EXCEPTION 'No schedule found for day number: %', __jylianized_day;
  END IF;

  RETURN _julianized_day_date;

END;
$$;


ALTER FUNCTION schedule.get_date_of_julianized_day(__jylianized_day integer) OWNER TO postgres;

--
-- TOC entry 304 (class 1255 OID 56369)
-- Name: get_julianized_day(date); Type: FUNCTION; Schema: schedule; Owner: postgres
--

CREATE FUNCTION get_julianized_day(__date date) RETURNS integer
    LANGUAGE plpgsql
    AS $$
DECLARE
  _julianized_day integer;
BEGIN

  SELECT
    calendar.julianized_day
  FROM 
    schedule.calendar
  WHERE 
    calendar.calendar_date = __date
  INTO
    _julianized_day;

  IF (NOT FOUND) THEN
    RAISE EXCEPTION 'No schedule found for date: %', __date;
  END IF;

  RETURN _julianized_day;

END;
$$;


ALTER FUNCTION schedule.get_julianized_day(__date date) OWNER TO postgres;

--
-- TOC entry 305 (class 1255 OID 56370)
-- Name: get_julianized_week(date); Type: FUNCTION; Schema: schedule; Owner: postgres
--

CREATE FUNCTION get_julianized_week(__date date) RETURNS integer
    LANGUAGE plpgsql
    AS $$
DECLARE
  _julianized_week integer;
BEGIN

  SELECT
    calendar.julianized_week
  FROM 
    schedule.calendar
  WHERE 
    calendar.calendar_date = __date
  INTO
    _julianized_week;

  IF (NOT FOUND) THEN
    RAISE EXCEPTION 'No schedule found for date: %', __date;
  END IF;

  RETURN _julianized_week;

END;
$$;


ALTER FUNCTION schedule.get_julianized_week(__date date) OWNER TO postgres;

SET search_path = tests, pg_catalog;

--
-- TOC entry 306 (class 1255 OID 56371)
-- Name: _load_data(); Type: FUNCTION; Schema: tests; Owner: postgres
--

CREATE FUNCTION _load_data() RETURNS void
    LANGUAGE plpgsql
    AS $$
BEGIN

  --SET search_path = component, pg_catalog;
  INSERT INTO inventory.assembly VALUES ('11.31.050-001', 1, '11с31п-50х40', '2017-10-21', 'ASSEMBLY');
  INSERT INTO inventory.assembly VALUES ('11.32.050-001', 1, '11с32п-50х40', '2017-10-21', 'ASSEMBLY');
  INSERT INTO inventory.assembly VALUES ('11.33.050-001', 1, '11с33п-50х40', '2017-10-21', 'ASSEMBLY');
  INSERT INTO inventory.assembly VALUES ('80.31.050-001', 1, 'Крпс-089,0х109,0', '2017-10-21', 'ASSEMBLY');
  INSERT INTO inventory.assembly VALUES ('82.31.050-001', 1, 'Рчк-250х20', '2017-10-21', 'ASSEMBLY');

  INSERT INTO inventory.buyable VALUES ('Гайка М12', 1, 'Гайка-М12', '2017-10-21', 'BUYABLE');

  INSERT INTO inventory.part VALUES ('22.16.050-001', 1, 'КТ33-50х40', '2017-10-21', 'PART');
  INSERT INTO inventory.part VALUES ('22.25.050-001', 1, 'КТ32-50х40', '2017-10-21', 'PART');
  INSERT INTO inventory.part VALUES ('40.31.050-001', 1, 'Птрб-057,0х126,0', '2017-10-21', 'PART');
  INSERT INTO inventory.part VALUES ('40.32.050-001', 1, 'Птрб-057,0х074,0', '2017-10-21', 'PART');
  INSERT INTO inventory.part VALUES ('40.33.050-001', 1, 'Птрб-057,0х054,0', '2017-10-21', 'PART');
  INSERT INTO inventory.part VALUES ('41.31.050-001', 1, 'Крпс-089,0х109,0', '2017-10-21', 'PART');
  INSERT INTO inventory.part VALUES ('42.01.050-001', 1, 'Ббшк-022,0х044,0', '2017-10-21', 'PART');
  INSERT INTO inventory.part VALUES ('50.01.050-001', 1, 'Втлк-050,0х039,0', '2017-10-21', 'PART');
  INSERT INTO inventory.part VALUES ('60.01.050-001', 1, 'ШП-068,0х052,5', '2017-10-21', 'PART');
  INSERT INTO inventory.part VALUES ('51.01.050-001', 1, 'Пржн-050,6х042,0', '2017-10-21', 'PART');
  INSERT INTO inventory.part VALUES ('61.01.050-001', 1, 'Штк-013,3х075,0', '2017-10-21', 'PART');
  INSERT INTO inventory.part VALUES ('52.01.050-001', 1, 'Шйб-051,0х042,6', '2017-10-21', 'PART');
  INSERT INTO inventory.part VALUES ('70.01.050-001', 1, 'Ф4-051,5х041,7х11,0', '2017-10-21', 'PART');
  INSERT INTO inventory.part VALUES ('71.02.050-001', 1, 'Кршк-ПП-50', '2017-10-21', 'PART');
  INSERT INTO inventory.part VALUES ('71.03.050-001', 1, 'Зглш-ПП-50', '2017-10-21', 'PART');
  INSERT INTO inventory.part VALUES ('55.31.050-001', 1, 'Рчк-250х20', '2017-10-21', 'PART');
  INSERT INTO inventory.part VALUES ('53.01.004-001', 1, 'Штфт-4', '2017-10-21', 'PART');
  INSERT INTO inventory.part VALUES ('70.04.020-001', 1, 'Клц-20', '2017-10-21', 'PART');
  INSERT INTO inventory.part VALUES ('72.01.009-001', 1, 'Клц-009', '2017-10-21', 'PART');
  INSERT INTO inventory.part VALUES ('42.02.022-001', 1, 'Втлк-Р-50х18', '2017-10-21', 'PART');

  --SET search_path = ebom, pg_catalog;
  INSERT INTO ebom.information VALUES (1, DEFAULT, '11.31.050-001', 1, '11с31п-50х40: information', '2017-10-23');
  INSERT INTO ebom.definition VALUES (1, DEFAULT, '11с31п-50х40: definition', 1, '2017-10-21', NULL, NULL, 'PROPOSED', '2017-10-21 20:55:30.985148+03', 1);
  INSERT INTO ebom.assembly VALUES (1, '80.31.050-001', 1, 1.0000, 'pcs', 'ASSEMBLY');
  INSERT INTO ebom.assembly VALUES (1, '82.31.050-001', 1, 1.0000, 'pcs', 'ASSEMBLY');
  INSERT INTO ebom.buyable VALUES (1, 'Гайка М12', 1, 1.0000, 'pcs', 'BUYABLE');
  INSERT INTO ebom.part VALUES (1, '40.31.050-001', 1, 2.0000, 'pcs', 'PART');
  INSERT INTO ebom.part VALUES (1, '50.01.050-001', 1, 2.0000, 'pcs', 'PART');
  INSERT INTO ebom.part VALUES (1, '51.01.050-001', 1, 2.0000, 'pcs', 'PART');
  INSERT INTO ebom.part VALUES (1, '52.01.050-001', 1, 2.0000, 'pcs', 'PART');
  INSERT INTO ebom.part VALUES (1, '53.01.004-001', 1, 1.0000, 'pcs', 'PART');
  INSERT INTO ebom.part VALUES (1, '60.01.050-001', 1, 1.0000, 'pcs', 'PART');
  INSERT INTO ebom.part VALUES (1, '61.01.050-001', 1, 1.0000, 'pcs', 'PART');
  INSERT INTO ebom.part VALUES (1, '70.01.050-001', 1, 2.0000, 'pcs', 'PART');
  INSERT INTO ebom.part VALUES (1, '70.04.020-001', 1, 1.0000, 'pcs', 'PART');
  INSERT INTO ebom.part VALUES (1, '72.01.009-001', 1, 2.0000, 'pcs', 'PART');

  --SET search_path = material, pg_catalog;
  INSERT INTO inventory.consumable VALUES ('22.16.050-001', 1, 'КТ33-50х40', '2017-10-22', 'CONSUMABLE');
  INSERT INTO inventory.consumable VALUES ('22.25.050-001', 1, 'КТ32-50х40', '2017-10-22', 'CONSUMABLE');
  INSERT INTO inventory.consumable VALUES ('40.31.050-001', 1, 'Птрб-057,0х126,0', '2017-10-22', 'CONSUMABLE');
  INSERT INTO inventory.consumable VALUES ('40.32.050-001', 1, 'Птрб-057,0х074,0', '2017-10-22', 'CONSUMABLE');
  INSERT INTO inventory.consumable VALUES ('40.33.050-001', 1, 'Птрб-057,0х054,0', '2017-10-22', 'CONSUMABLE');
  INSERT INTO inventory.consumable VALUES ('41.31.050-001', 1, 'Крпс-089,0х109,0', '2017-10-22', 'CONSUMABLE');
  INSERT INTO inventory.consumable VALUES ('42.01.050-001', 1, 'Ббшк-022,0х044,0', '2017-10-22', 'CONSUMABLE');
  INSERT INTO inventory.consumable VALUES ('50.01.050-001', 1, 'Втлк-050,0х039,0', '2017-10-22', 'CONSUMABLE');
  INSERT INTO inventory.consumable VALUES ('60.01.050-001', 1, 'ШП-068,0х052,5', '2017-10-22', 'CONSUMABLE');
  INSERT INTO inventory.consumable VALUES ('51.01.050-001', 1, 'Пржн-050,6х042,0', '2017-10-22', 'CONSUMABLE');
  INSERT INTO inventory.consumable VALUES ('61.01.050-001', 1, 'Штк-013,3х075,0', '2017-10-22', 'CONSUMABLE');
  INSERT INTO inventory.consumable VALUES ('52.01.050-001', 1, 'Шйб-051,0х042,6', '2017-10-22', 'CONSUMABLE');
  INSERT INTO inventory.consumable VALUES ('70.01.050-001', 1, 'Ф4-051,5х041,7х11,0', '2017-10-22', 'CONSUMABLE');
  INSERT INTO inventory.consumable VALUES ('71.02.050-001', 1, 'Кршк-ПП-50', '2017-10-22', 'CONSUMABLE');
  INSERT INTO inventory.consumable VALUES ('71.03.050-001', 1, 'Зглш-ПП-50', '2017-10-22', 'CONSUMABLE');
  INSERT INTO inventory.consumable VALUES ('55.31.050-001', 1, 'Рчк-250х20', '2017-10-22', 'CONSUMABLE');
  INSERT INTO inventory.consumable VALUES ('53.01.004-001', 1, 'Штфт-4', '2017-10-22', 'CONSUMABLE');
  INSERT INTO inventory.consumable VALUES ('70.04.020-001', 1, 'Клц-20', '2017-10-22', 'CONSUMABLE');
  INSERT INTO inventory.consumable VALUES ('72.01.009-001', 1, 'Клц-009', '2017-10-22', 'CONSUMABLE');
  INSERT INTO inventory.consumable VALUES ('42.02.022-001', 1, 'Втлк-Р-50х18', '2017-10-22', 'CONSUMABLE');
  INSERT INTO inventory.consumable VALUES ('80.31.050-001', 1, 'Крпс-089,0х109,0', '2017-10-22', 'CONSUMABLE');
  INSERT INTO inventory.consumable VALUES ('82.31.050-001', 1, 'Рчк-250х20', '2017-10-22', 'CONSUMABLE');
  INSERT INTO inventory.consumable VALUES ('53.01.004-001.010', 1, 'Штфт-004,0х012,0', '2017-10-22', 'CONSUMABLE');
  INSERT INTO inventory.consumable VALUES ('40.31.050-001.010', 1, 'Птрб-057,0х126,0', '2017-10-22', 'CONSUMABLE');
  INSERT INTO inventory.consumable VALUES ('82.31.050-001.010', 1, 'Рчк-250х20', '2017-10-22', 'CONSUMABLE');
  INSERT INTO inventory.consumable VALUES ('40.32.050-001.010', 1, 'Птрб-057,0х074,0', '2017-10-22', 'CONSUMABLE');
  INSERT INTO inventory.consumable VALUES ('80.31.050-001.010', 1, 'Крпс-089,0х109,0', '2017-10-22', 'CONSUMABLE');
  INSERT INTO inventory.consumable VALUES ('60.01.050-001.020', 1, 'ШП-068,0х052,5', '2017-10-22', 'CONSUMABLE');
  INSERT INTO inventory.consumable VALUES ('22.25.050-001.030', 1, 'КТ32-50х40', '2017-10-22', 'CONSUMABLE');
  INSERT INTO inventory.consumable VALUES ('40.33.050-001.010', 1, 'Птрб-057,0х054,0', '2017-10-22', 'CONSUMABLE');
  INSERT INTO inventory.consumable VALUES ('51.01.050-001.010', 1, 'Пржн-050,6х042,0', '2017-10-22', 'CONSUMABLE');
  INSERT INTO inventory.consumable VALUES ('60.01.050-001.010', 1, 'ШП-068,0х052,5', '2017-10-22', 'CONSUMABLE');
  INSERT INTO inventory.consumable VALUES ('60.01.050-001.030', 1, 'ШП-068,0х052,5', '2017-10-22', 'CONSUMABLE');
  INSERT INTO inventory.consumable VALUES ('41.31.050-001.010', 1, 'Крпс-089,0х109,0', '2017-10-22', 'CONSUMABLE');
  INSERT INTO inventory.consumable VALUES ('41.31.050-001.020', 1, 'Крпс-089,0х109,0', '2017-10-22', 'CONSUMABLE');
  INSERT INTO inventory.consumable VALUES ('60.01.050-001.011', 1, 'ШП-068,0х052,5', '2017-10-22', 'CONSUMABLE');
  INSERT INTO inventory.consumable VALUES ('22.16.050-001.030', 1, 'КТ33-50х40', '2017-10-22', 'CONSUMABLE');
  INSERT INTO inventory.consumable VALUES ('Гайка М12', 1, 'Гайка М12', '2017-10-24', 'CONSUMABLE');

  INSERT INTO inventory.primal VALUES ('Квд-080х080-ст3ПС', 1, 'Квд-ст3ПС-080х080', '2017-10-22', 'PRIMAL');
  INSERT INTO inventory.primal VALUES ('Крг-004,0-ст45', 1, 'Крг-ст45-004,0', '2017-10-22', 'PRIMAL');
  INSERT INTO inventory.primal VALUES ('Крг-016-ст20Х13', 1, 'Крг-ст20Х13-016', '2017-10-22', 'PRIMAL');
  INSERT INTO inventory.primal VALUES ('Крг-022-ст20', 1, 'Крг-ст20-022', '2017-10-22', 'PRIMAL');
  INSERT INTO inventory.primal VALUES ('Лст-000,8-ст08Х17', 1, 'Лст-ст08Х17-000,8', '2017-10-22', 'PRIMAL');
  INSERT INTO inventory.primal VALUES ('Лст-001,0-ст08Х17', 1, 'Лст-ст08Х17-001,0', '2017-10-22', 'PRIMAL');
  INSERT INTO inventory.primal VALUES ('Лст-001,2-ст65Г', 1, 'Лст-ст65Г-001,2', '2017-10-22', 'PRIMAL');
  INSERT INTO inventory.primal VALUES ('Лст-003,0-ст3', 1, 'Лст-ст3-003,0', '2017-10-22', 'PRIMAL');
  INSERT INTO inventory.primal VALUES ('Лст-004,4-ст08Х17', 1, 'Лст-ст08Х17-004,4', '2017-10-22', 'PRIMAL');
  INSERT INTO inventory.primal VALUES ('ПЕ 15803-020', 1, 'ПЕ 15803-020', '2017-10-22', 'PRIMAL');
  INSERT INTO inventory.primal VALUES ('Плс-020х4-ст3', 1, 'Плс-ст3-020х4', '2017-10-22', 'PRIMAL');
  INSERT INTO inventory.primal VALUES ('Трб-057,0х03,5-ст20-Ш', 1, 'Трб-ст20-057,0х03,5-Ш', '2017-10-22', 'PRIMAL');
  INSERT INTO inventory.primal VALUES ('Трб-068,0х03,5-ст20Х13', 1, 'Трб-ст20Х13-068,0х03,5', '2017-10-22', 'PRIMAL');
  INSERT INTO inventory.primal VALUES ('Трб-068,0х04,0-ст20Х13', 1, 'Трб-ст20Х13-068,0х04,0', '2017-10-22', 'PRIMAL');
  INSERT INTO inventory.primal VALUES ('Трб-089,0х03,0-ст20-Ш', 1, 'Трб-ст20-089,0х03,0-Ш', '2017-10-22', 'PRIMAL');
  INSERT INTO inventory.primal VALUES ('Трб-089,0х03,5-ст20-Ш', 1, 'Трб-ст20-089,0х03,5-Ш', '2017-10-22', 'PRIMAL');
  INSERT INTO inventory.primal VALUES ('Ф-4', 1, 'Ф-4', '2017-10-22', 'PRIMAL');

  INSERT INTO inventory.producible VALUES ('22.16.050-001', 1, 'КТ33-50х40', '2017-10-22', 'PRODUCIBLE');
  INSERT INTO inventory.producible VALUES ('22.25.050-001', 1, 'КТ32-50х40', '2017-10-22', 'PRODUCIBLE');
  INSERT INTO inventory.producible VALUES ('40.31.050-001', 1, 'Птрб-057,0х126,0', '2017-10-22', 'PRODUCIBLE');
  INSERT INTO inventory.producible VALUES ('40.32.050-001', 1, 'Птрб-057,0х074,0', '2017-10-22', 'PRODUCIBLE');
  INSERT INTO inventory.producible VALUES ('40.33.050-001', 1, 'Птрб-057,0х054,0', '2017-10-22', 'PRODUCIBLE');
  INSERT INTO inventory.producible VALUES ('41.31.050-001', 1, 'Крпс-089,0х109,0', '2017-10-22', 'PRODUCIBLE');
  INSERT INTO inventory.producible VALUES ('42.01.050-001', 1, 'Ббшк-022,0х044,0', '2017-10-22', 'PRODUCIBLE');
  INSERT INTO inventory.producible VALUES ('50.01.050-001', 1, 'Втлк-050,0х039,0', '2017-10-22', 'PRODUCIBLE');
  INSERT INTO inventory.producible VALUES ('60.01.050-001', 1, 'ШП-068,0х052,5', '2017-10-22', 'PRODUCIBLE');
  INSERT INTO inventory.producible VALUES ('51.01.050-001', 1, 'Пржн-050,6х042,0', '2017-10-22', 'PRODUCIBLE');
  INSERT INTO inventory.producible VALUES ('61.01.050-001', 1, 'Штк-013,3х075,0', '2017-10-22', 'PRODUCIBLE');
  INSERT INTO inventory.producible VALUES ('52.01.050-001', 1, 'Шйб-051,0х042,6', '2017-10-22', 'PRODUCIBLE');
  INSERT INTO inventory.producible VALUES ('70.01.050-001', 1, 'Ф4-051,5х041,7х11,0', '2017-10-22', 'PRODUCIBLE');
  INSERT INTO inventory.producible VALUES ('71.02.050-001', 1, 'Кршк-ПП-50', '2017-10-22', 'PRODUCIBLE');
  INSERT INTO inventory.producible VALUES ('71.03.050-001', 1, 'Зглш-ПП-50', '2017-10-22', 'PRODUCIBLE');
  INSERT INTO inventory.producible VALUES ('55.31.050-001', 1, 'Рчк-250х20', '2017-10-22', 'PRODUCIBLE');
  INSERT INTO inventory.producible VALUES ('53.01.004-001', 1, 'Штфт-4', '2017-10-22', 'PRODUCIBLE');
  INSERT INTO inventory.producible VALUES ('70.04.020-001', 1, 'Клц-20', '2017-10-22', 'PRODUCIBLE');
  INSERT INTO inventory.producible VALUES ('72.01.009-001', 1, 'Клц-009', '2017-10-22', 'PRODUCIBLE');
  INSERT INTO inventory.producible VALUES ('42.02.022-001', 1, 'Втлк-Р-50х18', '2017-10-22', 'PRODUCIBLE');
  INSERT INTO inventory.producible VALUES ('11.31.050-001', 1, '11с31п-50х40', '2017-10-22', 'PRODUCIBLE');
  INSERT INTO inventory.producible VALUES ('11.32.050-001', 1, '11с32п-50х40', '2017-10-22', 'PRODUCIBLE');
  INSERT INTO inventory.producible VALUES ('11.33.050-001', 1, '11с33п-50х40', '2017-10-22', 'PRODUCIBLE');
  INSERT INTO inventory.producible VALUES ('80.31.050-001', 1, 'Крпс-089,0х109,0', '2017-10-22', 'PRODUCIBLE');
  INSERT INTO inventory.producible VALUES ('82.31.050-001', 1, 'Рчк-250х20', '2017-10-22', 'PRODUCIBLE');
  INSERT INTO inventory.producible VALUES ('53.01.004-001.010', 1, 'Штфт-004,0х012,0', '2017-10-22', 'PRODUCIBLE');
  INSERT INTO inventory.producible VALUES ('40.31.050-001.010', 1, 'Птрб-057,0х126,0', '2017-10-22', 'PRODUCIBLE');
  INSERT INTO inventory.producible VALUES ('82.31.050-001.010', 1, 'Рчк-250х20', '2017-10-22', 'PRODUCIBLE');
  INSERT INTO inventory.producible VALUES ('40.32.050-001.010', 1, 'Птрб-057,0х074,0', '2017-10-22', 'PRODUCIBLE');
  INSERT INTO inventory.producible VALUES ('80.31.050-001.010', 1, 'Крпс-089,0х109,0', '2017-10-22', 'PRODUCIBLE');
  INSERT INTO inventory.producible VALUES ('60.01.050-001.020', 1, 'ШП-068,0х052,5', '2017-10-22', 'PRODUCIBLE');
  INSERT INTO inventory.producible VALUES ('22.25.050-001.030', 1, 'КТ32-50х40', '2017-10-22', 'PRODUCIBLE');
  INSERT INTO inventory.producible VALUES ('40.33.050-001.010', 1, 'Птрб-057,0х054,0', '2017-10-22', 'PRODUCIBLE');
  INSERT INTO inventory.producible VALUES ('51.01.050-001.010', 1, 'Пржн-050,6х042,0', '2017-10-22', 'PRODUCIBLE');
  INSERT INTO inventory.producible VALUES ('60.01.050-001.010', 1, 'ШП-068,0х052,5', '2017-10-22', 'PRODUCIBLE');
  INSERT INTO inventory.producible VALUES ('60.01.050-001.030', 1, 'ШП-068,0х052,5', '2017-10-22', 'PRODUCIBLE');
  INSERT INTO inventory.producible VALUES ('41.31.050-001.010', 1, 'Крпс-089,0х109,0', '2017-10-22', 'PRODUCIBLE');
  INSERT INTO inventory.producible VALUES ('41.31.050-001.020', 1, 'Крпс-089,0х109,0', '2017-10-22', 'PRODUCIBLE');
  INSERT INTO inventory.producible VALUES ('60.01.050-001.011', 1, 'ШП-068,0х052,5', '2017-10-22', 'PRODUCIBLE');
  INSERT INTO inventory.producible VALUES ('22.16.050-001.030', 1, 'КТ33-50х40', '2017-10-22', 'PRODUCIBLE');

END;
$$;


ALTER FUNCTION tests._load_data() OWNER TO postgres;

--
-- TOC entry 307 (class 1255 OID 56373)
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
  TRUNCATE TABLE binding.ebom_to_mbom CASCADE;
  TRUNCATE TABLE binding.ebom_to_product CASCADE;
  TRUNCATE TABLE binding.ebom_to_route CASCADE;
  TRUNCATE TABLE binding.mbom_to_operation CASCADE;
  TRUNCATE TABLE binding.mbom_to_product CASCADE;
  TRUNCATE TABLE binding.operation_to_product CASCADE;
  TRUNCATE TABLE binding.route_to_mbom CASCADE;
  TRUNCATE TABLE binding.route_to_operation CASCADE;
  TRUNCATE TABLE ebom.assembly CASCADE;
  TRUNCATE TABLE ebom.buyable CASCADE;
  TRUNCATE TABLE ebom.component CASCADE;
  TRUNCATE TABLE ebom.definition CASCADE;
  TRUNCATE TABLE ebom.information CASCADE;
  TRUNCATE TABLE ebom.part CASCADE;
  TRUNCATE TABLE inventory.information CASCADE;
  TRUNCATE TABLE inventory.salable CASCADE;
  TRUNCATE TABLE inventory.consumable CASCADE;
  TRUNCATE TABLE inventory.information CASCADE;
  TRUNCATE TABLE inventory.primal CASCADE;
  TRUNCATE TABLE inventory.producible CASCADE;
  TRUNCATE TABLE inventory.assembly CASCADE;
  TRUNCATE TABLE inventory.buyable CASCADE;
  TRUNCATE TABLE inventory.information CASCADE;
  TRUNCATE TABLE inventory.part CASCADE;
  TRUNCATE TABLE mbom.consumable CASCADE;
  TRUNCATE TABLE mbom.definition CASCADE;
  TRUNCATE TABLE mbom.information CASCADE;
  TRUNCATE TABLE mbom.material CASCADE;
  TRUNCATE TABLE mbom.primal CASCADE;
  TRUNCATE TABLE operation.consumable CASCADE;
  TRUNCATE TABLE operation.definition CASCADE;
  TRUNCATE TABLE operation.dependency CASCADE;
  TRUNCATE TABLE operation.equipment CASCADE;
  TRUNCATE TABLE operation.information CASCADE;
  TRUNCATE TABLE operation.material CASCADE;
  TRUNCATE TABLE operation.personnel CASCADE;
  TRUNCATE TABLE operation.primal CASCADE;
  TRUNCATE TABLE operation.segment CASCADE;
  TRUNCATE TABLE operation.tooling CASCADE;
  TRUNCATE TABLE product.consumable CASCADE;
  TRUNCATE TABLE product.definition CASCADE;
  TRUNCATE TABLE product.dependency CASCADE;
  TRUNCATE TABLE product.equipment CASCADE;
  TRUNCATE TABLE product.information CASCADE;
  TRUNCATE TABLE product.material CASCADE;
  TRUNCATE TABLE product.personnel CASCADE;
  TRUNCATE TABLE product.primal CASCADE;
  TRUNCATE TABLE product.segment CASCADE;
  TRUNCATE TABLE product.tooling CASCADE;
  TRUNCATE TABLE route.consumable CASCADE;
  TRUNCATE TABLE route.definition CASCADE;
  TRUNCATE TABLE route.information CASCADE;
  TRUNCATE TABLE route.location CASCADE;
  TRUNCATE TABLE route.primal CASCADE;
  TRUNCATE TABLE route.segment CASCADE;
  /*
  SELECT 'ALTER SEQUENCE ' || sequence_schema || '.' || sequence_name || ' RESTART WITH 1;'
  FROM information_schema.sequences
  WHERE sequence_catalog = 'mes' AND sequence_schema != 'common'
  ORDER by sequence_schema, sequence_name;
  */
  ALTER SEQUENCE ebom.definition_id_seq RESTART WITH 1;
  ALTER SEQUENCE ebom.information_id_seq RESTART WITH 1;
  ALTER SEQUENCE mbom.definition_id_seq RESTART WITH 1;
  ALTER SEQUENCE mbom.information_id_seq RESTART WITH 1;
  ALTER SEQUENCE operation.definition_id_seq RESTART WITH 1;
  ALTER SEQUENCE operation.information_id_seq RESTART WITH 1;
  ALTER SEQUENCE operation.segment_id_seq RESTART WITH 1;
  ALTER SEQUENCE product.definition_id_seq RESTART WITH 1;
  ALTER SEQUENCE product.information_id_seq RESTART WITH 1;
  ALTER SEQUENCE product.segment_id_seq RESTART WITH 1;
  ALTER SEQUENCE route.definition_id_seq RESTART WITH 1;
  ALTER SEQUENCE route.information_id_seq RESTART WITH 1;
END;
$$;


ALTER FUNCTION tests._reset_data() OWNER TO postgres;

--
-- TOC entry 308 (class 1255 OID 56374)
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
-- TOC entry 309 (class 1255 OID 56376)
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
-- TOC entry 310 (class 1255 OID 56375)
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
    RETURN NULL;
  END IF;

END;
$$;


ALTER FUNCTION uom.get_factor(_uom_code_src character varying, _uom_code_dst character varying) OWNER TO postgres;

SET search_path = common, pg_catalog;

SET default_tablespace = '';

SET default_with_oids = false;

--
-- TOC entry 207 (class 1259 OID 56377)
-- Name: settings; Type: TABLE; Schema: common; Owner: postgres
--

CREATE TABLE settings (
    parameter_name character varying NOT NULL,
    parameter_value character varying
);


ALTER TABLE settings OWNER TO postgres;

SET search_path = equipment, pg_catalog;

--
-- TOC entry 208 (class 1259 OID 56383)
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
-- TOC entry 209 (class 1259 OID 56391)
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
-- TOC entry 3397 (class 0 OID 0)
-- Dependencies: 209
-- Name: information_id_seq; Type: SEQUENCE OWNED BY; Schema: equipment; Owner: postgres
--

ALTER SEQUENCE information_id_seq OWNED BY information.id;


SET search_path = facility, pg_catalog;

--
-- TOC entry 210 (class 1259 OID 56393)
-- Name: information; Type: TABLE; Schema: facility; Owner: postgres
--

CREATE TABLE information (
    id bigint NOT NULL,
    gid uuid DEFAULT public.uuid_generate_v1() NOT NULL,
    facility_code character varying NOT NULL,
    version_num integer NOT NULL,
    display_name character varying NOT NULL,
    published_date date DEFAULT now() NOT NULL
);


ALTER TABLE information OWNER TO postgres;

--
-- TOC entry 211 (class 1259 OID 56401)
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
-- TOC entry 3398 (class 0 OID 0)
-- Dependencies: 211
-- Name: information_id_seq; Type: SEQUENCE OWNED BY; Schema: facility; Owner: postgres
--

ALTER SEQUENCE information_id_seq OWNED BY information.id;


SET search_path = inventory, pg_catalog;

--
-- TOC entry 212 (class 1259 OID 56403)
-- Name: information; Type: TABLE; Schema: inventory; Owner: postgres
--

CREATE TABLE information (
    part_code character varying NOT NULL,
    version_num integer DEFAULT 1 NOT NULL,
    display_name character varying NOT NULL,
    published_date date DEFAULT now() NOT NULL,
    inventory_type common.inventory_kind NOT NULL
);


ALTER TABLE information OWNER TO postgres;

--
-- TOC entry 3399 (class 0 OID 0)
-- Dependencies: 212
-- Name: TABLE information; Type: COMMENT; Schema: inventory; Owner: postgres
--

COMMENT ON TABLE information IS 'inventory list';


--
-- TOC entry 213 (class 1259 OID 56411)
-- Name: salable; Type: TABLE; Schema: inventory; Owner: postgres
--

CREATE TABLE salable (
    CONSTRAINT salable_inventory_type_check CHECK ((inventory_type = 'SALABLE'::common.inventory_kind))
)
INHERITS (information);


ALTER TABLE salable OWNER TO postgres;

--
-- TOC entry 3400 (class 0 OID 0)
-- Dependencies: 213
-- Name: TABLE salable; Type: COMMENT; Schema: inventory; Owner: postgres
--

COMMENT ON TABLE salable IS 'inventory salable component';


--
-- TOC entry 214 (class 1259 OID 56420)
-- Name: storable; Type: TABLE; Schema: inventory; Owner: postgres
--

CREATE TABLE storable (
    part_code character varying NOT NULL,
    uom_base_code character varying
);


ALTER TABLE storable OWNER TO postgres;

SET search_path = measurement, pg_catalog;

--
-- TOC entry 215 (class 1259 OID 56426)
-- Name: information; Type: TABLE; Schema: measurement; Owner: postgres
--

CREATE TABLE information (
    part_code character varying NOT NULL,
    uom_code character varying NOT NULL,
    factor double precision,
    prev_end_date timestamp with time zone,
    start_date timestamp with time zone NOT NULL,
    end_date timestamp with time zone,
    uom_base_code character varying
);


ALTER TABLE information OWNER TO postgres;

SET search_path = personnel, pg_catalog;

--
-- TOC entry 216 (class 1259 OID 56432)
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
-- TOC entry 217 (class 1259 OID 56440)
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
-- TOC entry 3401 (class 0 OID 0)
-- Dependencies: 217
-- Name: information_id_seq; Type: SEQUENCE OWNED BY; Schema: personnel; Owner: postgres
--

ALTER SEQUENCE information_id_seq OWNED BY information.id;


SET search_path = schedule, pg_catalog;

--
-- TOC entry 218 (class 1259 OID 56442)
-- Name: calendar; Type: TABLE; Schema: schedule; Owner: postgres
--

CREATE TABLE calendar (
    calendar_date date NOT NULL,
    day_number integer,
    week_number integer,
    julianized_day integer,
    julianized_week integer
);


ALTER TABLE calendar OWNER TO postgres;

SET search_path = tests, pg_catalog;

--
-- TOC entry 219 (class 1259 OID 56445)
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
-- TOC entry 220 (class 1259 OID 56450)
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
-- TOC entry 221 (class 1259 OID 56455)
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
-- TOC entry 222 (class 1259 OID 56460)
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
-- TOC entry 223 (class 1259 OID 56468)
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
-- TOC entry 3402 (class 0 OID 0)
-- Dependencies: 223
-- Name: information_id_seq; Type: SEQUENCE OWNED BY; Schema: tooling; Owner: postgres
--

ALTER SEQUENCE information_id_seq OWNED BY information.id;


SET search_path = transactor, pg_catalog;

--
-- TOC entry 224 (class 1259 OID 56470)
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
-- TOC entry 225 (class 1259 OID 56478)
-- Name: customer; Type: TABLE; Schema: transactor; Owner: postgres
--

CREATE TABLE customer (
)
INHERITS (information);


ALTER TABLE customer OWNER TO postgres;

--
-- TOC entry 226 (class 1259 OID 56486)
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
-- TOC entry 3403 (class 0 OID 0)
-- Dependencies: 226
-- Name: information_id_seq; Type: SEQUENCE OWNED BY; Schema: transactor; Owner: postgres
--

ALTER SEQUENCE information_id_seq OWNED BY information.id;


--
-- TOC entry 227 (class 1259 OID 56488)
-- Name: supplier; Type: TABLE; Schema: transactor; Owner: postgres
--

CREATE TABLE supplier (
)
INHERITS (information);


ALTER TABLE supplier OWNER TO postgres;

SET search_path = uom, pg_catalog;

--
-- TOC entry 228 (class 1259 OID 56496)
-- Name: assignment; Type: TABLE; Schema: uom; Owner: postgres
--

CREATE TABLE assignment (
    uom_role_id bigint NOT NULL,
    uom_role_code character varying(100),
    uom_role_name character varying(300)
);


ALTER TABLE assignment OWNER TO postgres;

--
-- TOC entry 3404 (class 0 OID 0)
-- Dependencies: 228
-- Name: TABLE assignment; Type: COMMENT; Schema: uom; Owner: postgres
--

COMMENT ON TABLE assignment IS 'uom role';


--
-- TOC entry 229 (class 1259 OID 56499)
-- Name: information; Type: TABLE; Schema: uom; Owner: postgres
--

CREATE TABLE information (
    uom_code character varying(4) NOT NULL,
    uom_domain character varying(10),
    base_uom_code character varying,
    factor double precision
);


ALTER TABLE information OWNER TO postgres;

--
-- TOC entry 230 (class 1259 OID 56505)
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
-- TOC entry 3405 (class 0 OID 0)
-- Dependencies: 230
-- Name: uom_role_uom_role_id_seq; Type: SEQUENCE OWNED BY; Schema: uom; Owner: postgres
--

ALTER SEQUENCE uom_role_uom_role_id_seq OWNED BY assignment.uom_role_id;


SET search_path = equipment, pg_catalog;

--
-- TOC entry 3162 (class 2604 OID 56507)
-- Name: information id; Type: DEFAULT; Schema: equipment; Owner: postgres
--

ALTER TABLE ONLY information ALTER COLUMN id SET DEFAULT nextval('information_id_seq'::regclass);


SET search_path = facility, pg_catalog;

--
-- TOC entry 3165 (class 2604 OID 56508)
-- Name: information id; Type: DEFAULT; Schema: facility; Owner: postgres
--

ALTER TABLE ONLY information ALTER COLUMN id SET DEFAULT nextval('information_id_seq'::regclass);


SET search_path = inventory, pg_catalog;

--
-- TOC entry 3168 (class 2604 OID 56509)
-- Name: salable version_num; Type: DEFAULT; Schema: inventory; Owner: postgres
--

ALTER TABLE ONLY salable ALTER COLUMN version_num SET DEFAULT 1;


--
-- TOC entry 3169 (class 2604 OID 56510)
-- Name: salable published_date; Type: DEFAULT; Schema: inventory; Owner: postgres
--

ALTER TABLE ONLY salable ALTER COLUMN published_date SET DEFAULT now();


SET search_path = personnel, pg_catalog;

--
-- TOC entry 3173 (class 2604 OID 56511)
-- Name: information id; Type: DEFAULT; Schema: personnel; Owner: postgres
--

ALTER TABLE ONLY information ALTER COLUMN id SET DEFAULT nextval('information_id_seq'::regclass);


SET search_path = tooling, pg_catalog;

--
-- TOC entry 3176 (class 2604 OID 56512)
-- Name: information id; Type: DEFAULT; Schema: tooling; Owner: postgres
--

ALTER TABLE ONLY information ALTER COLUMN id SET DEFAULT nextval('information_id_seq'::regclass);


SET search_path = transactor, pg_catalog;

--
-- TOC entry 3180 (class 2604 OID 56513)
-- Name: customer id; Type: DEFAULT; Schema: transactor; Owner: postgres
--

ALTER TABLE ONLY customer ALTER COLUMN id SET DEFAULT nextval('information_id_seq'::regclass);


--
-- TOC entry 3181 (class 2604 OID 56514)
-- Name: customer gid; Type: DEFAULT; Schema: transactor; Owner: postgres
--

ALTER TABLE ONLY customer ALTER COLUMN gid SET DEFAULT public.uuid_generate_v1();


--
-- TOC entry 3182 (class 2604 OID 56515)
-- Name: customer published_date; Type: DEFAULT; Schema: transactor; Owner: postgres
--

ALTER TABLE ONLY customer ALTER COLUMN published_date SET DEFAULT now();


--
-- TOC entry 3179 (class 2604 OID 56516)
-- Name: information id; Type: DEFAULT; Schema: transactor; Owner: postgres
--

ALTER TABLE ONLY information ALTER COLUMN id SET DEFAULT nextval('information_id_seq'::regclass);


--
-- TOC entry 3183 (class 2604 OID 56517)
-- Name: supplier id; Type: DEFAULT; Schema: transactor; Owner: postgres
--

ALTER TABLE ONLY supplier ALTER COLUMN id SET DEFAULT nextval('information_id_seq'::regclass);


--
-- TOC entry 3184 (class 2604 OID 56518)
-- Name: supplier gid; Type: DEFAULT; Schema: transactor; Owner: postgres
--

ALTER TABLE ONLY supplier ALTER COLUMN gid SET DEFAULT public.uuid_generate_v1();


--
-- TOC entry 3185 (class 2604 OID 56519)
-- Name: supplier published_date; Type: DEFAULT; Schema: transactor; Owner: postgres
--

ALTER TABLE ONLY supplier ALTER COLUMN published_date SET DEFAULT now();


SET search_path = uom, pg_catalog;

--
-- TOC entry 3186 (class 2604 OID 56520)
-- Name: assignment uom_role_id; Type: DEFAULT; Schema: uom; Owner: postgres
--

ALTER TABLE ONLY assignment ALTER COLUMN uom_role_id SET DEFAULT nextval('uom_role_uom_role_id_seq'::regclass);


SET search_path = common, pg_catalog;

--
-- TOC entry 3360 (class 0 OID 56377)
-- Dependencies: 207
-- Data for Name: settings; Type: TABLE DATA; Schema: common; Owner: postgres
--

INSERT INTO settings VALUES ('measurement_apply_latency', '2');


SET search_path = equipment, pg_catalog;

--
-- TOC entry 3361 (class 0 OID 56383)
-- Dependencies: 208
-- Data for Name: information; Type: TABLE DATA; Schema: equipment; Owner: postgres
--



--
-- TOC entry 3406 (class 0 OID 0)
-- Dependencies: 209
-- Name: information_id_seq; Type: SEQUENCE SET; Schema: equipment; Owner: postgres
--

SELECT pg_catalog.setval('information_id_seq', 1, false);


SET search_path = facility, pg_catalog;

--
-- TOC entry 3363 (class 0 OID 56393)
-- Dependencies: 210
-- Data for Name: information; Type: TABLE DATA; Schema: facility; Owner: postgres
--



--
-- TOC entry 3407 (class 0 OID 0)
-- Dependencies: 211
-- Name: information_id_seq; Type: SEQUENCE SET; Schema: facility; Owner: postgres
--

SELECT pg_catalog.setval('information_id_seq', 1, false);


SET search_path = inventory, pg_catalog;

--
-- TOC entry 3365 (class 0 OID 56403)
-- Dependencies: 212
-- Data for Name: information; Type: TABLE DATA; Schema: inventory; Owner: postgres
--



--
-- TOC entry 3366 (class 0 OID 56411)
-- Dependencies: 213
-- Data for Name: salable; Type: TABLE DATA; Schema: inventory; Owner: postgres
--



--
-- TOC entry 3367 (class 0 OID 56420)
-- Dependencies: 214
-- Data for Name: storable; Type: TABLE DATA; Schema: inventory; Owner: postgres
--

INSERT INTO storable VALUES ('21.16.100-001', 'pcs');
INSERT INTO storable VALUES ('10.01.057-003', 'm');
INSERT INTO storable VALUES ('10.01.076-003', 'm');
INSERT INTO storable VALUES ('10.01.089-003', 'm');
INSERT INTO storable VALUES ('20.10.125-001', 'pcs');


SET search_path = measurement, pg_catalog;

--
-- TOC entry 3368 (class 0 OID 56426)
-- Dependencies: 215
-- Data for Name: information; Type: TABLE DATA; Schema: measurement; Owner: postgres
--

INSERT INTO information VALUES ('10.01.076-003', 'm', 1, '2016-11-07 12:32:17.398418+02', '2016-11-07 12:32:17.398418+02', '2016-11-07 12:40:30.717177+02', 'm');
INSERT INTO information VALUES ('10.01.076-003', 'm', 1, '2016-11-07 12:40:30.717177+02', '2016-11-07 12:40:30.717177+02', '2016-11-07 12:55:18.340065+02', 'm');
INSERT INTO information VALUES ('10.01.076-003', 'm', 1, '2016-11-07 12:55:18.340065+02', '2016-11-07 12:55:18.340065+02', NULL, 'm');
INSERT INTO information VALUES ('10.01.076-003', 'm', 1, '2016-11-01 12:31:52.661312+02', '2016-11-01 12:31:52.661312+02', '2016-11-07 12:32:15.337573+02', 'm');
INSERT INTO information VALUES ('10.01.076-003', 't', 0.00250000000000000005, '2016-11-07 12:55:18.340065+02', '2016-11-07 12:55:18.340065+02', NULL, 'm');
INSERT INTO information VALUES ('10.01.076-003', 'kg', 2.5, '2016-11-07 12:55:18.340065+02', '2016-11-07 12:55:18.340065+02', NULL, 'm');
INSERT INTO information VALUES ('10.01.076-003', 'l', 0.330000000000000016, '2016-11-05 00:00:00+02', '2016-11-05 00:00:00+02', NULL, 'm');


SET search_path = personnel, pg_catalog;

--
-- TOC entry 3369 (class 0 OID 56432)
-- Dependencies: 216
-- Data for Name: information; Type: TABLE DATA; Schema: personnel; Owner: postgres
--



--
-- TOC entry 3408 (class 0 OID 0)
-- Dependencies: 217
-- Name: information_id_seq; Type: SEQUENCE SET; Schema: personnel; Owner: postgres
--

SELECT pg_catalog.setval('information_id_seq', 1, false);


SET search_path = schedule, pg_catalog;

--
-- TOC entry 3371 (class 0 OID 56442)
-- Dependencies: 218
-- Data for Name: calendar; Type: TABLE DATA; Schema: schedule; Owner: postgres
--



SET search_path = tooling, pg_catalog;

--
-- TOC entry 3372 (class 0 OID 56460)
-- Dependencies: 222
-- Data for Name: information; Type: TABLE DATA; Schema: tooling; Owner: postgres
--



--
-- TOC entry 3409 (class 0 OID 0)
-- Dependencies: 223
-- Name: information_id_seq; Type: SEQUENCE SET; Schema: tooling; Owner: postgres
--

SELECT pg_catalog.setval('information_id_seq', 1, false);


SET search_path = transactor, pg_catalog;

--
-- TOC entry 3375 (class 0 OID 56478)
-- Dependencies: 225
-- Data for Name: customer; Type: TABLE DATA; Schema: transactor; Owner: postgres
--



--
-- TOC entry 3374 (class 0 OID 56470)
-- Dependencies: 224
-- Data for Name: information; Type: TABLE DATA; Schema: transactor; Owner: postgres
--



--
-- TOC entry 3410 (class 0 OID 0)
-- Dependencies: 226
-- Name: information_id_seq; Type: SEQUENCE SET; Schema: transactor; Owner: postgres
--

SELECT pg_catalog.setval('information_id_seq', 1, false);


--
-- TOC entry 3377 (class 0 OID 56488)
-- Dependencies: 227
-- Data for Name: supplier; Type: TABLE DATA; Schema: transactor; Owner: postgres
--



SET search_path = uom, pg_catalog;

--
-- TOC entry 3378 (class 0 OID 56496)
-- Dependencies: 228
-- Data for Name: assignment; Type: TABLE DATA; Schema: uom; Owner: postgres
--



--
-- TOC entry 3379 (class 0 OID 56499)
-- Dependencies: 229
-- Data for Name: information; Type: TABLE DATA; Schema: uom; Owner: postgres
--

INSERT INTO information VALUES ('kg', 'MASS', 'kg', 1);
INSERT INTO information VALUES ('m', 'LENGHT', 'm', 1);
INSERT INTO information VALUES ('pcs', 'QUANTITY', 'pcs', 1);
INSERT INTO information VALUES ('g', 'MASS', 'kg', 0.00100000000000000002);
INSERT INTO information VALUES ('t', 'MASS', 'kg', 1000);
INSERT INTO information VALUES ('mm', 'LENGHT', 'm', 0.00100000000000000002);
INSERT INTO information VALUES ('km', 'LENGHT', 'm', 1000);
INSERT INTO information VALUES ('cm', 'LENGHT', 'm', 0.0100000000000000002);
INSERT INTO information VALUES ('l', 'VOLUME', 'l', 1);
INSERT INTO information VALUES ('ml', 'VOLUME', 'l', 0.00100000000000000002);


--
-- TOC entry 3411 (class 0 OID 0)
-- Dependencies: 230
-- Name: uom_role_uom_role_id_seq; Type: SEQUENCE SET; Schema: uom; Owner: postgres
--

SELECT pg_catalog.setval('uom_role_uom_role_id_seq', 1, false);


SET search_path = common, pg_catalog;

--
-- TOC entry 3188 (class 2606 OID 56522)
-- Name: settings wms_settings_pkey; Type: CONSTRAINT; Schema: common; Owner: postgres
--

ALTER TABLE ONLY settings
    ADD CONSTRAINT wms_settings_pkey PRIMARY KEY (parameter_name);


SET search_path = equipment, pg_catalog;

--
-- TOC entry 3190 (class 2606 OID 56524)
-- Name: information information_equipment_code_version_num_key; Type: CONSTRAINT; Schema: equipment; Owner: postgres
--

ALTER TABLE ONLY information
    ADD CONSTRAINT information_equipment_code_version_num_key UNIQUE (equipment_code, version_num);


--
-- TOC entry 3192 (class 2606 OID 56526)
-- Name: information information_gid_key; Type: CONSTRAINT; Schema: equipment; Owner: postgres
--

ALTER TABLE ONLY information
    ADD CONSTRAINT information_gid_key UNIQUE (gid);


--
-- TOC entry 3194 (class 2606 OID 56528)
-- Name: information information_pkey; Type: CONSTRAINT; Schema: equipment; Owner: postgres
--

ALTER TABLE ONLY information
    ADD CONSTRAINT information_pkey PRIMARY KEY (id);


SET search_path = facility, pg_catalog;

--
-- TOC entry 3196 (class 2606 OID 56530)
-- Name: information information_facility_code_version_num_key; Type: CONSTRAINT; Schema: facility; Owner: postgres
--

ALTER TABLE ONLY information
    ADD CONSTRAINT information_facility_code_version_num_key UNIQUE (facility_code, version_num);


--
-- TOC entry 3198 (class 2606 OID 56532)
-- Name: information information_gid_key; Type: CONSTRAINT; Schema: facility; Owner: postgres
--

ALTER TABLE ONLY information
    ADD CONSTRAINT information_gid_key UNIQUE (gid);


--
-- TOC entry 3200 (class 2606 OID 56534)
-- Name: information information_pkey; Type: CONSTRAINT; Schema: facility; Owner: postgres
--

ALTER TABLE ONLY information
    ADD CONSTRAINT information_pkey PRIMARY KEY (id);


SET search_path = inventory, pg_catalog;

--
-- TOC entry 3202 (class 2606 OID 56536)
-- Name: information information_pkey; Type: CONSTRAINT; Schema: inventory; Owner: postgres
--

ALTER TABLE ONLY information
    ADD CONSTRAINT information_pkey PRIMARY KEY (part_code, version_num, inventory_type);


--
-- TOC entry 3204 (class 2606 OID 56538)
-- Name: salable salable_pkey; Type: CONSTRAINT; Schema: inventory; Owner: postgres
--

ALTER TABLE ONLY salable
    ADD CONSTRAINT salable_pkey PRIMARY KEY (part_code, version_num);


--
-- TOC entry 3206 (class 2606 OID 56540)
-- Name: storable storable_pkey; Type: CONSTRAINT; Schema: inventory; Owner: postgres
--

ALTER TABLE ONLY storable
    ADD CONSTRAINT storable_pkey PRIMARY KEY (part_code);


SET search_path = measurement, pg_catalog;

--
-- TOC entry 3208 (class 2606 OID 56542)
-- Name: information measurement_pkey; Type: CONSTRAINT; Schema: measurement; Owner: postgres
--

ALTER TABLE ONLY information
    ADD CONSTRAINT measurement_pkey PRIMARY KEY (part_code, uom_code, start_date);


SET search_path = personnel, pg_catalog;

--
-- TOC entry 3210 (class 2606 OID 56544)
-- Name: information information_gid_key; Type: CONSTRAINT; Schema: personnel; Owner: postgres
--

ALTER TABLE ONLY information
    ADD CONSTRAINT information_gid_key UNIQUE (gid);


--
-- TOC entry 3212 (class 2606 OID 56546)
-- Name: information information_personnel_code_version_num_key; Type: CONSTRAINT; Schema: personnel; Owner: postgres
--

ALTER TABLE ONLY information
    ADD CONSTRAINT information_personnel_code_version_num_key UNIQUE (personnel_code, version_num);


--
-- TOC entry 3214 (class 2606 OID 56548)
-- Name: information information_pkey; Type: CONSTRAINT; Schema: personnel; Owner: postgres
--

ALTER TABLE ONLY information
    ADD CONSTRAINT information_pkey PRIMARY KEY (id);


SET search_path = schedule, pg_catalog;

--
-- TOC entry 3216 (class 2606 OID 56550)
-- Name: calendar calendar_pkey; Type: CONSTRAINT; Schema: schedule; Owner: postgres
--

ALTER TABLE ONLY calendar
    ADD CONSTRAINT calendar_pkey PRIMARY KEY (calendar_date);


SET search_path = tooling, pg_catalog;

--
-- TOC entry 3218 (class 2606 OID 56552)
-- Name: information information_gid_key; Type: CONSTRAINT; Schema: tooling; Owner: postgres
--

ALTER TABLE ONLY information
    ADD CONSTRAINT information_gid_key UNIQUE (gid);


--
-- TOC entry 3220 (class 2606 OID 56554)
-- Name: information information_pkey; Type: CONSTRAINT; Schema: tooling; Owner: postgres
--

ALTER TABLE ONLY information
    ADD CONSTRAINT information_pkey PRIMARY KEY (id);


--
-- TOC entry 3222 (class 2606 OID 56556)
-- Name: information information_tooling_code_version_num_key; Type: CONSTRAINT; Schema: tooling; Owner: postgres
--

ALTER TABLE ONLY information
    ADD CONSTRAINT information_tooling_code_version_num_key UNIQUE (tooling_code, version_num);


SET search_path = transactor, pg_catalog;

--
-- TOC entry 3224 (class 2606 OID 56558)
-- Name: information information_gid_key; Type: CONSTRAINT; Schema: transactor; Owner: postgres
--

ALTER TABLE ONLY information
    ADD CONSTRAINT information_gid_key UNIQUE (gid);


--
-- TOC entry 3226 (class 2606 OID 56560)
-- Name: information information_pkey; Type: CONSTRAINT; Schema: transactor; Owner: postgres
--

ALTER TABLE ONLY information
    ADD CONSTRAINT information_pkey PRIMARY KEY (id);


--
-- TOC entry 3228 (class 2606 OID 56562)
-- Name: information information_transactor_code_version_num_key; Type: CONSTRAINT; Schema: transactor; Owner: postgres
--

ALTER TABLE ONLY information
    ADD CONSTRAINT information_transactor_code_version_num_key UNIQUE (transactor_code, version_num);


SET search_path = uom, pg_catalog;

--
-- TOC entry 3234 (class 2606 OID 56564)
-- Name: information uom_pkey; Type: CONSTRAINT; Schema: uom; Owner: postgres
--

ALTER TABLE ONLY information
    ADD CONSTRAINT uom_pkey PRIMARY KEY (uom_code);


--
-- TOC entry 3230 (class 2606 OID 56566)
-- Name: assignment uom_role_pkey; Type: CONSTRAINT; Schema: uom; Owner: postgres
--

ALTER TABLE ONLY assignment
    ADD CONSTRAINT uom_role_pkey PRIMARY KEY (uom_role_id);


--
-- TOC entry 3232 (class 2606 OID 56568)
-- Name: assignment uom_role_uom_role_code_key; Type: CONSTRAINT; Schema: uom; Owner: postgres
--

ALTER TABLE ONLY assignment
    ADD CONSTRAINT uom_role_uom_role_code_key UNIQUE (uom_role_code);


SET search_path = inventory, pg_catalog;

--
-- TOC entry 3235 (class 2606 OID 56569)
-- Name: storable storable_uom_base_code_fkey; Type: FK CONSTRAINT; Schema: inventory; Owner: postgres
--

ALTER TABLE ONLY storable
    ADD CONSTRAINT storable_uom_base_code_fkey FOREIGN KEY (uom_base_code) REFERENCES uom.information(uom_code);


SET search_path = measurement, pg_catalog;

--
-- TOC entry 3236 (class 2606 OID 56574)
-- Name: information measurement_part_code_fkey; Type: FK CONSTRAINT; Schema: measurement; Owner: postgres
--

ALTER TABLE ONLY information
    ADD CONSTRAINT measurement_part_code_fkey FOREIGN KEY (part_code) REFERENCES inventory.storable(part_code);


--
-- TOC entry 3237 (class 2606 OID 56579)
-- Name: information measurement_uom_base_code_fkey; Type: FK CONSTRAINT; Schema: measurement; Owner: postgres
--

ALTER TABLE ONLY information
    ADD CONSTRAINT measurement_uom_base_code_fkey FOREIGN KEY (uom_base_code) REFERENCES uom.information(uom_code);


--
-- TOC entry 3238 (class 2606 OID 56584)
-- Name: information measurement_uom_code_fkey; Type: FK CONSTRAINT; Schema: measurement; Owner: postgres
--

ALTER TABLE ONLY information
    ADD CONSTRAINT measurement_uom_code_fkey FOREIGN KEY (uom_code) REFERENCES uom.information(uom_code);


SET search_path = uom, pg_catalog;

--
-- TOC entry 3239 (class 2606 OID 56589)
-- Name: information uom_base_uom_code_fkey; Type: FK CONSTRAINT; Schema: uom; Owner: postgres
--

ALTER TABLE ONLY information
    ADD CONSTRAINT uom_base_uom_code_fkey FOREIGN KEY (base_uom_code) REFERENCES information(uom_code);


-- Completed on 2018-01-15 04:56:53 EET

--
-- PostgreSQL database dump complete
--

