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

