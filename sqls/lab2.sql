DROP TABLE IF EXISTS enum_values;
DROP TABLE IF EXISTS enums;

CREATE TABLE enums
(
  enum_id   SERIAL,
  enum_name VARCHAR(255) NOT NULL,
  PRIMARY KEY (enum_id)
);

CREATE TABLE enum_values
(
  enum_val_id    SERIAL,
  enum_id        INTEGER      NOT NULL,
  enum_val_value INTEGER,
  enum_val_name  VARCHAR(255) NOT NULL,
  enum_val_order INTEGER      NOT NULL,
  PRIMARY KEY (enum_val_id),
  FOREIGN KEY (enum_id) REFERENCES enums (enum_id)
);

DROP FUNCTION IF EXISTS add_enum( VARCHAR );
CREATE FUNCTION add_enum(VARCHAR)
  RETURNS VOID AS $$
BEGIN
  INSERT INTO enums (enum_name) VALUES ($1);
END;
$$ LANGUAGE plpgsql;

DROP FUNCTION IF EXISTS del_enum( INTEGER );
CREATE FUNCTION del_enum(INTEGER)
  RETURNS VOID AS $$
DECLARE
  enum_flag INTEGER := 0;
BEGIN
  enum_flag := (SELECT
                  count(*)
                FROM enums
                WHERE enum_id = $1);
  IF enum_flag = 0
  THEN
    RAISE 'enum not found';
  END IF;
  DELETE FROM enum_values
  WHERE enum_id = $1;
  DELETE FROM enums
  WHERE enum_id = $1;
END;
$$ LANGUAGE plpgsql;

DROP FUNCTION IF EXISTS add_enum_val( INTEGER, VARCHAR, INTEGER );
CREATE FUNCTION add_enum_val(INTEGER, VARCHAR, INTEGER)
  RETURNS VOID AS $$
DECLARE
  max_order INTEGER := 0;
  enum_flag INTEGER := 0;
BEGIN
  enum_flag := (SELECT
                  count(*)
                FROM enums
                WHERE enum_id = $1);
  IF enum_flag = 0
  THEN
    RAISE 'enum not found';
  END IF;
  max_order := coalesce((SELECT
                           max(enum_val_order)
                         FROM enum_values
                         WHERE enum_id = $1), 0);
  max_order := max_order + 1;
  INSERT INTO enum_values (enum_id, enum_val_name, enum_val_value, enum_val_order) VALUES ($1, $2, $3, max_order);
END;
$$ LANGUAGE plpgsql;

DROP FUNCTION IF EXISTS del_enum_val( INTEGER );
CREATE FUNCTION del_enum_val(INTEGER)
  RETURNS VOID AS $$
DECLARE
  this_enum_order INTEGER := 0;
  this_enum_id    INTEGER := 0;
  enum_flag       INTEGER := 0;
BEGIN
  enum_flag := (SELECT
                  count(*)
                FROM enum_values
                WHERE enum_val_id = $1);
  IF enum_flag = 0
  THEN
    RAISE 'enum value not found';
  END IF;
  this_enum_order := (SELECT
                        enum_val_order
                      FROM enum_values
                      WHERE enum_val_id = $1);
  this_enum_id := (SELECT
                     enum_id
                   FROM enum_values
                   WHERE enum_val_id = $1);
  UPDATE enum_values
  SET enum_val_order = enum_val_order - 1
  WHERE enum_id = this_enum_id AND enum_val_order > this_enum_order;
  DELETE FROM enum_values
  WHERE enum_val_id = $1;
END;
$$ LANGUAGE plpgsql;

