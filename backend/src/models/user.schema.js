const Joi = require('joi');

const onboardingSchema = Joi.object({
  name: Joi.string().optional(),
  bio: Joi.string().optional(),
  biologicalSex: Joi.string().valid('Male', 'Female').required(),
  age: Joi.number().integer().min(10).max(120).required(),
  heightCm: Joi.number().min(50).max(300).required(),
  weightKg: Joi.number().min(20).max(500).required(),
  targetWeightKg: Joi.number().min(20).max(500).required(),
  activityLevel: Joi.string().valid('Sedentary', 'Active', 'Athlete').required()
});

module.exports = {
  onboardingSchema
};
