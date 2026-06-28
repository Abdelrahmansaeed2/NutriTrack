const express = require('express');
const router = express.Router();
const analyticsController = require('../controllers/analytics.controller');
const { verifyToken } = require('../middlewares/auth.middleware');

router.use(verifyToken);

router.get('/dashboard', analyticsController.getDashboardStats);
router.get('/export', analyticsController.exportData);

module.exports = router;
