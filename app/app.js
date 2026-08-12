const express = require('express');
const path = require('path');
const fs = require('fs');  // Add this line to require the fs module
const app = express();
const sequelize = require('./config/db');
const referenceRoutes = require('./routes/referenceRoutes');
const naturalRoutes = require('./routes/naturalRoutes');
const protocolRoutes = require('./routes/protocolRoutes');

const bodyParser = require('body-parser');
app.use(bodyParser.json());

// Static assets.
//
// Code and content must always be revalidated: max-age=0 with an ETag means the
// browser asks every time and gets a cheap 304 when nothing changed, so it still
// avoids re-downloading but can never serve a stale scripts.js or style.css. A
// blanket max-age here previously left editors looking at an hour-old page.
// Images and the vendored jQuery never change under the same name, so they keep a
// long cache.
const revalidate = {
    etag: true,
    maxAge: 0,
    setHeaders(res, filePath) {
        if (/[\\/](images|vendor)[\\/]/.test(filePath)) {
            res.setHeader('Cache-Control', 'public, max-age=86400');
        } else {
            res.setHeader('Cache-Control', 'no-cache');
        }
    }
};
const staticOptions = revalidate;
app.use(express.static(path.join(__dirname, 'public'), staticOptions));

// Serve the index.html file when accessing the root URL
app.get('/', (req, res) => {
    res.sendFile(path.join(__dirname, 'templates', 'index.html'));
    // console.log(path.join(__dirname, 'templates', 'index.html'))
});
// Serve JSON data
app.use('/data', express.static(path.join(__dirname, 'data'), staticOptions));


const tableContents = [
    // 'table-content1',
    // 'table-content2',
    // 'table-content3',
    'operation-contentODG00',
    'operation-contentODG01',
    'operation-contentODG02',
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
    'operation-contentOAR00'
];

// Dynamically create routes for each table content file. Most of these fragments live
// in public/ rather than templates/, so fall back there instead of throwing ENOENT.
tableContents.forEach(content => {
    app.get(`/${content}`, (req, res) => {
        const inTemplates = path.join(__dirname, 'templates', `${content}.html`);
        const inPublic = path.join(__dirname, 'public', `${content}.html`);
        if (fs.existsSync(inTemplates)) return res.sendFile(inTemplates);
        if (fs.existsSync(inPublic)) return res.sendFile(inPublic);
        res.status(404).send('Not found');
    });
});




// Use the router for other routes
app.use('/api', referenceRoutes);

app.use('/api', protocolRoutes);

app.use('/api/stage', naturalRoutes);



const PORT = process.env.PORT || 3000;
app.listen(PORT, () => console.log(`Server running on port ${PORT}`));
