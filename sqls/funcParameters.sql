-- добавление параметра в список параметров
CREATE OR REPLACE FUNCTION add_parameter (_parameter_name text, _description text, _unit_id int4)
  RETURNS void
AS
  $BODY$
  BEGIN
  INSERT INTO parameters (name,description,unit_id) VALUES (_parameter_name,_description,_unit_id);
END;
$BODY$
LANGUAGE plpgsql VOLATILE;

select add_parameter('screen size','screen size',3);

-- удаление параметра из списока параметров
CREATE OR REPLACE FUNCTION delete_parameter (_parameter_id INTEGER )
  RETURNS void
AS
  $BODY$
  BEGIN
  DELETE
  from parameters ps
  WHERE ps.id = _parameter_id;
END;
$BODY$
LANGUAGE plpgsql VOLATILE;

select delete_parameter(3);

-- изменение параметра в списоке параметров
CREATE OR REPLACE FUNCTION change_parameter(_parameter_id       INTEGER,
                                            _new_parameter_name TEXT,
                                            _new_description    TEXT,
                                            _new_unit_id        INTEGER)
  RETURNS VOID AS $$
BEGIN
  UPDATE parameters
  SET name = _new_parameter_name,  description = _new_description,  unit_id = _new_unit_id
  WHERE id = _parameter_id;
END;
$$ LANGUAGE plpgsql;

-- добавление соответствия типа продукта и его параметра
CREATE OR REPLACE FUNCTION  add_product_types_parameters_mapping(_new_product_type_id INTEGER,_new_parameter_id INTEGER )
  RETURNS VOID AS $$
BEGIN
  INSERT into product_types_parameters_mapping
  (product_type_id, parameter_id)
  VALUES (_new_product_type_id, _new_parameter_id);
END;
$$ LANGUAGE plpgsql;


select add_product_types_parameters_mapping(1,1);
select add_product_types_parameters_mapping(2,2);

-- удаление --..--
CREATE OR REPLACE FUNCTION  delete_product_types_parameters_mapping(_product_type_id INTEGER )
  RETURNS VOID AS $$
BEGIN
  DELETE
  from product_types_parameters_mapping
  WHERE parameter_id = _product_type_id;
END;
$$ LANGUAGE plpgsql;

-- select delete_product_types_parameters_mapping(2);

--изменение --..--
CREATE OR REPLACE FUNCTION  change_product_types_parameters_mapping(_product_type_id INTEGER,_new_parameter_id INTEGER )
  RETURNS VOID AS $$
BEGIN
  UPDATE product_types_parameters_mapping
  SET parameter_id = _new_parameter_id
  WHERE id = _parameter_id;
END;
$$ LANGUAGE plpgsql;

-- select change_parameter(1,'cpu util','dscpt',12);

--отбор параметров по id  класса (product_type_id)
CREATE OR REPLACE FUNCTION select_parameters_by_product_id(_product_type_id INTEGER)
  RETURNS TABLE(id INTEGER , name TEXT, description TEXT, unit_id INTEGER) AS
  $$
  BEGIN
    RETURN QUERY
    SELECT p.id,p.name,p.description,p.unit_id
    FROM
    product_types_parameters_mapping ptpm
    JOIN parameters p on p.id = ptpm.parameter_id
    WHERE ptpm.product_type_id = _product_type_id;
  END;
  $$ LANGUAGE plpgsql;

-- SELECT  select_parameters_by_product_id(1);

-- вывод списка изделий заданного класса с параметрами;

CREATE OR REPLACE FUNCTION select_products_with_parameters_by_product_type(_product_type_id INTEGER)
  RETURNS TABLE(product_id INTEGER, product_name TEXT, product_code INTEGER,
                parameter_id INTEGER, parameter_name TEXT, parameter_description TEXT, parameter_unit_id INTEGER) AS
  $$
  BEGIN
    RETURN QUERY
    SELECT
      p.id,p.name,p.code,
      ps.id,ps.name,ps.description,ps.unit_id
    FROM products p
      FULL JOIN product_types_parameters_mapping m ON m.product_type_id = p.product_type_id
      FULL JOIN parameters ps ON ps.id = m.parameter_id
    WHERE p.product_type_id = _product_type_id;
  END;
  $$ LANGUAGE plpgsql;


-- SELECT  select_products_with_parameters_by_product_type(1);
-- SELECT  select_products_with_parameters_by_product_type(2);