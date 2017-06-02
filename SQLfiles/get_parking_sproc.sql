DROP PROCEDURE IF EXISTS gradient_db.find_parking;
DELIMITER //
CREATE PROCEDURE gradient_db.find_parking (
	IN input_time VARCHAR(19), 
    IN input_lat DOUBLE, 
    IN input_long DOUBLE)
BEGIN

SET @input_time = input_time;
SET @old_time = UNIX_TIMESTAMP(@input_time);
SET @new_time = FROM_UNIXTIME( @old_time - (@old_time MOD 900));
SET @one_week_ago = DATE_SUB(@new_time, INTERVAL 1 WEEK);

SET @input_lat = input_lat;
SET @input_long = input_long;
SET @max_lat = @input_lat + 0.01;
SET @min_lat = @input_lat - 0.01;
SET @max_long = @input_long + 0.01;
SET @min_long = @input_long - 0.01;


SELECT gradient_db.blockface.element_key, 
	gradient_db.GPS_coordinates.latitude, 
	gradient_db.GPS_coordinates.longitude, 
    IF(gradient_db.blockface.estimated_capacity > gradient_db.machine_learning_model.occupied_spots, 0, 1) AS severity, 
    gradient_db.blockface.estimated_capacity, 
    gradient_db.machine_learning_model.occupied_spots,
    gradient_db.machine_learning_model.date_time
	FROM gradient_db.blockface 
		INNER JOIN gradient_db.GPS_coordinates 
			ON gradient_db.blockface.element_key = gradient_db.GPS_coordinates.element_key_fk
		INNER JOIN gradient_db.machine_learning_model
			ON gradient_db.blockface.element_key = gradient_db.machine_learning_model.element_key_fk
	WHERE (
			gradient_db.machine_learning_model.date_time = @new_time
			OR gradient_db.machine_learning_model.date_time = @one_week_ago
        )
        AND gradient_db.blockface.element_key IN (
			SELECT DISTINCT gradient_db.GPS_coordinates.element_key_fk 
				FROM gradient_db.GPS_coordinates
                WHERE @max_lat >= gradient_db.GPS_coordinates.latitude 
					AND @min_lat <= gradient_db.GPS_coordinates.latitude
					AND @max_long >= gradient_db.GPS_coordinates.longitude 
					AND @min_long <= gradient_db.GPS_coordinates.longitude
		)
	ORDER BY gradient_db.blockface.element_key, gradient_db.machine_learning_model.date_time DESC;
	
END //
DELIMITER ;

