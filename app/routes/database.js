const routes = require('express').Router();
const mysql = require('mysql2');

const connection = mysql.createConnection({
    host: process.env.MYSQL_HOST,
    user: process.env.MYSQL_USER,
    password: process.env.MYSQL_PWD,
    database: process.env.MYSQL_DATABASE,
    port: process.env.MYSQL_PORT
});

routes.get('/table/new', (req, res) => {
    try {
        var sql = "CREATE TABLE IF NOT EXISTS people (id INT(11) AUTO_INCREMENT, full_name VARCHAR(255), email VARCHAR(255), title VARCHAR(100), location_name VARCHAR(100), PRIMARY KEY (id))";
        connection.query(sql, function (err, result) {
            if (err) throw err;
        });
        return res.send("Done")
    }
    catch (error) {
        console.log(error)
        return res.json({
            'message': JSON.stringify(error, null, 2)
        })
    }
})

routes.put('/people', (req, res) => {
    const { body } = req;
    try {
        var sql = `INSERT INTO people VALUE(0, '${body.fullName}', '${body.email}', '', '')`
        connection.query(sql, function (err, result) {
            if (err) throw err;
        });
        return res.send("Done")
    }
    catch (error) {
        console.log(error)
        return res.json({
            'message': JSON.stringify(error, null, 2)
        })
    }
})

routes.delete('/people', (req, res) => {
    const { body } = req;
    try {
        var sql = `DELETE FROM people WHERE email = '${body.email}'`
        connection.query(sql, function (err, result) {
            if (err) throw err;
        });
        return res.send("Done")
    }
    catch (error) {
        console.log(error)
        return res.json({
            'message': JSON.stringify(error, null, 2)
        })
    }
})

routes.get('/people/:email', (req, res) => {
    const { params } = req;
    try {
        var sql = `SELECT * FROM people WHERE email = '${params.email}'`
        connection.query(sql, function (err, result) {
            if (err) throw err;
            return res.send(
                result.map(item => ({
                    name: item.full_name,
                    email: item.email,
                    title: item.title,
                    location: item.location_name
                })
                )
            );
        });
    }
    catch (error) {
        console.log(error)
        return res.json({
            'message': JSON.stringify(error, null, 2)
        })
    }
})

routes.get('/people', function (req, res) {
    try {
        connection.query('SELECT * FROM people', function (error, results) {

            if (error) {
                throw error
            };
            console.log(results);
            res.send(
                results.map(item => ({
                    name: item.full_name,
                    email: item.email,
                    title: item.title,
                    location: item.location_name
                })
                )
            );
        });
    }
    catch (error) {
        console.log(error)
        return res.json({
            'message': JSON.stringify(error, null, 2)
        })
    }
});

module.exports = routes