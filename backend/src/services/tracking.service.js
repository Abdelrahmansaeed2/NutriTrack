const { db, admin } = require('../config/firebase.config');

const getDailyLog = async (uid, date) => {
  const docId = `${uid}_${date}`;
  const docRef = db.collection('dailyLogs').doc(docId);
  const doc = await docRef.get();
  
  // Fetch user targets to include in dashboard stats
  const userDoc = await db.collection('users').doc(uid).get();
  const targets = userDoc.exists && userDoc.data().targets 
    ? userDoc.data().targets 
    : { dailyCalories: 2000, proteinGrams: 150, carbsGrams: 200, fatGrams: 70 };

  if (!doc.exists) {
    // Return empty template with targets
    return {
      userId: uid,
      date: date,
      targets,
      totals: { calories: 0, protein: 0, carbs: 0, fat: 0 },
      meals: {
        breakfast: [],
        lunch: [],
        dinner: [],
        snacks: []
      },
      waterIntake: {
        totalMl: 0,
        goalMl: 3000,
        logs: []
      }
    };
  }
  
  const logData = doc.data();
  logData.targets = targets;
  return logData;
};

const addMealItem = async (uid, date, mealType, item) => {
  const docId = `${uid}_${date}`;
  const docRef = db.collection('dailyLogs').doc(docId);
  
  const doc = await docRef.get();
  
  const updateData = {
    [`meals.${mealType}`]: admin.firestore.FieldValue.arrayUnion(item),
    'totals.calories': admin.firestore.FieldValue.increment(item.calories),
    'totals.protein': admin.firestore.FieldValue.increment(item.macros.protein),
    'totals.carbs': admin.firestore.FieldValue.increment(item.macros.carbs),
    'totals.fat': admin.firestore.FieldValue.increment(item.macros.fat)
  };

  if (!doc.exists) {
    // Create new document with template + new item
    const newDoc = {
      userId: uid,
      date: date,
      totals: {
        calories: item.calories,
        protein: item.macros.protein,
        carbs: item.macros.carbs,
        fat: item.macros.fat
      },
      meals: {
        breakfast: mealType === 'breakfast' ? [item] : [],
        lunch: mealType === 'lunch' ? [item] : [],
        dinner: mealType === 'dinner' ? [item] : [],
        snacks: mealType === 'snacks' ? [item] : []
      },
      waterIntake: { totalMl: 0, goalMl: 3000, logs: [] }
    };
    await docRef.set(newDoc);
    
    // Increment totalDaysTracked in user profile
    await db.collection('users').doc(uid).update({
      'stats.totalDaysTracked': admin.firestore.FieldValue.increment(1)
    }).catch(err => console.warn('Failed to update totalDaysTracked:', err.message));
  } else {
    await docRef.update(updateData);
  }

  return getDailyLog(uid, date);
};

const addWaterIntake = async (uid, date, amountMl, type) => {
  const docId = `${uid}_${date}`;
  const docRef = db.collection('dailyLogs').doc(docId);
  
  const waterLog = {
    amountMl,
    type,
    timestamp: new Date().toISOString()
  };

  const updateData = {
    'waterIntake.totalMl': admin.firestore.FieldValue.increment(amountMl),
    'waterIntake.logs': admin.firestore.FieldValue.arrayUnion(waterLog)
  };

  const doc = await docRef.get();
  if (!doc.exists) {
    await docRef.set({
      userId: uid,
      date: date,
      totals: { calories: 0, protein: 0, carbs: 0, fat: 0 },
      meals: { breakfast: [], lunch: [], dinner: [], snacks: [] },
      waterIntake: { totalMl: amountMl, goalMl: 3000, logs: [waterLog] }
    });
    
    // Increment totalDaysTracked in user profile
    await db.collection('users').doc(uid).update({
      'stats.totalDaysTracked': admin.firestore.FieldValue.increment(1)
    }).catch(err => console.warn('Failed to update totalDaysTracked:', err.message));
  } else {
    await docRef.update(updateData);
  }

  return getDailyLog(uid, date);
};

const removeMealItem = async (uid, date, mealType, index) => {
  const docId = `${uid}_${date}`;
  const docRef = db.collection('dailyLogs').doc(docId);
  const doc = await docRef.get();
  
  if (!doc.exists) return null;
  const data = doc.data();
  const mealArray = data.meals?.[mealType] || [];
  
  if (index < 0 || index >= mealArray.length) {
    throw new Error('Invalid meal index');
  }

  const item = mealArray[index];
  mealArray.splice(index, 1);

  await docRef.update({
    [`meals.${mealType}`]: mealArray,
    'totals.calories': admin.firestore.FieldValue.increment(-item.calories),
    'totals.protein': admin.firestore.FieldValue.increment(-item.macros.protein),
    'totals.carbs': admin.firestore.FieldValue.increment(-item.macros.carbs),
    'totals.fat': admin.firestore.FieldValue.increment(-item.macros.fat)
  });

  return getDailyLog(uid, date);
};

