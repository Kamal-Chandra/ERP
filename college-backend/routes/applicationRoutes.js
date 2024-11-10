const express = require('express');
const { addApplication, updateApplicationStatus } = require('../controllers/applicationController');

const router = express.Router();
router.post('/apply', addApplication);
router.put('/update-status', updateApplicationStatus);

module.exports = router;
