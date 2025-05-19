const pool = require('../config/db');

const getAllRef = async () => {
    const res = await pool.query('SELECT * FROM reference_data');
    return res.rows;
};

const getReferenceBybibtex_key = async (bibtex_key) => {
    const res = await pool.query('SELECT * FROM reference_data WHERE bibtex_key = $1', [bibtex_key]);
    // console.log(res);
    return res.rows[0];
};

module.exports = {
    getReferenceBybibtex_key,
    getAllRef,
};


// const { DataTypes } = require('sequelize');
// const sequelize = require('../config/db');

// const Reference = sequelize.define('Reference', {
//     id: {
//         type: DataTypes.INTEGER,
//         autoIncrement: true,
//         primaryKey: true,
//     },
//     bibtex_key: {
//         type: DataTypes.STRING,
//         allowNull: false,
//         unique: true,
//     },
//     title: {
//         type: DataTypes.STRING,
//         allowNull: false,
//     },
//     author: {
//         type: DataTypes.STRING,
//         allowNull: false,
//     },
//     year: {
//         type: DataTypes.INTEGER,
//         allowNull: false,
//     },
//     publisher: {
//         type: DataTypes.STRING,
//         allowNull: false,
//     },
//     bibtex_entry: {
//         type: DataTypes.TEXT,
//         allowNull: false,
//     },
// });

// module.exports = Reference;