const removeWaterIntake = async (uid, date, index) => {
  const docId = `${uid}_${date}`;
  const docRef = db.collection('dailyLogs').doc(docId);
  const doc = await docRef.get();
  
  if (!doc.exists) return null;
  const data = doc.data();
  const waterLogs = data.waterIntake?.logs || [];
  
  if (index < 0 || index >= waterLogs.length) {
    throw new Error('Invalid water index');
  }

  const item = waterLogs[index];
  waterLogs.splice(index, 1);

  await docRef.update({
    'waterIntake.logs': waterLogs,
    'waterIntake.totalMl': admin.firestore.FieldValue.increment(-item.amountMl)
  });

  return getDailyLog(uid, date);
};



const logWeight = async (uid, date, weightKg) => {
  const docId = `${uid}_${date}`;
  const docRef = db.collection('dailyLogs').doc(docId);
  
  const doc = await docRef.get();
  if (!doc.exists) {
    // Increment totalDaysTracked in user profile
    await db.collection('users').doc(uid).update({
      'stats.totalDaysTracked': admin.firestore.FieldValue.increment(1)
    }).catch(err => console.warn('Failed to update totalDaysTracked:', err.message));
  }

  await docRef.set({
    weightKg: weightKg,
    userId: uid,
    date: date
  }, { merge: true });

  // Update latest weight in user profile as well
  await db.collection('users').doc(uid).update({ 'latestWeight': weightKg });

  return getDailyLog(uid, date);
};

const getGroceryLists = async (uid) => {
  const snapshot = await db.collection('groceryLists')
    .where('userId', '==', uid)
    .orderBy('createdAt', 'desc')
    .get();
  return snapshot.docs.map(doc => doc.data());
};

const getGroceryListById = async (uid, listId) => {
  let doc;
  if (listId === 'latest') {
    const snapshot = await db.collection('groceryLists')
      .where('userId', '==', uid)
      .orderBy('createdAt', 'desc')
      .limit(1)
      .get();
    if (snapshot.empty) return null;
    doc = snapshot.docs[0];
  } else {
    doc = await db.collection('groceryLists').doc(listId).get();
  }
  if (!doc.exists || doc.data().userId !== uid) return null;
  return doc.data();
};

const updateGroceryItem = async (uid, listId, itemName, isChecked) => {
  let listRef;
  let doc;
  if (listId === 'latest') {
    const snapshot = await db.collection('groceryLists')
      .where('userId', '==', uid)
      .orderBy('createdAt', 'desc')
      .limit(1)
      .get();
    if (snapshot.empty) return null;
    listRef = db.collection('groceryLists').doc(snapshot.docs[0].id);
    doc = await listRef.get();
  } else {
    listRef = db.collection('groceryLists').doc(listId);
    doc = await listRef.get();
  }
  if (!doc.exists || doc.data().userId !== uid) return null;

  const items = doc.data().items || [];
  const updatedItems = items.map(item => {
    if (item.name.toLowerCase() === itemName.toLowerCase()) {
      return { ...item, isChecked };
    }
    return item;
  });

  await listRef.update({ items: updatedItems });
  return updatedItems;
};

const addGroceryItem = async (uid, listId, itemName, quantity, category) => {
  let listRef;
  let doc;
  
  if (listId === 'latest' || !listId) {
    const snapshot = await db.collection('groceryLists')
      .where('userId', '==', uid)
      .orderBy('createdAt', 'desc')
      .limit(1)
      .get();
      
    if (!snapshot.empty) {
      listRef = db.collection('groceryLists').doc(snapshot.docs[0].id);
      doc = await listRef.get();
    }
  } else {
    listRef = db.collection('groceryLists').doc(listId);
    doc = await listRef.get();
  }

  // If no list exists yet, create one automatically
  if (!doc || !doc.exists || doc.data().userId !== uid) {
    listRef = db.collection('groceryLists').doc();
    const newList = {
      id: listRef.id,
      userId: uid,
      weekOf: new Date().toISOString().split('T')[0],
      planId: 'manual',
      items: [],
      createdAt: new Date().toISOString()
    };
    await listRef.set(newList);
    doc = await listRef.get();
  }

  const items = doc.data().items || [];
  const newItem = {
    category: category || 'Pantry',
    name: itemName,
    quantity: quantity || '1 unit',
    isChecked: false
  };

  const updatedItems = [...items, newItem];
  await listRef.update({ items: updatedItems });
  return newItem;
};

const clearCheckedGroceryItems = async (uid, listId) => {
  let listRef;
  let doc;
  if (listId === 'latest') {
    const snapshot = await db.collection('groceryLists')
      .where('userId', '==', uid)
      .orderBy('createdAt', 'desc')
      .limit(1)
      .get();
    if (snapshot.empty) return null;
    listRef = db.collection('groceryLists').doc(snapshot.docs[0].id);
    doc = await listRef.get();
  } else {
    listRef = db.collection('groceryLists').doc(listId);
    doc = await listRef.get();
  }
  if (!doc.exists || doc.data().userId !== uid) return null;

  const currentItems = doc.data().items || [];
  const uncheckedItems = currentItems.filter(item => !item.isChecked);

  await listRef.update({ items: uncheckedItems });
  return uncheckedItems;
};

module.exports = {
  getDailyLog,
  addMealItem,
  addWaterIntake,
  removeMealItem,
  removeWaterIntake,
  clearCheckedGroceryItems,
  logWeight,
  getGroceryLists,
  getGroceryListById,
  updateGroceryItem,
  addGroceryItem
};
