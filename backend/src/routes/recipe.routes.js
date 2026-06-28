const express = require('express');
const router = express.Router();
const recipeController = require('../controllers/recipe.controller');
const { verifyToken } = require('../middlewares/auth.middleware');

// Protect routes
router.use(verifyToken);

// GET /api/recipes
router.get('/', recipeController.getRecipes);

// POST /api/recipes
router.post('/', recipeController.createRecipe);

// GET /api/recipes/:id
router.get('/:id', recipeController.getRecipeById);

// PUT /api/recipes/:id
router.put('/:id', recipeController.updateRecipe);

// DELETE /api/recipes/:id
router.delete('/:id', recipeController.deleteRecipe);

module.exports = router;
