-- pkeys

ALTER TABLE units ADD PRIMARY KEY (id);
ALTER TABLE products ADD PRIMARY KEY (id);
ALTER TABLE parameters ADD PRIMARY KEY (id);
ALTER TABLE product_types ADD PRIMARY KEY (id);
ALTER TABLE enums ADD PRIMARY KEY (enum_id);
ALTER TABLE enum_values ADD PRIMARY KEY (enum_val_id);
ALTER TABLE product_types_parameters_mapping ADD PRIMARY KEY (product_type_id, parameter_id);
ALTER TABLE products_parameters_mapping ADD PRIMARY KEY (product_id, parameter_id);
ALTER TABLE parameter_types ADD PRIMARY KEY (id);

-- fkeys

ALTER TABLE products ADD FOREIGN KEY (product_type_id) REFERENCES product_types (id) ON DELETE CASCADE ON UPDATE CASCADE;

ALTER TABLE product_types ADD FOREIGN KEY (unit_id) REFERENCES units (id) ON DELETE CASCADE ON UPDATE CASCADE;
ALTER TABLE product_types ADD FOREIGN KEY (parent_id) REFERENCES product_types (id) ON DELETE CASCADE ON UPDATE CASCADE;

ALTER TABLE parameters ADD FOREIGN KEY (unit_id) REFERENCES units (id) ON DELETE CASCADE ON UPDATE CASCADE;
ALTER TABLE parameters ADD FOREIGN KEY (enum_id) REFERENCES enums (enum_id) ON DELETE CASCADE ON UPDATE CASCADE;
ALTER TABLE parameters ADD FOREIGN KEY (parameter_type_id) REFERENCES parameter_types (id) ON DELETE CASCADE ON UPDATE CASCADE;

ALTER TABLE product_types_parameters_mapping ADD FOREIGN KEY (parameter_id) REFERENCES parameters (id) ON DELETE CASCADE ON UPDATE CASCADE;
ALTER TABLE product_types_parameters_mapping ADD FOREIGN KEY (product_type_id) REFERENCES product_types (id) ON DELETE CASCADE ON UPDATE CASCADE;

ALTER TABLE products_parameters_mapping ADD FOREIGN KEY (product_id) REFERENCES products (id) ON DELETE CASCADE ON UPDATE CASCADE;
ALTER TABLE products_parameters_mapping ADD FOREIGN KEY (parameter_id) REFERENCES parameters (id) ON DELETE CASCADE ON UPDATE CASCADE;
ALTER TABLE products_parameters_mapping ADD FOREIGN KEY (enum_val_id) REFERENCES enum_values (enum_val_id) ON DELETE CASCADE ON UPDATE CASCADE;


ALTER TABLE enum_values ADD FOREIGN KEY (enum_id) REFERENCES enums (enum_id) ON DELETE CASCADE ON UPDATE CASCADE;




