const express = require('express');
const router = express.Router();
const foodController = require('../controllers/food.controller');
const { verifyToken } = require('../middlewares/auth.middleware');

router.use(verifyToken);

router.get('/search', foodController.getFoods);

// Favorites Routes
router.get('/favorites', foodController.getFavorites);
router.post('/favorites/:id', foodController.addFavorite);
router.delete('/favorites/:id', foodController.removeFavorite);

// Custom Food
router.post('/custom', foodController.createCustomFood);

// GET /api/foods/:id
router.get('/:id', foodController.getFoodById);

// POST /api/foods/barcode
router.post('/barcode', foodController.scanBarcode);

module.exports = router;
