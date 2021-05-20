const express = require('express')
const pg = require('pg')
require('dotenv').config()

const server = express()

// server.use('/api',express.json())

var pgConfig =
{
    host: process.env.PG_HOST,
    user: process.env.PG_USER,
    password: process.env.PG_PASSWORD,
    database: process.env.PG_DB,
    port: Number(process.env.PG_PORT) || 5432
};

// console.log(pgConfig)



async function useDB(cb) {
    const pgClient = new pg.Client(pgConfig)
    pgClient.connect()
    const {rows} = await cb(pgClient)
    await pgClient.end()
    return rows
}// end useDB

function readData(db){
    return db.query('SELECT * FROM shopping_list') 
};

let port = Number(process.env.PORT) || 3030

server.get("/api/shopping", async (req,res) => {
    try {
       rows= await useDB(readData) 
       res.status(200).json(rows)
    } catch (error) {
       console.error(error)
       res.status(400).json({error:"An error occured"})  
    }
})

server.use('/',express.static('web'))
 
server.listen(port, ()=> console.log(`Server listening on port ${port}`))