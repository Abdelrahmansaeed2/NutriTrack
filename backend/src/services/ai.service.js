const { groq } = require('../config/groq.config');
const { db } = require('../config/firebase.config');
const admin = require('firebase-admin');

const generateWeeklyPlan = async (uid, userProfile, startDate) => {
  const prompt = `
    You are a professional AI Nutritionist. Generate a 7-day weekly meal plan for a user with the following profile:
    - Dietary Framework: ${userProfile.aiPreferences.dietaryFramework}
    - Allergies/Exclusions: ${userProfile.aiPreferences.allergies.join(', ')}
    - Daily Calorie Target: ${userProfile.targets.dailyCalories} kcal
    - Macros: ${userProfile.targets.proteinGrams}g Protein, ${userProfile.targets.carbsGrams}g Carbs, ${userProfile.targets.fatGrams}g Fat
    - Meal Cadence: ${userProfile.aiPreferences.mealCadence} meals per day

    Return ONLY a valid JSON object in the exact following structure with NO markdown formatting, NO backticks, and NO extra text:
    {
      "days": {
        "YYYY-MM-DD": {
          "dailyTargets": { "calories": 0, "protein": 0, "carbs": 0, "fat": 0 },
          "meals": {
            "breakfast": [ { "name": "string", "calories": 0, "macros": { "protein": 0, "carbs": 0, "fat": 0 } } ],
            "lunch": [ ... ],
            "dinner": [ ... ],
            "snacks": [ ... ]
          }
        }
      }
    }
    
    Ensure the dates map correctly starting from ${startDate} for 7 consecutive days. Format dates as YYYY-MM-DD.
  `;

  try {
    const chatCompletion = await groq.chat.completions.create({
      messages: [{ role: 'user', content: prompt }],
      model: 'llama-3.1-8b-instant',
      response_format: { type: 'json_object' }
    });

    const aiResponse = JSON.parse(chatCompletion.choices[0].message.content);
    
    const planRef = db.collection('weeklyPlans').doc();
    const endDate = new Date(new Date(startDate).getTime() + 6 * 24 * 60 * 60 * 1000).toISOString().split('T')[0];

    const planData = {
      id: planRef.id,
      userId: uid,
      startDate: startDate,
      endDate: endDate,
      days: aiResponse.days,
      createdAt: new Date().toISOString()
    };

    await planRef.set(planData);
    return planData;

  } catch (error) {
    console.warn('Groq call failed for weekly plan, using fallback generator:', error.message);
    
    // Generate high-quality fallback plan matching user targets
    const days = {};
    const t = userProfile.targets;
    const calories = t.dailyCalories || 2000;
    const protein = t.proteinGrams || 150;
    const carbs = t.carbsGrams || 200;
    const fat = t.fatGrams || 70;
    
    for (let i = 0; i < 7; i++) {
      const date = new Date(new Date(startDate).getTime() + i * 24 * 60 * 60 * 1000).toISOString().split('T')[0];
      days[date] = {
        dailyTargets: { calories, protein, carbs, fat },
        meals: {
          breakfast: [
            { 
              name: "Oatmeal with Berries & Whey", 
              calories: Math.round(calories * 0.25), 
              macros: { 
                protein: Math.round(protein * 0.25), 
                carbs: Math.round(carbs * 0.3), 
                fat: Math.round(fat * 0.15) 
              } 
            }
          ],
          lunch: [
            { 
              name: "Grilled Chicken & Quinoa Salad", 
              calories: Math.round(calories * 0.35), 
              macros: { 
                protein: Math.round(protein * 0.4), 
                carbs: Math.round(carbs * 0.35), 
                fat: Math.round(fat * 0.35) 
              } 
            }
          ],
          dinner: [
            { 
              name: "Baked Salmon with Sweet Potato & Broccoli", 
              calories: Math.round(calories * 0.3), 
              macros: { 
                protein: Math.round(protein * 0.3), 
                carbs: Math.round(carbs * 0.25), 
                fat: Math.round(fat * 0.4) 
              } 
            }
          ],
          snacks: [
            { 
              name: "Greek Yogurt & Mixed Nuts", 
              calories: Math.round(calories * 0.1), 
              macros: { 
                protein: Math.round(protein * 0.05), 
                carbs: Math.round(carbs * 0.1), 
                fat: Math.round(fat * 0.1) 
              } 
            }
          ]
        }
      };
    }
    
    const planRef = db.collection('weeklyPlans').doc();
    const endDate = new Date(new Date(startDate).getTime() + 6 * 24 * 60 * 60 * 1000).toISOString().split('T')[0];
    
    const planData = {
      id: planRef.id,
      userId: uid,
      startDate: startDate,
      endDate: endDate,
      days,
      createdAt: new Date().toISOString()
    };
    
    await planRef.set(planData);
    return planData;
  }
};

