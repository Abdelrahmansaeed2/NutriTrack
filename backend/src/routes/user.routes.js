const express = require('express');
const router = express.Router();
const userController = require('../controllers/user.controller');
const { verifyToken } = require('../middlewares/auth.middleware');

// Public route
router.post('/forgot-password', userController.forgotPassword);

// Protect all following routes
router.use(verifyToken);

// GET /api/users/profile
router.get('/profile', userController.getProfile);
router.put('/profile', userController.updateProfile);

// POST /api/users/onboard
router.post('/onboard', userController.onboardUser);

// POST /api/users/sync-health
router.post('/sync-health', userController.syncHealthApps);

// POST /api/users/support
router.post('/support', userController.submitSupportTicket);

// POST /api/users/recalculate-targets
router.post('/recalculate-targets', userController.recalculateTargets);

module.exports = router;
