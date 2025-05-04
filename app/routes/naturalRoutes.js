const express = require('express');
const router = express.Router();
const { 
    getAllTimingByStageCode,
    getAllObservationsByStageCode,
    getAllKeyMeasurementsByStageCode,
    getAllOperationByStageCode,
    getAllGeneralOperationByStageCode,
    getAllTiming,
    getOrInsertStage,
    insertTiming,
    insertObservation,
    insertMeasurement
} = require('../models/naturalModel');



router.get('/timing', async (req, res) => {
    try {
        const results = await getAllTiming();
        res.json(results);
    } catch (err) {
        console.error(err);
        res.status(500).json({ error: 'Internal Server Error' });
    }
});



router.get('/:stage_code/timing', async (req, res) => {
    try {
        const results = await getAllTimingByStageCode(req.params.stage_code);
        res.json(results);
    } catch (err) {
        console.error(err);
        res.status(500).json({ error: 'Internal Server Error' });
    }
});

router.get('/:stage_code/observation', async (req, res) => {
    try {
        const results = await getAllObservationsByStageCode(req.params.stage_code);
        res.json(results);
    } catch (err) {
        console.error(err);
        res.status(500).json({ error: 'Internal Server Error' });
    }
});

router.get('/:stage_code/keymeasurement', async (req, res) => {
    try {
         console.log(req.params.stage_code);
        const results = await getAllKeyMeasurementsByStageCode(req.params.stage_code);
        res.json(results);
    } catch (err) {
        console.error(err);
        res.status(500).json({ error: 'Internal Server Error' });
    }
});


router.get('/:stage_code/operation', async (req, res) => {
    try {
      const results = await getAllOperationByStageCode(req.params.stage_code);
      res.json(results);
    } catch (err) {
      console.error('Error fetching operations:', err);
      res.status(500).json({ error: 'Internal Server Error' });
    }
  });

  router.get('/:stage_code/generaloperation', async (req, res) => {
    try {
      const results = await getAllGeneralOperationByStageCode(req.params.stage_code);
      res.json(results);
    } catch (err) {
      console.error('Error fetching operations:', err);
      res.status(500).json({ error: 'Internal Server Error' });
    }
  });





// Add this before module.exports
// 1. Insert or get Stage
router.post('/stage', async (req, res) => {
    const { stage_code } = req.body;
    try {
        const stage = await getOrInsertStage(stage_code);
        res.json({ stage_id: stage.stage_id });
    } catch (err) {
        res.status(500).json({ error: 'Stage insert error' });
    }
});

// 2. Insert Timing
router.post('/timing', async (req, res) => {
    try {
        await insertTiming(req.body);
        res.json({ message: 'Timing inserted' });
    } catch (err) {
        res.status(500).json({ error: 'Timing insert error' });
    }
});

// 3. Insert Observation
router.post('/observation', async (req, res) => {
    try {
        await insertObservation(req.body);
        res.json({ message: 'Observation inserted' });
    } catch (err) {
        res.status(500).json({ error: 'Observation insert error' });
    }
});

// 4. Insert Measurement
router.post('/measurement', async (req, res) => {
    try {
        await insertMeasurement(req.body);
        res.json({ message: 'Measurement inserted' });
    } catch (err) {
        res.status(500).json({ error: 'Measurement insert error' });
    }
});


// router.get('/lifecycle/table/N-L1', async (req, res) => {
//     try {
//         const stageQuery = `
//             SELECT stage_id, stage_code, stage_name 
//             FROM stage 
//             WHERE stage_code LIKE 'N-L1-%' 
//             ORDER BY stage_id;
//         `;
//         const stageResults = await pool.query(stageQuery);

//         let tableHtml = `<!DOCTYPE html>
// <html lang="en">
// <head>
//     <meta charset="UTF-8">
//     <meta name="viewport" content="width=device-width, initial-scale=1.0">
//     <title>N-L1 Stages Table</title>
//     <style>
//         table { width: 100%; border-collapse: collapse; }
//         th, td { border: 1px solid #ddd; padding: 8px; vertical-align: top; }
//         th { background-color: #f4f4f4; }
//         tr:nth-child(even) { background-color: #f9f9f9; }
//         td a { text-decoration: none; color: blue; }
//     </style>
// </head>
// <body>
//     <h2>N-L1 Stages Overview (With API Links)</h2>
//     <table>
//         <thead>
//             <tr>
//                 <th>Stage Code</th>
//                 <th>Stage Name</th>
//                 <th>Timing</th>
//                 <th>Observations</th>
//                 <th>Key Measurements</th>
//             </tr>
//         </thead>
//         <tbody>`;

//         for (const stage of stageResults.rows) {
//             tableHtml += `<tr>
//                 <td>${stage.stage_code}</td>
//                 <td>${stage.stage_name}</td>
//                 <td><a href="/api/stage/${stage.stage_code}/timing" target="_blank">View Timing</a></td>
//                 <td><a href="/api/stage/${stage.stage_code}/observation" target="_blank">View Observations</a></td>
//                 <td><a href="/api/stage/${stage.stage_code}/keymeasurement" target="_blank">View Key Measurements</a></td>
//             </tr>`;
//         }

//         tableHtml += '</tbody></table>\n</body>\n</html>';

//         res.send(tableHtml);

//     } catch (err) {
//         console.error(err);
//         res.status(500).send('Internal Server Error');
//     }
// });

module.exports = router;
