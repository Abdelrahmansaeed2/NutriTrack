const express = require('express');
const router = express.Router();
const aiController = require('../controllers/ai.controller');
const { verifyToken } = require('../middlewares/auth.middleware');

router.use(verifyToken);

router.post('/generate-weekly-plan', aiController.generateWeeklyPlan);
router.post('/generate-grocery-list', aiController.generateGroceryList);
router.post('/swap-meal', aiController.swapMeal);
router.post('/recommend-meal', aiController.recommendMeal);

router.get('/weekly-plan', aiController.getWeeklyPlan);
router.get('/weekly-plan/:id', aiController.getWeeklyPlanById);

module.exports = router;
