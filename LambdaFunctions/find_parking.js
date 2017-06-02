exports.handler = (event, context, callback) => {
    console.log("We received " + JSON.stringify(event));

    var data = {};
    data.zones = [];
    
    var mysql = require('mysql');
    var connection = mysql.createConnection({
      host     : '<host_URL>',
      user     : '<username>',
      password : '<password>'
    });
    
    connection.connect(function(err) {
      if (err) {
        console.error('error connecting: ' + err.stack);
        return;
      }
     console.log('connected as id ' + connection.threadId);
    });
    
    connection.query("CALL gradient_db.find_parking('" + event.datetime + "', " + event.latitude + ", " + event.longitude + ");", function(err, rows)
    {
        var index = 0;
        var coord_index = 0;
        if (err) throw err;
        // loop through the returned rows and format for the phone app
        var length = rows[0].length;
        for (i = 0; i < length; i++) { 
            if (i !== 0 && rows[0][i].severity !== rows[0][i-1].severity){
                while (rows[0][i].element_key === rows[0][i-1].element_key){
                    console.log("repeat");
                    i += 1;   
                }
            }
            if (i === 0 || (rows[0][i].element_key != rows[0][i-1].element_key)){
                if ( i > 0){
                    index += 1;   
                }
                data.zones.push({ elementid : rows[0][i].element_key, severity : rows[0][i].severity, coordinates : [] });
            }
            data.zones[index].coordinates.push({ latitude : rows[0][i].latitude, longitude : rows[0][i].longitude }); 
        }
        callback(null, {"statusCode": 200, "body": JSON.stringify(data.zones)});
    });

    connection.end(function(err) {
      // The connection is terminated now
    });
    
};
