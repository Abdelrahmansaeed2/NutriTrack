const analyticsService = require('../services/analytics.service');
const userService = require('../services/user.service');

const getDashboardStats = async (req, res, next) => {
  try {
    const uid = req.user.uid;
    
    const userProfile = await userService.getUserProfile(uid);
    if (!userProfile) {
      return res.status(404).json({ error: 'User profile not found' });
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
    const userProfile = await userService.getUserProfile(uid);
    if (!userProfile) {
      return res.status(404).json({ error: 'User profile not found' });
    }
    const stats = await analyticsService.getDashboardStats(uid, userProfile);
    
    // Simplistic export logic, generating a JSON download.
    // In a real app this could be converted to CSV using something like json2csv
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