DROP FUNCTION IF EXISTS get_enum_list( INTEGER );
CREATE FUNCTION get_enum_list(INTEGER)
  RETURNS TABLE(id INTEGER, name VARCHAR, e_value INTEGER, e_order INTEGER) AS
  $$
  DECLARE
    enum_flag INTEGER := 0;
  BEGIN
    enum_flag := (SELECT
                    count(*)
                  FROM enums
                  WHERE enum_id = $1);
    IF enum_flag = 0
    THEN
      RAISE 'enum not found';
    END IF;
    RETURN QUERY
    SELECT
      ev.enum_val_id,
      ev.enum_val_name,
      ev.enum_val_value,
      ev.enum_val_order
    FROM enum_values AS ev
    WHERE enum_id = $1
    ORDER BY enum_val_order;
  END;
  $$ LANGUAGE plpgsql;

DROP FUNCTION IF EXISTS up_enum_val_order( INTEGER );
CREATE FUNCTION up_enum_val_order(INTEGER)
  RETURNS VOID AS $$
DECLARE
  this_enum_order INTEGER := 0;
  this_enum_id    INTEGER := 0;
  enum_flag       INTEGER := 0;
  max_enum_order  INTEGER := 0;
BEGIN
  enum_flag := (SELECT
                  count(*)
                FROM enum_values
                WHERE enum_val_id = $1);
  IF enum_flag = 0
  THEN
    RAISE 'enum value not found';
  END IF;
  this_enum_order := (SELECT
                        enum_val_order
                      FROM enum_values
                      WHERE enum_val_id = $1);
  this_enum_id := (SELECT
                     enum_id
                   FROM enum_values
                   WHERE enum_val_id = $1);
  max_enum_order := (SELECT
                       max(enum_val_order)
                     FROM enum_values
                     WHERE enum_id = this_enum_id);
  IF this_enum_order < max_enum_order
  THEN
    UPDATE enum_values
    SET enum_val_order = this_enum_order
    WHERE enum_val_order = (this_enum_order + 1) AND enum_id = this_enum_id;
    UPDATE enum_values
    SET enum_val_order = this_enum_order + 1
    WHERE enum_val_id = $1;
  END IF;
END;
$$ LANGUAGE plpgsql;

DROP FUNCTION IF EXISTS down_enum_val_order( INTEGER );
CREATE FUNCTION down_enum_val_order(INTEGER)
  RETURNS VOID AS $$
DECLARE
  this_enum_order INTEGER := 0;
  this_enum_id    INTEGER := 0;
  enum_flag       INTEGER := 0;
BEGIN
  enum_flag := (SELECT
                  count(*)
                FROM enum_values
                WHERE enum_val_id = $1);
  IF enum_flag = 0
  THEN
    RAISE 'enum value not found';
  END IF;
  this_enum_order := (SELECT
                        enum_val_order
                      FROM enum_values
                      WHERE enum_val_id = $1);
  this_enum_id := (SELECT
                     enum_id
                   FROM enum_values
                   WHERE enum_val_id = $1);
  IF this_enum_order > 1
  THEN
    UPDATE enum_values
    SET enum_val_order = this_enum_order
    WHERE enum_val_order = (this_enum_order - 1) AND enum_id = this_enum_id;
    UPDATE enum_values
    SET enum_val_order = this_enum_order - 1
    WHERE enum_val_id = $1;
  END IF;
END;
$$ LANGUAGE plpgsql;

SELECT
  add_enum('цвет');
SELECT
  add_enum_val(1, 'ольха желтая', 23455);
SELECT
  add_enum_val(1, 'дуб дачный', 14345);
SELECT
  add_enum_val(1, 'дуб красный', 13444);
SELECT
  add_enum_val(1, 'черное серебро', 7344);
SELECT
  add_enum_val(1, 'вишня', 5622);
SELECT
  add_enum_val(1, 'бук светлый', 6733);
SELECT
  add_enum_val(1, 'орех', 1432);
SELECT
  add_enum('страна производитель');
SELECT
  add_enum_val(2, 'россия', 126);
SELECT
  add_enum_val(2, 'италия', 143);
SELECT
  add_enum_val(2, 'франция', 121);
SELECT
  add_enum_val(2, 'германия', 161);
SELECT
  add_enum_val(2, 'испания', 166);