const express = require('express');
const router = express.Router();
const {
    getAllKeyMeasurements,
    getProtocolById,
    getProtocolByMeasurementId
} = require('../models/naturalModel');

// Every stage's key measurements in one request. The lifecycle table renders many
// stages at once, so the page fetches this once and reuses it for each navigation.
router.get('/keymeasurements', async (req, res) => {
    try {
        const results = await getAllKeyMeasurements();
        res.set('Cache-Control', 'public, max-age=300');
        res.json(results);
    } catch (err) {
        console.error('Error fetching key measurements:', err);
        res.status(500).json({ error: 'Internal Server Error' });
    }
});

// Full measurement protocol behind a key measurement, including its references
// and the stages it applies to.
router.get('/protocol/:protocol_id', async (req, res) => {
    const protocolId = Number(req.params.protocol_id);
    if (!Number.isInteger(protocolId)) {
        return res.status(400).json({ error: 'protocol_id must be an integer' });
    }
    try {
        const protocol = await getProtocolById(protocolId);
        if (!protocol) return res.status(404).json({ error: 'Protocol not found' });
        res.set('Cache-Control', 'public, max-age=300');
        res.json(protocol);
    } catch (err) {
        console.error('Error fetching protocol:', err);
        res.status(500).json({ error: 'Internal Server Error' });
    }
});

// Convenience hop for callers that hold a measurement id rather than a protocol id.
router.get('/measurement/:measurement_id/protocol', async (req, res) => {
    const measurementId = Number(req.params.measurement_id);
    if (!Number.isInteger(measurementId)) {
        return res.status(400).json({ error: 'measurement_id must be an integer' });
    }
    try {
        const protocol = await getProtocolByMeasurementId(measurementId);
        if (!protocol) {
            return res.status(404).json({ error: 'No protocol linked to this measurement' });
        }
        res.set('Cache-Control', 'public, max-age=300');
        res.json(protocol);
    } catch (err) {
        console.error('Error fetching protocol for measurement:', err);
        res.status(500).json({ error: 'Internal Server Error' });
    }
});

module.exports = router;
