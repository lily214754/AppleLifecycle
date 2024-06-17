
const { Pool } = require('pg');

const pool = new Pool({
    user: 'postgres',
    host: 'db',
    database: 'postgres',
    password: 'postgres',
    port: 5432,
});

module.exports = pool;

// // const { Sequelize } = require('sequelize');

// // // Create a new Sequelize instance
// // const sequelize = new Sequelize('postgres', 'postgres', 'postgres', {
// //     host: 'db',
// //     dialect: 'postgres'
// // });

// // // Test the database connection
// // sequelize.authenticate()
// //     .then(() => {
// //         console.log('Connection has been established successfully.');
// //     })
// //     .catch(err => {
// //         console.error('Unable to connect to the database:', err);
// //     });

// // module.exports = sequelize;

// const { Sequelize } = require('sequelize');

// const sequelize = new Sequelize('postgres', 'postgres', 'postgres', {
//     host: 'db',
//     dialect: 'postgres',
//     pool: {
//         max: 5,
//         min: 0,
//         acquire: 30000,
//         idle: 10000
//     }
// });

// sequelize.authenticate()
//     .then(() => {
//         console.log('Connection has been established successfully.');
//     })
//     .catch(err => {
//         console.error('Unable to connect to the database:', err);
//     });

// module.exports = sequelize;
