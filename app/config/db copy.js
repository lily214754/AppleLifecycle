// const { Pool } = require('pg');
// require('dotenv').config(); // Load environment variables from .env

// // ✅ Database Connection
// const pool = new Pool({
//     connectionString: process.env.DATABASE_URL || 'postgres://u8pap51ok1s5ab:p875b0fc01eb409ff04c2bead63a1b2032f1a1e33c2923f0e8e07e5969a45fb9c@ccpa7stkruda3o.cluster-czrs8kj4isg7.us-east-1.rds.amazonaws.com:5432/d84utcnrirk3iu?sslmode=require',
//     ssl: { rejectUnauthorized: false }
// });

// // ✅ Check if the `reference_data` Table Exists
// async function checkIfTableExists() {
//     try {
//         const client = await pool.connect();
//         const result = await client.query(
//             "SELECT to_regclass('public.reference_data') AS table_exists;"
//         );
//         client.release();
//         return result.rows[0].table_exists !== null;
//     } catch (error) {
//         console.error("❌ Error checking table existence:", error);
//         return false;
//     }
// }

// // ✅ SQL Query: Drop & Create Table + Insert Data
// const initDbQuery = `
//     DROP TABLE IF EXISTS reference_data;

//     CREATE TABLE reference_data (
//         id SERIAL PRIMARY KEY,
//         bibtex_key VARCHAR(255) NOT NULL,
//         title TEXT NOT NULL,
//         author TEXT NOT NULL,
//         year INT,
//         publisher TEXT,
//         bibtex_entry TEXT
//     );

//     INSERT INTO reference_data (bibtex_key, title, author, year, publisher, bibtex_entry) 
//     VALUES ('ferreeApplesBotanyProduction2003', 'Apples: Botany, Production, and Uses', 'Ferree, David Curtis and Warrington, Ian J', 2003, 'CABI', ' ');
// `;

// // ✅ Function to Execute the SQL Query Only Once
// async function initializeDatabase() {
//     try {
//         const tableExists = await checkIfTableExists();
//         if (tableExists) {
//             console.log("✅ Table already exists. Skipping database initialization.");
//             return;
//         }

//         console.log("🔄 Initializing database...");
//         await pool.query(initDbQuery);
//         console.log("✅ Database initialized successfully!");
//     } catch (error) {
//         console.error("❌ Database initialization error:", error);
//     }
// }

// // ✅ Run Initialization on Startup
// initializeDatabase();

// // ✅ Export Pool for Other Modules
// module.exports = pool;
