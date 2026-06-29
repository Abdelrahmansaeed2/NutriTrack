const aiService = require('../services/ai.service');
const userService = require('../services/user.service');

const generateWeeklyPlan = async (req, res, next) => {
  try {
    const uid = req.user.uid;
    const { startDate } = req.body;
    
    const targetStartDate = startDate || new Date().toISOString().split('T')[0];

    let userProfile = await userService.getUserProfile(uid);
    if (!userProfile) {
      userProfile = {
        aiPreferences: { dietaryFramework: 'Standard', allergies: [] },
        targets: { dailyCalories: 2000, proteinGrams: 150, carbsGrams: 200, fatGrams: 70 }
      };
    }

    const plan = await aiService.generateWeeklyPlan(uid, userProfile, targetStartDate);
    res.status(201).json({ message: 'Weekly plan generated successfully', plan });
  } catch (error) {
    next(error);
  }
};

const generateGroceryList = async (req, res, next) => {
  try {
    const { planId } = req.body;
    const uid = req.user.uid;

    let targetPlanId = planId;
    if (!targetPlanId) {
      const latestPlan = await aiService.getLatestWeeklyPlan(uid);
      if (latestPlan) {
        targetPlanId = latestPlan.id;
      } else {
        // Automatically generate a weekly plan first
        const today = new Date().toISOString().split('T')[0];
        let userProfile = await userService.getUserProfile(uid);
        if (!userProfile) {
          userProfile = {
            aiPreferences: { dietaryFramework: 'Standard', allergies: [] },
            targets: { dailyCalories: 2000, proteinGrams: 150, carbsGrams: 200, fatGrams: 70 }
          };
        }
        const newPlan = await aiService.generateWeeklyPlan(uid, userProfile, today);
        targetPlanId = newPlan.id;
      }
    }

    const groceryList = await aiService.generateGroceryList(uid, targetPlanId);
    res.status(200).json({ message: 'Grocery list generated', list: groceryList });
  } catch (error) {
    if (error.message === 'Weekly plan not found' || error.message === 'Unauthorized') {
      return res.status(404).json({ error: error.message });
    }
    next(error);
  }
};

const swapMeal = async (req, res, next) => {
  try {
    const uid = req.user.uid;
    const { planId, date, mealType } = req.body;
    
    if (!planId || !date || !mealType) {
      return res.status(400).json({ error: 'planId, date, and mealType are required' });
    }

    const result = await aiService.swapMeal(uid, planId, date, mealType);
    res.status(200).json({ 
      message: 'Meal swapped successfully', 
      swappedMeal: result.newMeal,
      updatedDays: result.updatedDays
    });
  } catch (error) {
    next(error);
  }
};

const recommendMeal = async (req, res, next) => {
  try {
    const uid = req.user.uid;
    const { remainingCalories, remainingProtein } = req.body;
    
    if (remainingCalories === undefined || remainingProtein === undefined) {
      return res.status(400).json({ error: 'remainingCalories and remainingProtein are required' });
    }

    const suggestion = await aiService.recommendMeal(uid, remainingCalories, remainingProtein);
    res.status(200).json({ message: 'Meal recommended', suggestion });
  } catch (error) {
    next(error);
  }
};

const getWeeklyPlan = async (req, res, next) => {
  try {
    const uid = req.user.uid;
    const plan = await aiService.getLatestWeeklyPlan(uid);
    if (!plan) return res.status(404).json({ error: 'No weekly plan found' });
    res.status(200).json(plan);
  } catch (error) {
    next(error);
  }
};

const getWeeklyPlanById = async (req, res, next) => {
  try {
    const uid = req.user.uid;
    const { id } = req.params;
    const plan = await aiService.getWeeklyPlanById(uid, id);
    if (!plan) return res.status(404).json({ error: 'Weekly plan not found' });
    res.status(200).json(plan);
  } catch (error) {
    next(error);
  }
};

module.exports = {
  generateWeeklyPlan,
  generateGroceryList,
  swapMeal,
  recommendMeal,
  getWeeklyPlan,
  getWeeklyPlanById
};
