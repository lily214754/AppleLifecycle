const express = require('express');
const path = require('path');
const fs = require('fs');  // Add this line to require the fs module
const app = express();
const sequelize = require('./config/db');
const referenceRoutes = require('./routes/referenceRoutes');
const naturalRoutes = require('./routes/naturalRoutes');

const bodyParser = require('body-parser');
app.use(bodyParser.json());

// Serve static files from the "public" directory
app.use(express.static(path.join(__dirname, 'public')));

// Serve the index.html file when accessing the root URL
app.get('/', (req, res) => {
    res.sendFile(path.join(__dirname, 'templates', 'index.html'));
    // console.log(path.join(__dirname, 'templates', 'index.html'))
});
// Serve JSON data
app.use('/data', express.static(path.join(__dirname, 'data')));


const tableContents = [
    // 'table-content1',
    // 'table-content2',
    // 'table-content3',
    'opration-contentODG00',
    'opration-contentODG01',
    'opration-contentODG02',
    'table-content3.1',
    'table-content3.2',
    'table-content3.3',
    'thirdparty-databases',
    'table-content3.4.1',
    'table-content3.4.2',
    'table-content3.4.3',
    'table-content3.5',
    'table-content3.6.1',
    'table-content3.6.2',
    'table-content3.7.1',
    'table-content3.7.2',
    // 'table-content4',
    'natural',
    'orchard',
    'tree_lifecycle',
    'annual_season',
    'ODG01',
    'opration-contentOAR00'
];

// Dynamically create routes for each table content file
tableContents.forEach(content => {
    app.get(`/${content}`, (req, res) => {
        res.sendFile(path.join(__dirname, 'templates', `${content}.html`));
    });
});




// Use the router for other routes
app.use('/api', referenceRoutes);

app.use('/api/stage', naturalRoutes);



const PORT = process.env.PORT || 3000;
app.listen(PORT, () => console.log(`Server running on port ${PORT}`));
