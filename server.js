const express = require('express')
const server = express()

let port = Number(process.env.PORT) || 3030

server.use('/',express.static('web'))
 
server.listen(port, ()=> console.log(`Server listening on port ${port}`))