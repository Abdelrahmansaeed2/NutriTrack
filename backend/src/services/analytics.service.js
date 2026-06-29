const { db } = require('../config/firebase.config');

const getDashboardStats = async (uid, userProfile) => {
  // We want to fetch the last 30 days of logs
  const today = new Date();
  const thirtyDaysAgo = new Date(today.getTime() - 30 * 24 * 60 * 60 * 1000);
  const startDateString = thirtyDaysAgo.toISOString().split('T')[0];

  // Fetch all logs for the user and filter in-memory to avoid requiring a composite index
  const logsSnapshot = await db.collection('dailyLogs')
    .where('userId', '==', uid)
    .get();

  const logs = logsSnapshot.docs
    .map(doc => doc.data())
    .filter(log => log.date >= startDateString);

  const proteinTarget = userProfile.targets.proteinGrams || 0;
  const calorieTarget = userProfile.targets.dailyCalories || 0;

  let activeDays = logs.length;
  let proteinGoalHit = 0;
  let totalCalorieDeficit = 0;
  let weightTrend = [];

  logs.forEach(log => {
    // Protein hit?
    if (log.totals && log.totals.protein >= proteinTarget) {
      proteinGoalHit++;
    }

    // Calorie deficit calculation
    if (log.totals) {
      const consumed = log.totals.calories || 0;
      totalCalorieDeficit += (calorieTarget - consumed);
    }

    // Weight log
    if (log.weightKg) {
      weightTrend.push({ date: log.date, weightKg: log.weightKg });
    }
  });

  const avgDailyDeficit = activeDays > 0 ? Math.round(totalCalorieDeficit / activeDays) : 0;

  let totalWeightLost = 0;
  if (weightTrend.length > 0) {
    // Sort by date ascending
    weightTrend.sort((a, b) => new Date(a.date) - new Date(b.date));
    const latestWeight = weightTrend[weightTrend.length - 1].weightKg;
    const initialWeight = userProfile.onboarding.weightKg;
    totalWeightLost = parseFloat((initialWeight - latestWeight).toFixed(1));
  }

  return {
    activeDays,
    proteinGoalHit,
    avgDailyDeficit,
    totalWeightLost,
    weightTrend
  };
};

module.exports = {
  getDashboardStats
};
