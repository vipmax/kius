-- добавление параметра в список параметров 
CREATE OR REPLACE FUNCTION add_parameter(_parameter_name TEXT, _description TEXT, _unit_id INTEGER, _enum_id INTEGER, _parameter_type_id INTEGER)
  RETURNS VOID
AS
  $BODY$
  BEGIN
    INSERT INTO parameters (name, description, unit_id, enum_id, parameter_type_id)
    VALUES (_parameter_name, _description, _unit_id, _enum_id, _parameter_type_id);
  END;
  $BODY$
LANGUAGE plpgsql VOLATILE;

-- удаление параметра (каскадное удаление)	
CREATE OR REPLACE FUNCTION delete_parameter(_parameter_id INTEGER)
  RETURNS VOID
AS
  $BODY$
  BEGIN
    DELETE
    FROM parameters ps
    WHERE ps.id = _parameter_id;
  END;
  $BODY$
LANGUAGE plpgsql VOLATILE;

-- изменение параметра (каскадное изменение)
CREATE OR REPLACE FUNCTION change_parameter(_parameter_id       INTEGER,
                                            _new_parameter_id   INTEGER,
                                            _new_parameter_name TEXT,
                                            _new_description    TEXT,
                                            _new_unit_id        INTEGER,
                                            _new_enum_id        INTEGER,
                                            _parameter_type_id INTEGER)
  RETURNS VOID AS $$
BEGIN
  UPDATE parameters
  SET
    id              = _new_parameter_id,
    name              = _new_parameter_name,
    description       = _new_description,
    unit_id           = _new_unit_id,
    enum_id           = _new_enum_id,
    parameter_type_id = _parameter_type_id
  WHERE id = _parameter_id;
END;
$$ LANGUAGE plpgsql;

-- добавление соответствия типа продукта и его параметра
CREATE OR REPLACE FUNCTION add_product_parameters_mapping(_new_product_id INTEGER, _new_parameter_id INTEGER,_enum_val_id INTEGER, _unit_val INTEGER)
  RETURNS VOID AS $$
BEGIN
  INSERT INTO product_parameters_mapping
  (product_id, parameter_id, enum_val_id, unit_val)
  VALUES (_new_product_id, _new_parameter_id, _enum_val_id, _unit_val);
END;
$$ LANGUAGE plpgsql;

-- удаление соответствия типа продукта и его параметра
CREATE OR REPLACE FUNCTION delete_product_parameters_mapping(_product_id INTEGER, _parameter_id INTEGER)
  RETURNS VOID AS $$
BEGIN
  DELETE
  FROM product_types_parameters_mapping
  WHERE product_id = _product_id AND parameter_id = _parameter_id;
END;
$$ LANGUAGE plpgsql;


-- изменение соответствия типа продукта и его параметра
CREATE OR REPLACE FUNCTION change_product_parameters_mapping
  (_product_id INTEGER, _new_parameter_id INTEGER)
  RETURNS VOID AS $$
BEGIN
  UPDATE product_parameters_mapping
  SET parameter_id = _new_parameter_id
  WHERE id = _product_id;
END;
$$ LANGUAGE plpgsql;


-- отбор параметров по id  класса (product_type_id)

CREATE OR REPLACE FUNCTION select_parameters_by_product_id(_product_id INTEGER)
  RETURNS TABLE(id INTEGER, name TEXT, description TEXT, unit_id INTEGER, unit_val INTEGER, enum_id INTEGER, enum_val_id INTEGER, parameter_type_id INTEGER) AS
  $$
  BEGIN
    RETURN QUERY
    SELECT
      p.id,
      p.name,
      p.description,
      p.unit_id,
      m.unit_val,
      p.enum_id,
      m.enum_val_id,
      p.parameter_type_id
    FROM product_parameters_mapping m
      JOIN parameters p ON p.id = m.parameter_id
    WHERE m.product_id = _product_id;
  END;
  $$ LANGUAGE plpgsql;


-- вывод списка изделий заданного класса с параметрами;  
CREATE OR REPLACE FUNCTION select_products_with_parameters_by_product_type(_product_id INTEGER)
  RETURNS TABLE(product_id INTEGER, product_name TEXT, product_code INTEGER, parameter_id INTEGER, parameter_name TEXT, parameter_description TEXT,
  parameter_unit_id INTEGER,parameter_unit_value INTEGER, parameter_enum_id INTEGER, parameter_enum_id_value INTEGER, parameter_type INTEGER) AS
  $$
  BEGIN
    RETURN QUERY
    SELECT
      p.id,
      p.name,
      p.code,
      pr.id,
      pr.name,
      pr.description,
      pr.unit_id, m.unit_val,
      pr.enum_id, m.enum_val_id,
      pr.parameter_type_id
    FROM products p
      FULL JOIN product_parameters_mapping m ON m.product_id = p.id
      FULL JOIN parameters pr ON pr.id = m.parameter_id
    WHERE p.product_id = _product_id;
  END;
  $$ LANGUAGE plpgsql;
