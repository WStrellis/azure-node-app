const express = require('express')
const mysql = require('mysql2/promise')
require('dotenv').config()

const server = express()

// server.use('/api',express.json())

var mysqlConfig =
{
    host: process.env.MYSQL_HOST,
    user: process.env.MYSQL_USER,
    password: process.env.MYSQL_PASSWORD,
    database: process.env.MYSQL_DB,
    port: process.env.MYSQL_PORT || 3306
};

// console.log(mysqlConfig)



async function useDB(cb) {
    const mysqlConn = await mysql.createConnection(mysqlConfig)
    const [rows] = await cb(mysqlConn)
    await mysqlConn.end()
    return rows
}// end useDB

function readData(db){
    return db.query('SELECT * FROM shopping_list') 
};

let port = Number(process.env.PORT) || 3030

server.get("/api/shopping", async (req,res) => {
    try {
       result = await useDB(readData) 
       res.status(200).json(result)
    } catch (error) {
       console.error(error)
       res.status(400).json({error:"An error occured"})  
    }
})

server.use('/',express.static('web'))
 
server.listen(port, ()=> console.log(`Server listening on port ${port}`))