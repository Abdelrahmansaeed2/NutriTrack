const express = require('express');
const router = express.Router();
const trackingController = require('../controllers/tracking.controller');
const { verifyToken } = require('../middlewares/auth.middleware');

// Protect all routes
router.use(verifyToken);

// GET /api/tracking/daily/:date
router.get('/daily/:date', trackingController.getDailyLog);

// POST /api/tracking/daily/:date/meal
router.post('/daily/:date/meal', trackingController.addMealItem);

// POST /api/tracking/daily/:date/water
router.post('/daily/:date/water', trackingController.addWaterIntake);

// PUT /api/tracking/grocery/:listId/item
router.put('/grocery/:listId/item', trackingController.updateGroceryItem);

// DELETE /api/tracking/daily/:date/meal
router.delete('/daily/:date/meal', trackingController.removeMealItem);

// DELETE /api/tracking/daily/:date/water
router.delete('/daily/:date/water', trackingController.removeWaterIntake);

// DELETE /api/tracking/grocery/:listId/checked
router.delete('/grocery/:listId/checked', trackingController.clearCheckedGroceryItems);

// POST /api/tracking/daily/:date/weight
router.post('/daily/:date/weight', trackingController.logWeight);

// POST /api/tracking/grocery/:listId/item
router.post('/grocery/:listId/item', trackingController.addGroceryItem);

// GET /api/tracking/grocery
router.get('/grocery', trackingController.getGroceryLists);

// GET /api/tracking/grocery/:listId
router.get('/grocery/:listId', trackingController.getGroceryListById);

// POST /api/tracking/fasting
router.post('/fasting', trackingController.logFasting);

// POST /api/tracking/daily/:date/photo
router.post('/daily/:date/photo', trackingController.uploadProgressPhoto);

module.exports = router;
