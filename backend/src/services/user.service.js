const { db } = require('../config/firebase.config');

// Calculate BMR using Mifflin-St Jeor Equation
const calculateBMR = (weightKg, heightCm, age, sex) => {
  let bmr = (10 * weightKg) + (6.25 * heightCm) - (5 * age);
  bmr += (sex === 'Male') ? 5 : -161;
  return bmr;
};

// Calculate Targets based on BMR and Activity Level
const calculateTargets = (bmr, activityLevel, weightKg, targetWeightKg) => {
  // Activity Multiplier
  let multiplier = 1.2; // Sedentary
  if (activityLevel === 'Active') multiplier = 1.55;
  if (activityLevel === 'Athlete') multiplier = 1.9;

  let tdee = bmr * multiplier;
  
  // Adjust for target weight
  let dailyCalories = tdee;
  if (targetWeightKg < weightKg) {
    dailyCalories -= 500; // Weight loss
  } else if (targetWeightKg > weightKg) {
    dailyCalories += 500; // Weight gain
  }

  // Basic Macro Split (30% Protein, 40% Carbs, 30% Fat)
  const proteinGrams = (dailyCalories * 0.3) / 4;
  const carbsGrams = (dailyCalories * 0.4) / 4;
  const fatGrams = (dailyCalories * 0.3) / 9;

  return {
    dailyCalories: Math.round(dailyCalories),
    proteinGrams: Math.round(proteinGrams),
    carbsGrams: Math.round(carbsGrams),
    fatGrams: Math.round(fatGrams)
  };
};

const onboardUser = async (uid, email, data) => {
  const bmr = calculateBMR(data.weightKg, data.heightCm, data.age, data.biologicalSex);
  const targets = calculateTargets(bmr, data.activityLevel, data.weightKg, data.targetWeightKg);

  const userDoc = {
    email: email || '',
    name: data.name || '',
    bio: data.bio || '',
    onboarding: {
      biologicalSex: data.biologicalSex,
      age: data.age,
      heightCm: data.heightCm,
      weightKg: data.weightKg,
      targetWeightKg: data.targetWeightKg,
      activityLevel: data.activityLevel,
      bmr: Math.round(bmr)
    },
    targets,
    aiPreferences: {
      dietaryFramework: 'Standard',
      allergies: [],
      mealCadence: '3'
    },
    stats: {
      badgesEarned: 0,
      recipesCreated: 0,
      totalDaysTracked: 0
    },
    profilePictureUrl: '', // To be updated later via Storage
    settings: {
      theme: 'system',
      notifications: true
    },
    createdAt: new Date().toISOString(),
    updatedAt: new Date().toISOString()
  };

  await db.collection('users').doc(uid).set(userDoc, { merge: true });
  return userDoc;
};

const getUserProfile = async (uid) => {
  const doc = await db.collection('users').doc(uid).get();
  if (!doc.exists) {
    return null;
  }
  return doc.data();
};

const updateUserProfile = async (uid, updateData) => {
  const userRef = db.collection('users').doc(uid);
  updateData.updatedAt = new Date().toISOString();
  await userRef.set(updateData, { merge: true });
  return getUserProfile(uid);
};

module.exports = {
  calculateBMR,
  calculateTargets,
  onboardUser,
  getUserProfile,
  updateUserProfile
};
