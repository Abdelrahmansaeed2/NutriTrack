const Joi = require('joi');

const mealItemSchema = Joi.object({
  foodId: Joi.string().required(),
  name: Joi.string().required(),
  quantity: Joi.number().required(),
  calories: Joi.number().required(),
  macros: Joi.object({
    protein: Joi.number().required(),
    carbs: Joi.number().required(),
    fat: Joi.number().required()
  }).required()
});

const logMealSchema = Joi.object({
  mealType: Joi.string().valid('breakfast', 'lunch', 'dinner', 'snacks').required(),
  item: mealItemSchema.required()
});

const logWaterSchema = Joi.object({
  amountMl: Joi.number().min(1).required(),
  type: Joi.string().required()
});

const recipeSchema = Joi.object({
  name: Joi.string().required(),
  totals: Joi.object({
    calories: Joi.number().required(),
    protein: Joi.number().required(),
    carbs: Joi.number().required(),
    fat: Joi.number().required()
  }).required(),
  ingredients: Joi.array().items(Joi.object({
    foodId: Joi.string().allow('', null).optional(),
    name: Joi.string().required(),
    quantity: Joi.string().required(),
    calories: Joi.number().required()
  })).min(1).required()
});

module.exports = {
  logMealSchema,
  logWaterSchema,
  recipeSchema
};
