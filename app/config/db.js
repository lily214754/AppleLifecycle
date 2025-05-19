const { Pool } = require('pg');
const fs = require('fs');
const path = require('path');
require('dotenv').config(); // Load environment variables from .env

const isProduction = process.env.NODE_ENV === 'production';


// ✅ Database Connection
const pool = new Pool({
    connectionString: process.env.DATABASE_URL || 'postgres://u8pap51ok1s5ab:p875b0fc01eb409ff04c2bead63a1b2032f1a1e33c2923f0e8e07e5969a45fb9c@ccpa7stkruda3o.cluster-czrs8kj4isg7.us-east-1.rds.amazonaws.com:5432/d84utcnrirk3iu?sslmode=require',
    ssl: { rejectUnauthorized: false }
});

// ✅ Function to Check If `reference_data` Table Exists
async function checkIfRefTableExists() {
    try {
        const client = await pool.connect();
        const result = await client.query(
            "SELECT to_regclass('public.reference_data') AS table_exists;"
        );
        client.release();

        return result.rows[0].table_exists !== null; // ✅ Returns true if table exists
    } catch (error) {
        console.error("❌ Error checking table existence:", error);
        return false;
    }
}

async function checkIfNatTableExists() {
    try {
        const client = await pool.connect();
        const result = await client.query(
            "SELECT to_regclass('public.stage') AS table_exists;"
        );
        client.release();

        return result.rows[0].table_exists !== null; // ✅ Returns true if table exists
    } catch (error) {
        console.error("❌ Error checking table existence:", error);
        return false;
    }
}

// ✅ Function to Execute `database.sql` If Table Doesn't Exist
async function executeSQLFileIfNeeded() {
    try {
        const tableExists = await checkIfRefTableExists();
        if (tableExists) {
            console.log("✅ Table already exists. Skipping database initialization.");
            return;
        }

        console.log(`🔄 Executing SQL file: database.sql...`);
        const filePath = path.join(__dirname, 'database.sql'); // ✅ Get full path of `database.sql`
        const sqlQuery = fs.readFileSync(filePath, 'utf8'); // ✅ Read SQL file

        const client = await pool.connect();
        await client.query(sqlQuery); // ✅ Execute SQL
        client.release();

        console.log("✅ Database initialized successfully!");
    } catch (error) {
        console.error("❌ Error executing SQL file:", error);
    }




}

async function executeSQLFileIfNeeded2() {
    
    try {
        const tableExists = await checkIfNatTableExists();
        if (tableExists) {
            console.log("✅ Table already exists. Skipping database initialization.");
            // return;
        }

        console.log(`🔄 Executing SQL file: natural.sql...`);
        const filePath = path.join(__dirname, 'natural.sql'); // ✅ Get full path of `database.sql`
        const sqlQuery = fs.readFileSync(filePath, 'utf8'); // ✅ Read SQL file


        // console.log(`🔄 Executing SQL file: orchard.sql...`);
        // const filePath2 = path.join(__dirname, 'orchard.sql'); // ✅ Get full path of `database.sql`
        // const sqlQuery2 = fs.readFileSync(filePath2, 'utf8'); // ✅ Read SQL file
        
        const client = await pool.connect();
        try {
            await client.query(sqlQuery); // ✅ Execute SQL
            console.log("SQL executed successfully.");
          } catch (error) {
            console.error("❌ SQL execution error:", error.message);
            console.log("❗ Full error object:", error);
          }
        // await client.query(sqlQuery2); // ✅ Execute SQL
        client.release();
        

        console.log("✅ Database initialized successfully!");
    } catch (error) {
        console.error("❌ Error executing SQL file:", error);
    }
}


// ✅ Execute SQL Only If Needed
executeSQLFileIfNeeded();
executeSQLFileIfNeeded2();



module.exports = pool;
