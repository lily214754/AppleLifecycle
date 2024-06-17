const express = require('express');
const path = require('path');
const fs = require('fs');  // Add this line to require the fs module
const app = express();
const sequelize = require('./config/db');
const referenceRoutes = require('./routes/referenceRoutes');

// Serve static files from the "public" directory
app.use(express.static(path.join(__dirname, 'public')));

// Serve the index.html file when accessing the root URL
app.get('/', (req, res) => {
    res.sendFile(path.join(__dirname, 'templates', 'index.html'));
    // console.log(path.join(__dirname, 'templates', 'index.html'))
});

const tableContents = [
    'table-content1',
    'table-content2',
    'table-content3',
    'table-content2.1',
    'table-content2.2',
    'table-content2.3',
    'table-content3.1',
    'table-content3.2',
    'table-content3.3',
    'table-content3.4.1',
    'table-content3.4.2',
    'table-content3.4.3',
    'table-content3.5',
    'table-content3.6.1',
    'table-content3.6.2',
    'table-content3.7.1',
    'table-content3.7.2',
    'table-content4'
];

// Dynamically create routes for each table content file
tableContents.forEach(content => {
    app.get(`/${content}`, (req, res) => {
        res.sendFile(path.join(__dirname, 'templates', `${content}.html`));
    });
});



app.get('/data/tablesData', (req, res) => {
    const dataPath = path.join(__dirname, 'data', 'tablesData.json');
    fs.readFile(dataPath, 'utf8', (err, data) => {
        if (err) {
            console.error('Error reading JSON data:', err);
            res.status(500).send('Internal Server Error');
            return;
        }
        res.setHeader('Content-Type', 'application/json');
        res.send(data);
    });
});


// Use the router for other routes
app.use('/api', referenceRoutes);

const port = 3000;
app.listen(port, () => {
    console.log(`Server running at http://localhost:${port}/`);
});

// sequelize.sync({ force: true }).then(() => {
//     console.log('Database & tables created!');
// });


// const express = require('express');
// const path = require('path');
// const app = express();
// const referenceRoutes = require('./routes/referenceRoutes');

// // Serve static files from the "public" directory
// app.use(express.static(path.join(__dirname, 'public')));

// // Serve the index.html file when accessing the root URL
// app.get('/', (req, res) => {
//     res.sendFile(path.join(__dirname, 'templates', 'index.html'));
// });

// // Array of table content file names
// const tableContents = [
//     'table-content1',
//     'table-content2',
//     'table-content2.1',
//     'table-content2.2',
//     'table-content2.3',
//     'table-content3.1',
//     'table-content3.2',
//     'table-content3.3',
//     'table-content3.4.1',
//     'table-content3.4.2',
//     'table-content3.4.3',
//     'table-content3.5',
//     'table-content3.6.1',
//     'table-content3.6.2',
//     'table-content3.7.1',
//     'table-content3.7.2',
//     'table-content4'
// ];

// // Dynamically create routes for each table content file
// tableContents.forEach(content => {
//     app.get(`/${content}`, (req, res) => {
//         res.sendFile(path.join(__dirname, 'templates', `${content}.html`));
//     });
// });

// // Use the router for other routes
// app.use('/api', referenceRoutes);

// const port = 3000;
// app.listen(port, () => {
//     console.log(`Server running at http://localhost:${port}/`);
// });


// const express = require('express');
// const path = require('path');
// const app = express();
// const referenceRoutes = require('./routes/referenceRoutes');

// // Serve static files from the "public" directory
// app.use(express.static(path.join(__dirname, 'public')));

// // Serve the index.html file when accessing the root URL
// app.get('/', (req, res) => {
//     res.sendFile(path.join(__dirname, 'templates', 'index.html'));
// });

// Array of table content file names


// // Use the router for other routes
// app.use('/api', referenceRoutes);

// const port = 3000;
// app.listen(port, () => {
//     console.log(`Server running at http://localhost:${port}/`);
// });
