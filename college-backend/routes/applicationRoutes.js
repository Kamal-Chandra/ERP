const express = require('express');
const router = express.Router();
const applicationController = require('../controllers/applicationController');

router.post('/', applicationController.submitApplication);

module.exports = router;
