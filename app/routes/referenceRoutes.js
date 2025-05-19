const express = require('express');
const router = express.Router();
const { getReferenceBybibtex_key,getAllRef } = require('../models/referenceModel');


router.get('/reference/:bibtex_key', async (req, res) => {
    const { bibtex_key } = req.params;
    console.log(bibtex_key);
    try {
        const reference = await getReferenceBybibtex_key(bibtex_key);
        res.json(reference);
        // console.log(reference);
    } catch (err) {
        console.error(err);
        console.error(bibtex_key,'getmethod');
        res.status(500).json({ error: 'Internal Server Error' });
    }
});

router.get('/reference', async (req, res) => {
    try {
        const reference = await getAllRef();
        res.json(reference);
    } catch (err) {
        console.error(err);
        console.error(bibtex_key,'getmethod');
        res.status(500).json({ error: 'Internal Server Error' });
    }
});

module.exports = router;