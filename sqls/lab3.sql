CREATE TABLE units
(
  id                SERIAL,
  name              TEXT,
  description       TEXT,
--   PRIMARY KEY (id),
  CONSTRAINT name_key UNIQUE (name)
);

CREATE TABLE product_types
(
  id               SERIAL,
  name             TEXT,
  unit_id          INTEGER,
  parent_id        INTEGER,
  popularity_value INTEGER
  ,
--   PRIMARY KEY (id),
  CONSTRAINT product_type_name_key UNIQUE (name)
--   FOREIGN KEY (unit_id) REFERENCES units (id),
--   FOREIGN KEY (parent_id) REFERENCES product_types (id) ON UPDATE CASCADE ON DELETE SET NULL
);

CREATE TABLE products
(
  id                SERIAL,
  name              TEXT,
  code              INTEGER,
  product_type_id   INTEGER
  ,
--   PRIMARY KEY (id),
  CONSTRAINT name_product_key UNIQUE (name),
  CONSTRAINT code_key UNIQUE (code)
--   FOREIGN KEY (product_type_id) REFERENCES product_types (id)
);


-- SELECT  * FROM units;
-- SELECT  * FROM floor_coverings;
-- SELECT  * FROM products;
-- 
-- SELECT
--   p.*,
--   f.*,
--   u.*
-- FROM products p
-- JOIN floor_coverings f ON p.floor_covering_id = f.id
-- JOIN units u ON f.unit_id = u.id;
-- 
-- 
-- SELECT
--   *
-- FROM enum e
-- JOIN enum_val ev ON ev.enum_id = e.enum_id;

CREATE TABLE enums
(
  enum_id   SERIAL,
  enum_name VARCHAR(255) NOT NULL
--   PRIMARY KEY (enum_id)
);

CREATE TABLE enum_values
(
  enum_val_id    SERIAL,
  enum_id        INTEGER      NOT NULL,
  enum_val_value INTEGER,
  enum_val_name  VARCHAR(255) NOT NULL,
  enum_val_order INTEGER      NOT NULL
--   PRIMARY KEY (enum_val_id),
--   FOREIGN KEY (enum_id) REFERENCES enums (enum_id)
);

CREATE TABLE parameters
(
  id          SERIAL,
  name        TEXT,
  description TEXT,
  unit_id     INTEGER
--   enum_id  int  ??
  
--   FOREIGN KEY (unit_id) REFERENCES units (id)
--   FOREIGN KEY (enum_id) REFERENCES enums (id)
);

--таблица с соответствием продуктов и их параметров
CREATE TABLE products_parameters_mapping
(
  product_id   INTEGER,
  parameter_id INTEGER

--   FOREIGN KEY (product_id) REFERENCES products (id),
--   FOREIGN KEY (parameter_id) REFERENCES parameters (id)

);

--таблица с соответствием типов продуктов и их параметров
CREATE TABLE product_types_parameters_mapping
(
  product_type_id INTEGER,
  parameter_id    INTEGER
-- добавить ключи
--   FOREIGN KEY (product_type_id) REFERENCES products (id),
--   FOREIGN KEY (parameter_id) REFERENCES parameters (id)
);

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

CREATE OR REPLACE FUNCTION  change_parameter(_parameter_id       INTEGER,
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

select delete_product_types_parameters_mapping(2);

--изменение --..--
CREATE OR REPLACE FUNCTION  change_product_types_parameters_mapping(_product_type_id INTEGER,_new_parameter_id INTEGER )
  RETURNS VOID AS $$
BEGIN
  UPDATE product_types_parameters_mapping 
  SET parameter_id = _new_parameter_id
  WHERE id = _parameter_id;
END;
$$ LANGUAGE plpgsql;

select change_parameter(1,'cpu util','dscpt',12);

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

SELECT  select_parameters_by_product_id(1);

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


SELECT  select_products_with_parameters_by_product_type(1);
SELECT  select_products_with_parameters_by_product_type(2);


  


  
 
