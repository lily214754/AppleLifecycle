const { Pool } = require('pg');
const fs = require('fs');
const path = require('path');
require('dotenv').config(); // Load environment variables from .env

const connectionString = process.env.DATABASE_URL;
if (!connectionString) throw new Error('DATABASE_URL is not set (see .env.example).');

// A local Postgres container has no TLS. Set PGSSL=disable (see .env.example) to
// connect to one; the hosted database keeps the relaxed SSL it has always used.
const useSsl = process.env.PGSSL !== 'disable' && !/^postgres(ql)?:\/\/[^@]*@(localhost|127\.0\.0\.1|db)[:/]/.test(connectionString);

// ✅ Database Connection
const pool = new Pool({
    connectionString,
    ssl: useSsl ? { rejectUnauthorized: false } : false
});

// The portal's content ships as one file, database.sql. It is loaded into an
// empty database (or, with PORTAL_RESEED=1, over an existing one); a database that
// already holds the portal is used as it is.
async function initializeDatabase() {
    const client = await pool.connect();
    try {
        const { rows } = await client.query("SELECT to_regclass('public.stage') IS NOT NULL AS ready");
        if (rows[0].ready && process.env.PORTAL_RESEED !== '1') {
            console.log('✅ Database already holds the portal.');
            return;
        }
        console.log('🔄 Loading database.sql...');
        await client.query(fs.readFileSync(path.join(__dirname, 'database.sql'), 'utf8'));
        console.log('✅ Database initialized successfully!');
    } catch (error) {
        console.error('❌ Error initializing database:', error.message);
    } finally {
        // The snapshot changes session settings (search_path); never hand this
        // connection back to the pool.
        client.release(true);
    }
}

const ready = process.env.SKIP_DATABASE_INIT === 'true' ? Promise.resolve() : initializeDatabase();

module.exports = pool;
module.exports.ready = ready;
