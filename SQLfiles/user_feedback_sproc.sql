DROP PROCEDURE IF EXISTS gradient_db.user_input;
DELIMITER //

CREATE PROCEDURE gradient_db.user_input (
	IN input_time VARCHAR(19), 
    IN input_lat DOUBLE, 
    IN input_long DOUBLE, 
    IN input_severity INT(1),
    OUT request_status VARCHAR(7))
    
BEGIN

	SET request_status = "failed";

	SET @_severity = input_severity;

	SET @_lat = input_lat;

	SET @_long = input_long;

	SET @input_time = input_time;
	SET @old_time = UNIX_TIMESTAMP(@input_time);
	SET @new_time = FROM_UNIXTIME( @old_time - (@old_time MOD 900));
    
    SET @_current_capacity = 0;

	SELECT  GPS_coordinates.element_key_fk, blockface.estimated_capacity
					FROM gradient_db.GPS_coordinates
					INNER JOIN blockface
					ON GPS_coordinates.element_key_fk = blockface.element_key
						WHERE latitude-@_lat >= 0 
							AND longitude - @_long >= 0
							ORDER BY latitude-@_lat, longitude - @_long
							LIMIT 1
								INTO @_blockface, @_capacity;

	SELECT occupied_spots 
		FROM gradient_db.machine_learning_model 
			WHERE element_key_fk = @_blockface
            AND date_time = @new_time
            INTO @_current_capacity;

		SELECT 
			IF (@_severity=1, @_capacity+1, @_capacity-1)
			INTO @_capacity;
            
		CASE
			WHEN @_current_capacity != @_capacity
				THEN
					START TRANSACTION;
						INSERT INTO machine_learning_model (date_time, element_key_fk, occupied_spots) VALUES (@new_time,@_blockface,@_capacity)
						  ON DUPLICATE KEY UPDATE occupied_spots = @_capacity;
					COMMIT;
                    SET request_status = "success";
			WHEN @_current_capacity = @_capacity
				THEN
					SET request_status = "repeat";
		END CASE;
        
        SELECT request_status;
    
END //
DELIMITER ;

