const { Pool } = require('pg');
const fs = require('fs');
const path = require('path');
require('dotenv').config(); // Load environment variables from .env

const connectionString = process.env.DATABASE_URL || 'postgres://u8pap51ok1s5ab:p875b0fc01eb409ff04c2bead63a1b2032f1a1e33c2923f0e8e07e5969a45fb9c@ccpa7stkruda3o.cluster-czrs8kj4isg7.us-east-1.rds.amazonaws.com:5432/d84utcnrirk3iu?sslmode=require';

// A local Postgres container has no TLS. Set PGSSL=disable (see .env.example) to
// connect to one; the hosted database keeps the relaxed SSL it has always used.
const useSsl = process.env.PGSSL !== 'disable' && !/^postgres(ql)?:\/\/[^@]*@(localhost|127\.0\.0\.1|db)[:/]/.test(connectionString);

// ✅ Database Connection
const pool = new Pool({
    connectionString,
    ssl: useSsl ? { rejectUnauthorized: false } : false
});

// ✅ Function to Check If a Table Exists
async function tableExists(tableName) {
    try {
        const result = await pool.query(
            "SELECT to_regclass($1) AS table_exists;", [`public.${tableName}`]
        );
        return result.rows[0].table_exists !== null;
    } catch (error) {
        console.error(`❌ Error checking whether ${tableName} exists:`, error.message);
        return false;
    }
}

// ✅ Run a SQL file from this directory
async function runSQLFile(fileName) {
    const filePath = path.join(__dirname, fileName);
    const sqlQuery = fs.readFileSync(filePath, 'utf8');
    console.log(`🔄 Executing SQL file: ${fileName}...`);
    await pool.query(sqlQuery);
    console.log(`✅ ${fileName} executed successfully.`);
}

// The three files must run in order: database.sql creates reference_data, natural.sql
// recreates stage and the tables that point at it, and protocol.sql layers the
// measurement protocols on top of both. Running them concurrently -- as this used to --
// let natural.sql reach reference_data before it existed.
async function initializeDatabase() {
    try {
        if (await tableExists('reference_data')) {
            console.log("✅ reference_data already exists. Skipping database.sql.");
        } else {
            await runSQLFile('database.sql');
        }

        await runSQLFile('natural.sql');
        await runSQLFile('protocol.sql');
        // Additions still awaiting sign-off; they render in blue until confirmed.
        await runSQLFile('added_operations.sql');
        await runSQLFile('added_operations_ipdm.sql');
        await runSQLFile('added_operations_pennstate.sql');
        await runSQLFile('added_operations_nsw.sql');
        await runSQLFile('fix_oregon_citations.sql');
        await runSQLFile('added_operations_guides.sql');
        await runSQLFile('added_operations_specialists.sql');
        await runSQLFile('added_operations_final.sql');
        await runSQLFile('added_operations_web.sql');
        await runSQLFile('added_operations_futureorchards.sql');
        await runSQLFile('fix_fruit_quality.sql');
        await runSQLFile('added_operations_quality.sql');
        await runSQLFile('added_operations_metamitron.sql');
        // Peer-reviewed sources, unlike every other pass above. Must run before the
        // fix_* passes so the integrity check covers these rows too.
        await runSQLFile('added_operations_papers.sql');
        await runSQLFile('fix_links.sql');
        // Must run after every operation has been inserted: it moves operations
        // between stages, so anything added later would miss the correction.
        await runSQLFile('fix_stage_timing.sql');
        // Depends on fix_stage_timing.sql: the pairs it merges only sit at the same
        // stage once the mis-filed half has been moved there.
        await runSQLFile('fix_duplicate_operations.sql');
        await runSQLFile('fix_integrity.sql');

        console.log("✅ Database initialized successfully!");
    } catch (error) {
        console.error("❌ Error initializing database:", error.message);
    }
}

const ready = initializeDatabase();

module.exports = pool;
module.exports.ready = ready;
