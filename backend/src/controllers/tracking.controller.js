const trackingService = require('../services/tracking.service');
const { logMealSchema, logWaterSchema } = require('../models/tracking.schema');
const { db } = require('../config/firebase.config');

const getDailyLog = async (req, res, next) => {
  try {
    const { date } = req.params;
    const uid = req.user.uid;
    const log = await trackingService.getDailyLog(uid, date);
    res.status(200).json(log);
  } catch (error) {
    next(error);
  }
};

const addMealItem = async (req, res, next) => {
  try {
    const { date } = req.params;
    const { error, value } = logMealSchema.validate(req.body);
    if (error) {
      return res.status(400).json({ error: error.details[0].message });
    }

    const uid = req.user.uid;
    const updatedLog = await trackingService.addMealItem(uid, date, value.mealType, value.item);
    res.status(200).json({ message: 'Meal logged successfully', log: updatedLog });
  } catch (error) {
    next(error);
  }
};

const addWaterIntake = async (req, res, next) => {
  try {
    const { date } = req.params;
    const { error, value } = logWaterSchema.validate(req.body);
    if (error) {
      return res.status(400).json({ error: error.details[0].message });
    }

    const uid = req.user.uid;
    const updatedLog = await trackingService.addWaterIntake(uid, date, value.amountMl, value.type);
    res.status(200).json({ message: 'Water logged successfully', log: updatedLog });
  } catch (error) {
    next(error);
  }
};

const updateGroceryItem = async (req, res, next) => {
  try {
    const { listId } = req.params;
    const { itemName, isChecked } = req.body;
    const uid = req.user.uid;
    
    if (!itemName || isChecked === undefined) {
      return res.status(400).json({ error: 'itemName and isChecked are required' });
    }

    const updatedItems = await trackingService.updateGroceryItem(uid, listId, itemName, isChecked);
    if (!updatedItems) {
      return res.status(404).json({ error: 'Grocery list not found or unauthorized' });
    }

    res.status(200).json({ message: 'Grocery item updated', items: updatedItems });
  } catch (error) {
    next(error);
  }
};

const removeMealItem = async (req, res, next) => {
  try {
    const { date } = req.params;
    const uid = req.user.uid;
    const { mealType, index } = req.body; 
    
    if (index === undefined) return res.status(400).json({ error: 'index is required' });

    const updatedLog = await trackingService.removeMealItem(uid, date, mealType, index);
    res.status(200).json({ message: 'Meal item removed', log: updatedLog });
  } catch (error) {
    next(error);
  }
};

const removeWaterIntake = async (req, res, next) => {
  try {
    const { date } = req.params;
    const uid = req.user.uid;
    const { index } = req.body;
    
    if (index === undefined) return res.status(400).json({ error: 'index is required' });

    const updatedLog = await trackingService.removeWaterIntake(uid, date, index);
    res.status(200).json({ message: 'Water log removed', log: updatedLog });
  } catch (error) {
    next(error);
  }
};

const clearCheckedGroceryItems = async (req, res, next) => {
  try {
    const { listId } = req.params;
    const uid = req.user.uid;
    const remainingItems = await trackingService.clearCheckedGroceryItems(uid, listId);
    if (!remainingItems) {
      return res.status(404).json({ error: 'Grocery list not found or unauthorized' });
    }
    res.status(200).json({ message: 'Checked items cleared', items: remainingItems });
  } catch (error) {
    next(error);
  }
};

const logWeight = async (req, res, next) => {
  try {
    const { date } = req.params;
    const uid = req.user.uid;
    const { weightKg } = req.body;
    
    if (weightKg === undefined) return res.status(400).json({ error: 'weightKg is required' });
    
    const updatedLog = await trackingService.logWeight(uid, date, weightKg);
    res.status(200).json({ message: 'Weight logged successfully', log: updatedLog });
  } catch (error) {
    next(error);
  }
};

const addGroceryItem = async (req, res, next) => {
  try {
    const { listId } = req.params;
    const { itemName, quantity } = req.body;
    const uid = req.user.uid;
    
    if (!itemName) return res.status(400).json({ error: 'itemName is required' });

    const newItem = await trackingService.addGroceryItem(uid, listId, itemName, quantity);
    if (!newItem) {
      return res.status(404).json({ error: 'Grocery list not found or unauthorized' });
    }

    res.status(200).json({ message: 'Manual item added to grocery list', item: newItem });
  } catch (error) {
    next(error);
  }
};

const getGroceryLists = async (req, res, next) => {
  try {
    const uid = req.user.uid;
    const lists = await trackingService.getGroceryLists(uid);
    res.status(200).json(lists);
  } catch (error) {
    next(error);
  }
};

const getGroceryListById = async (req, res, next) => {
  try {
    const uid = req.user.uid;
    const { listId } = req.params;
    const list = await trackingService.getGroceryListById(uid, listId);
    if (!list) return res.status(404).json({ error: 'Grocery list not found' });
    res.status(200).json(list);
  } catch (error) {
    next(error);
  }
};

const logFasting = async (req, res, next) => {
  try {
    const uid = req.user.uid;
    const { startTime, endTime } = req.body;
    if (!startTime) return res.status(400).json({ error: 'startTime is required' });
    
    // In full implementation, save to a 'fastingLogs' collection
    res.status(201).json({ message: 'Fasting window logged', fasting: { startTime, endTime, durationHours: 16 } });
  } catch (error) {
    next(error);
  }
};

const uploadProgressPhoto = async (req, res, next) => {
  try {
    const uid = req.user.uid;
    const { date } = req.params;
    const { photoUrl } = req.body;
    if (!photoUrl) return res.status(400).json({ error: 'photoUrl is required' });

    // Save progress photo to daily logs in Firestore
    await db.collection('dailyLogs').doc(`${uid}_${date}`).set({
      progressPhotoUrl: photoUrl
    }, { merge: true });

    res.status(200).json({ message: 'Progress photo saved', photoUrl, date });
  } catch (error) {
    next(error);
  }
};

module.exports = {
  getDailyLog,
  addMealItem,
  addWaterIntake,
  updateGroceryItem,
  removeMealItem,
  removeWaterIntake,
  clearCheckedGroceryItems,
  logWeight,
  addGroceryItem,
  getGroceryLists,
  getGroceryListById,
  logFasting,
  uploadProgressPhoto
};
