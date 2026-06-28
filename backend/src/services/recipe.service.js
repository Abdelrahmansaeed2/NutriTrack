const { db } = require('../config/firebase.config');
const admin = require('firebase-admin');

const createRecipe = async (uid, recipeData) => {
  const recipeRef = db.collection('recipes').doc();
  const newRecipe = {
    id: recipeRef.id,
    userId: uid,
    name: recipeData.name,
    totals: recipeData.totals,
    ingredients: recipeData.ingredients,
    createdAt: new Date().toISOString()
  };
  
  await recipeRef.set(newRecipe);
  
  // Increment stats.recipesCreated on user profile
  try {
    await db.collection('users').doc(uid).update({
      'stats.recipesCreated': admin.firestore.FieldValue.increment(1)
    });
  } catch (err) {
    console.warn('Failed to update user recipe stats:', err.message);
  }
  
  return newRecipe;
};

const getRecipes = async (uid) => {
  const snapshot = await db.collection('recipes').where('userId', '==', uid).get();
  return snapshot.docs.map(doc => doc.data());
};

const getRecipeById = async (uid, recipeId) => {
  const doc = await db.collection('recipes').doc(recipeId).get();
  if (!doc.exists) return null;
  const data = doc.data();
  if (data.userId !== uid) return null; // Ensure user owns the recipe
  return data;
};

const updateRecipe = async (uid, recipeId, updateData) => {
  const docRef = db.collection('recipes').doc(recipeId);
  const doc = await docRef.get();
  if (!doc.exists || doc.data().userId !== uid) return null;

  await docRef.update({ ...updateData, updatedAt: new Date().toISOString() });
  const updated = await docRef.get();
  return updated.data();
};

const deleteRecipe = async (uid, recipeId) => {
  const docRef = db.collection('recipes').doc(recipeId);
  const doc = await docRef.get();
  if (!doc.exists || doc.data().userId !== uid) return false;

  await docRef.delete();
  
  // Decrement stats.recipesCreated on user profile
  try {
    await db.collection('users').doc(uid).update({
      'stats.recipesCreated': admin.firestore.FieldValue.increment(-1)
    });
  } catch (err) {
    console.warn('Failed to update user recipe stats:', err.message);
  }
  
  return true;
};

module.exports = {
  createRecipe,
  getRecipes,
  getRecipeById,
  updateRecipe,
  deleteRecipe
};
