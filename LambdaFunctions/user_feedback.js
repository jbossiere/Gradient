exports.handler = (event, context, callback) => {
    console.log("We received " + JSON.stringify(event));
    
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
    
    connection.query("CALL gradient_db.user_input('" + event.datetime + "', " + event.latitude + ", " + event.longitude + ", " + event.severity +", @result);", function(err, rows)
    {
        console.log(JSON.stringify(rows[0][0].request_status));
        callback(null, {"statusCode": 200, "body": JSON.stringify(rows[0][0].request_status)});
    });

    connection.end(function(err) {
      // The connection is terminated now
    });
    
};
