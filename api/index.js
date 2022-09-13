const express = require('express');
require('dotenv').config()
const app = express();

app.use(express.json())
app.use(express.urlencoded({ 'extended': true }))

// app.use((req, res, next) => {
//     next();
// });

app.get('/', (req, res) => {
    return res.json({
        "message": `Hello World! ${Date()}`,
        "host": process.env.MYSQL_HOST
    })
})

// app.use(require('./routes/database'));


app.listen(80, () => {
    console.log(`Listening on port ${process.env.APP_PORT}`);
    console.log(`Mysql host: ${process.env.MYSQL_HOST}`)
})