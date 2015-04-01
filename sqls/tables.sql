CREATE TABLE units
(
  id                SERIAL,
  name              TEXT,
  description       TEXT,
  CONSTRAINT name_key UNIQUE (name)
);

CREATE TABLE product_types
(
  id               SERIAL,
  name             TEXT,
  unit_id          INTEGER,
  parent_id        INTEGER,
  popularity_value INTEGER,
  CONSTRAINT product_type_name_key UNIQUE (name)
);

CREATE TABLE products
(
  id                SERIAL,
  name              TEXT,
  code              INTEGER,
  product_type_id   INTEGER,
  CONSTRAINT name_product_key UNIQUE (name),
  CONSTRAINT code_key UNIQUE (code)
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
  id          SERIAL,
  name        TEXT,
  description TEXT,
  unit_id     INTEGER
);

--таблица с соответствием продуктов и их параметров
CREATE TABLE products_parameters_mapping
(
  product_id   INTEGER,
  parameter_id INTEGER
);

--таблица с соответствием типов продуктов и их параметров
CREATE TABLE product_types_parameters_mapping
(
  product_type_id INTEGER,
  parameter_id    INTEGER
);





ALTER TABLE units ADD PRIMARY KEY (id);
ALTER TABLE products ADD PRIMARY KEY (id);
ALTER TABLE parameters ADD PRIMARY KEY (id);
ALTER TABLE product_types ADD PRIMARY KEY (id);
ALTER TABLE enums ADD PRIMARY KEY (enum_id);
ALTER TABLE enum_values ADD PRIMARY KEY (enum_val_id);


ALTER TABLE product_types ADD FOREIGN KEY (unit_id) REFERENCES units (id) on delete cascade on update cascade;
ALTER TABLE product_types ADD FOREIGN KEY (parent_id) REFERENCES product_types (id) on delete cascade on update cascade;

ALTER TABLE parameters ADD FOREIGN KEY (unit_id) REFERENCES units (id) on delete cascade on update cascade;
ALTER TABLE parameters ADD FOREIGN KEY (enum_id) REFERENCES enums (enum_id) on delete cascade on update cascade;

ALTER TABLE product_types_parameters_mapping ADD FOREIGN KEY (parameter_id) REFERENCES parameters (id) on delete cascade on update cascade;
ALTER TABLE product_types_parameters_mapping ADD FOREIGN KEY (product_type_id) REFERENCES product_types (id) on delete cascade on update cascade;

ALTER TABLE products_parameters_mapping ADD FOREIGN KEY (product_id) REFERENCES products (id) on delete cascade on update cascade;
ALTER TABLE products_parameters_mapping ADD FOREIGN KEY (parameter_id) REFERENCES parameters (id) on delete cascade on update cascade;







