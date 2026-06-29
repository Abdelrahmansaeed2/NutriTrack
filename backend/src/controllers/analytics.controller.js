const analyticsService = require('../services/analytics.service');
const userService = require('../services/user.service');

const getDashboardStats = async (req, res, next) => {
  try {
    const uid = req.user.uid;
    
    let userProfile = await userService.getUserProfile(uid);
    if (!userProfile) {
      const email = req.user.email || 'user@example.com';
      const defaultData = {
        name: email.split('@')[0],
        bio: 'Dedicated to achieving peak performance through precise nutrition.',
        biologicalSex: 'Male',
        age: 25,
        heightCm: 175,
        weightKg: 70,
        targetWeightKg: 70,
        activityLevel: 'Active'
      };
      userProfile = await userService.onboardUser(uid, email, defaultData);
    }

    const stats = await analyticsService.getDashboardStats(uid, userProfile);
    res.status(200).json(stats);
  } catch (error) {
    if (error.message && error.message.includes('FAILED_PRECONDITION')) {
      return res.status(400).json({ error: 'Database index required', details: error.message });
    }
    next(error);
  }
};

const exportData = async (req, res, next) => {
  try {
    const uid = req.user.uid;
    let userProfile = await userService.getUserProfile(uid);
    if (!userProfile) {
      const email = req.user.email || 'user@example.com';
      const defaultData = {
        name: email.split('@')[0],
        bio: 'Dedicated to achieving peak performance through precise nutrition.',
        biologicalSex: 'Male',
        age: 25,
        heightCm: 175,
        weightKg: 70,
        targetWeightKg: 70,
        activityLevel: 'Active'
      };
      userProfile = await userService.onboardUser(uid, email, defaultData);
    }
    const stats = await analyticsService.getDashboardStats(uid, userProfile);
    
    res.setHeader('Content-disposition', `attachment; filename=nutritrack_export_${new Date().toISOString().split('T')[0]}.json`);
    res.setHeader('Content-type', 'application/json');
    res.status(200).send(JSON.stringify(stats, null, 2));
  } catch (error) {
    next(error);
  }
};

module.exports = {
  getDashboardStats,
  exportData
};
