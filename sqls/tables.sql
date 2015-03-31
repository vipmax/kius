CREATE TABLE units
(
  id               SERIAL,
  name             TEXT,
  description      TEXT
--   ,
--   PRIMARY KEY (id),
--   CONSTRAINT name_key UNIQUE (name)
);

CREATE TABLE floor_coverings
(
  id               SERIAL,
  name             TEXT,
  unit_id          INTEGER,
  parent_id        INTEGER,
  popularity_value INTEGER
--   ,
--   PRIMARY KEY (id),
--   CONSTRAINT name_floor_cov_key UNIQUE (name),
--   FOREIGN KEY (unit_id) REFERENCES units (id),
--   FOREIGN KEY (parent_id) REFERENCES floor_coverings (id) ON UPDATE CASCADE ON DELETE SET NULL
);

CREATE TABLE products
(
  id                SERIAL,
  name              TEXT,
  code              INTEGER,
  floor_covering_id INTEGER
--   ,
--   PRIMARY KEY (product_id),
--   CONSTRAINT name_product_key UNIQUE (name),
--   CONSTRAINT code_key UNIQUE (code),
--   FOREIGN KEY (floor_covering_id) REFERENCES floor_coverings (id)
);