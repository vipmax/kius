CREATE TABLE units
(
  id          SERIAL,
  name        TEXT UNIQUE,
  description TEXT
);

CREATE TABLE product_types
(
  id               SERIAL,
  name             TEXT UNIQUE,
  unit_id          INTEGER,
  parent_id        INTEGER,
  popularity_value INTEGER
);

CREATE TABLE products
(
  id              SERIAL,
  name            TEXT UNIQUE,
  code            INTEGER UNIQUE,
  product_type_id INTEGER
);

CREATE TABLE enums
(
  enum_id   SERIAL,
  enum_name VARCHAR(255) NOT NULL
);

CREATE TABLE enum_values
(
  enum_val_id    SERIAL,
  enum_id        INTEGER      NOT NULL,
  enum_val_value INTEGER,
  enum_val_name  VARCHAR(255) NOT NULL,
  enum_val_order INTEGER      NOT NULL
);

CREATE TABLE parameters
(
  id                SERIAL,
  name              TEXT,
  description       TEXT,
  unit_id           INTEGER,
  enum_id           INTEGER,
  parameter_type_id INTEGER
);

--таблица с соответствием продуктов и их параметров
CREATE TABLE products_parameters_mapping
(
  product_id   INTEGER,
  parameter_id INTEGER,
  enum_val_id  INTEGER,
  unit_val     INTEGER
);

--таблица с соответствием типов продуктов и их параметров
CREATE TABLE product_types_parameters_mapping
(
  product_type_id INTEGER,
  parameter_id    INTEGER,

  max_value       INTEGER,
  min_value       INTEGER
);

CREATE TABLE parameter_types
(
  id   INTEGER UNIQUE,
  name TEXT
);