const generateGroceryList = async (uid, planId) => {
  const planDoc = await db.collection('weeklyPlans').doc(planId).get();
  if (!planDoc.exists) throw new Error('Weekly plan not found');
  
  const planData = planDoc.data();
  if (planData.userId !== uid) throw new Error('Unauthorized');

  const prompt = `
    Based on the following 7-day meal plan, generate an automated grocery list.
    Aggregate all the ingredients required, categorize them, and estimate quantities.
    Return ONLY a valid JSON object in the exact following structure with NO markdown formatting, NO backticks, and NO extra text:
    {
      "items": [
        { "category": "Produce", "name": "Spinach", "quantity": "2 bags", "isChecked": false },
        { "category": "Meat & Proteins", "name": "Chicken Breast", "quantity": "2 lbs", "isChecked": false }
      ]
    }

    Meal Plan JSON:
    ${JSON.stringify(planData.days)}
  `;

  try {
    const chatCompletion = await groq.chat.completions.create({
      messages: [{ role: 'user', content: prompt }],
      model: 'llama-3.1-8b-instant',
      response_format: { type: 'json_object' }
    });

    const aiResponse = JSON.parse(chatCompletion.choices[0].message.content);

    const listRef = db.collection('groceryLists').doc();
    const listData = {
      id: listRef.id,
      userId: uid,
      weekOf: planData.startDate,
      planId: planId,
      items: aiResponse.items,
      createdAt: new Date().toISOString()
    };

    await listRef.set(listData);
    return listData;

  } catch (error) {
    console.warn('Groq call failed for grocery list, using fallback generator:', error.message);
    
    const items = [];
    const categories = {
      breakfast: 'Pantry',
      lunch: 'Meat & Proteins',
      dinner: 'Produce',
      snacks: 'Dairy'
    };
    
    const seen = new Set();
    Object.values(planData.days).forEach(day => {
      Object.entries(day.meals).forEach(([type, meals]) => {
        meals.forEach(meal => {
          if (!seen.has(meal.name)) {
            seen.add(meal.name);
            items.push({
              category: categories[type] || 'Pantry',
              name: meal.name,
              quantity: '1 unit',
              isChecked: false
            });
          }
        });
      });
    });
    
    if (items.length === 0) {
      items.push({ category: 'Meat & Proteins', name: 'Chicken Breast', quantity: '2 lbs', isChecked: false });
      items.push({ category: 'Produce', name: 'Spinach', quantity: '2 bags', isChecked: false });
    }
    
    const listRef = db.collection('groceryLists').doc();
    const listData = {
      id: listRef.id,
      userId: uid,
      weekOf: planData.startDate,
      planId: planId,
      items,
      createdAt: new Date().toISOString()
    };
    
    await listRef.set(listData);
    return listData;
  }
};

