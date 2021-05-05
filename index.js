const express = require('express')
const app = express()

let port = Number(process.env.APP_PORT) || 80

app.use('/',express.static('web'))
 
app.listen(port, ()=> console.log(`Server listening on port ${port}`))