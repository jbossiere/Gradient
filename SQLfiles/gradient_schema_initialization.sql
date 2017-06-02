CREATE TABLE IF NOT EXISTS gradient_db.blockface
(
	element_key INT(7) NOT NULL,
    estimated_capacity INT(3) NOT NULL,
    CONSTRAINT blockface_primary_key 
		PRIMARY KEY (element_key)
);

-- DROP TABLE gradient_db.GPS_coordinates;

CREATE TABLE IF NOT EXISTS gradient_db.GPS_coordinates
(
	-- 	coordinate_id INT(11) NOT NULL AUTO_INCREMENT,
    element_key_fk INT(7) NOT NULL,
    latitude DOUBLE NOT NULL,
    longitude DOUBLE NOT NULL,
    CONSTRAINT GPS_coordinates_primary_key
		-- PRIMARY KEY (coordinate_id),
        PRIMARY KEY (element_key_fk, latitude, longitude),
    CONSTRAINT GPS_coordinates_foreign_key 
		FOREIGN KEY (element_key_fk) 
		REFERENCES gradient_db.blockface(element_key)
		ON DELETE CASCADE
);

-- DROP TABLE gradient_db.machine_learning_model;

CREATE TABLE IF NOT EXISTS gradient_db.machine_learning_model
(
	-- machine_learning_model_id INT(15) NOT NULL AUTO_INCREMENT,
    date_time DATETIME NOT NULL,
    element_key_fk INT(7) NOT NULL,
    availability INT(1) NOT NULL,
    CONSTRAINT machine_learning_model_primary_key
		-- PRIMARY KEY (machine_learning_model_id),
		PRIMARY KEY (date_time, element_key_fk),
	CONSTRAINT machine_learning_model_foreign_key
		FOREIGN KEY (element_key_fk)
        REFERENCES gradient_db.blockface(element_key)
        ON DELETE CASCADE
);