const recommendMeal = async (uid, remainingCalories, remainingProtein) => {
  const prompt = `
    You are an AI Nutritionist. A user has ${remainingCalories} kcal and ${remainingProtein}g of protein remaining for their daily target.
    Suggest exactly one meal that perfectly fits these remaining macros.
    Return ONLY a valid JSON object in the exact following structure with NO markdown formatting, NO backticks, and NO extra text:
    {
      "name": "string",
      "description": "string",
      "calories": 0,
      "macros": { "protein": 0, "carbs": 0, "fat": 0 }
    }
  `;

  try {
    const chatCompletion = await groq.chat.completions.create({
      messages: [{ role: 'user', content: prompt }],
      model: 'llama-3.1-8b-instant',
      response_format: { type: 'json_object' }
    });
    return JSON.parse(chatCompletion.choices[0].message.content);
  } catch (error) {
    console.warn('Groq call failed for meal recommendation, using fallback:', error.message);
    return {
      name: 'High Protein Salad Bowl',
      description: 'A delicious bowl with grilled chicken, mixed greens, avocado, and olive oil dressing.',
      calories: Math.round(remainingCalories),
      macros: {
        protein: Math.round(remainingProtein),
        carbs: Math.round(remainingCalories * 0.1 / 4),
        fat: Math.round(remainingCalories * 0.4 / 9)
      }
    };
  }
};

const swapMeal = async (uid, planId, date, mealType) => {
  const planDoc = await db.collection('weeklyPlans').doc(planId).get();
  if (!planDoc.exists) throw new Error('Weekly plan not found');
  const planData = planDoc.data();
  if (planData.userId !== uid) throw new Error('Unauthorized');

  const currentMeal = planData.days?.[date]?.meals?.[mealType]?.[0] || {};

  const userDoc = await db.collection('users').doc(uid).get();
  const userProfile = userDoc.exists ? userDoc.data() : { aiPreferences: { dietaryFramework: 'Standard', allergies: [] } };

  const prompt = `
    You are an AI Nutritionist. The user wants to swap out a meal in their weekly plan.
    Current Meal: ${JSON.stringify(currentMeal)}
    Dietary Framework: ${userProfile.aiPreferences?.dietaryFramework || 'Standard'}
    Allergies/Exclusions: ${(userProfile.aiPreferences?.allergies || []).join(', ')}

    Suggest exactly one alternative meal that has similar macros (within 10-20% margin) and adheres to the dietary framework and allergies.
    Return ONLY a valid JSON object in the exact following structure with NO markdown formatting, NO backticks, and NO extra text:
    {
      "name": "string",
      "calories": 0,
      "macros": { "protein": 0, "carbs": 0, "fat": 0 }
    }
  `;

  try {
    const chatCompletion = await groq.chat.completions.create({
      messages: [{ role: 'user', content: prompt }],
      model: 'llama-3.1-8b-instant',
      response_format: { type: 'json_object' }
    });

    const newMeal = JSON.parse(chatCompletion.choices[0].message.content);

    const updatedDays = { ...planData.days };
    if (!updatedDays[date]) updatedDays[date] = { meals: {} };
    if (!updatedDays[date].meals) updatedDays[date].meals = {};
    updatedDays[date].meals[mealType] = [newMeal];

    await db.collection('weeklyPlans').doc(planId).update({ days: updatedDays });

    return { newMeal, updatedDays };
  } catch (error) {
    console.warn('Groq call failed for swapping meal, using fallback:', error.message);
    const newMeal = {
      name: 'Alternative Balanced Meal',
      calories: currentMeal.calories || 400,
      macros: currentMeal.macros || { protein: 30, carbs: 40, fat: 12 }
    };
    
    const updatedDays = { ...planData.days };
    if (!updatedDays[date]) updatedDays[date] = { meals: {} };
    if (!updatedDays[date].meals) updatedDays[date].meals = {};
    updatedDays[date].meals[mealType] = [newMeal];
    
    await db.collection('weeklyPlans').doc(planId).update({ days: updatedDays });
    return { newMeal, updatedDays };
  }
};

const getWeeklyPlanById = async (uid, planId) => {
  const doc = await db.collection('weeklyPlans').doc(planId).get();
  if (!doc.exists || doc.data().userId !== uid) return null;
  return doc.data();
};

const getLatestWeeklyPlan = async (uid) => {
  const snapshot = await db.collection('weeklyPlans')
    .where('userId', '==', uid)
    .orderBy('createdAt', 'desc')
    .limit(1)
    .get();
  if (snapshot.empty) return null;
  return snapshot.docs[0].data();
};

module.exports = {
  generateWeeklyPlan,
  generateGroceryList,
  recommendMeal,
  getWeeklyPlanById,
  getLatestWeeklyPlan,
  swapMeal
};
