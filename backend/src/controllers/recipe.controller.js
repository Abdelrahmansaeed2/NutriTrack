const recipeService = require('../services/recipe.service');
const { recipeSchema } = require('../models/tracking.schema');

const createRecipe = async (req, res, next) => {
  try {
    const { error, value } = recipeSchema.validate(req.body);
    if (error) {
      return res.status(400).json({ error: error.details[0].message });
    }

    const uid = req.user.uid;
    const newRecipe = await recipeService.createRecipe(uid, value);
    res.status(201).json({ message: 'Recipe created successfully', recipe: newRecipe });
  } catch (error) {
    next(error);
  }
};

const getRecipes = async (req, res, next) => {
  try {
    const uid = req.user.uid;
    const recipes = await recipeService.getRecipes(uid);
    res.status(200).json(recipes);
  } catch (error) {
    next(error);
  }
};

const getRecipeById = async (req, res, next) => {
  try {
    const { id } = req.params;
    const uid = req.user.uid;
    const recipe = await recipeService.getRecipeById(uid, id);
    if (!recipe) {
      return res.status(404).json({ error: 'Recipe not found' });
    }
    res.status(200).json(recipe);
  } catch (error) {
    next(error);
  }
};

const updateRecipe = async (req, res, next) => {
  try {
    const { id } = req.params;
    const uid = req.user.uid;
    const updateData = req.body;
    const updatedRecipe = await recipeService.updateRecipe(uid, id, updateData);
    if (!updatedRecipe) return res.status(404).json({ error: 'Recipe not found or unauthorized' });
    res.status(200).json(updatedRecipe);
  } catch (error) {
    next(error);
  }
};

const deleteRecipe = async (req, res, next) => {
  try {
    const { id } = req.params;
    const uid = req.user.uid;
    const success = await recipeService.deleteRecipe(uid, id);
    if (!success) return res.status(404).json({ error: 'Recipe not found or unauthorized' });
    res.status(200).json({ message: 'Recipe deleted successfully' });
  } catch (error) {
    next(error);
  }
};

module.exports = {
  createRecipe,
  getRecipes,
  getRecipeById,
  updateRecipe,
  deleteRecipe
};
