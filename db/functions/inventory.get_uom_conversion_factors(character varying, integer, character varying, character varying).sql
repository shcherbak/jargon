-- Function: inventory.get_uom_conversion_factors(character varying, integer, character varying, character varying)

-- DROP FUNCTION inventory.get_uom_conversion_factors(character varying, integer, character varying, character varying);

CREATE OR REPLACE FUNCTION inventory.get_uom_conversion_factors(
    _part_code character varying,
    _version_num integer,
    _uom_domain_from character varying,
    _uom_domain_to character varying)
  RETURNS common.unit_conversion_type[] AS
$BODY$
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
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;
ALTER FUNCTION inventory.get_uom_conversion_factors(character varying, integer, character varying, character varying)
  OWNER TO postgres;
