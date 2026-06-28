const userService = require('../services/user.service');
const { onboardingSchema } = require('../models/user.schema');

const getProfile = async (req, res, next) => {
  try {
    const uid = req.user.uid;
    const profile = await userService.getUserProfile(uid);
    if (!profile) {
      return res.status(404).json({ error: 'User profile not found. Please complete onboarding.' });
    }
    res.status(200).json(profile);
  } catch (error) {
    next(error);
  }
};

const onboardUser = async (req, res, next) => {
  try {
    const { error, value } = onboardingSchema.validate(req.body);
    if (error) {
      return res.status(400).json({ error: error.details[0].message });
    }

    const uid = req.user.uid;
    const email = req.user.email; // From decoded Firebase token

    const userProfile = await userService.onboardUser(uid, email, value);
    res.status(200).json({ message: 'User onboarded successfully', profile: userProfile });
  } catch (error) {
    next(error);
  }
};

const updateProfile = async (req, res, next) => {
  try {
    const uid = req.user.uid;
    const updateData = req.body;
    
    // In a real app we'd validate updateData here
    const updatedProfile = await userService.updateUserProfile(uid, updateData);
    res.status(200).json({ message: 'Profile updated successfully', profile: updatedProfile });
  } catch (error) {
    next(error);
  }
};

const forgotPassword = async (req, res, next) => {
  try {
    const { email } = req.body;
    if (!email) return res.status(400).json({ error: 'Email is required' });
    
    // Attempt to generate a password reset link (requires Firebase Auth configured)
    const { admin } = require('../config/firebase.config');
    try {
      const link = await admin.auth().generatePasswordResetLink(email);
      res.status(200).json({ message: 'Password reset link generated', link });
    } catch (authError) {
      if (authError.code === 'auth/configuration-not-found' || authError.code === 'auth/user-not-found') {
        return res.status(400).json({ error: authError.message });
      }
      throw authError;
    }
  } catch (error) {
    next(error);
  }
};

const syncHealthApps = async (req, res, next) => {
  try {
    const uid = req.user.uid;
    const { provider, healthData } = req.body; 
    res.status(200).json({ message: `Successfully synced data from ${provider}`, dataSynced: healthData });
  } catch (error) {
    next(error);
  }
};

const submitSupportTicket = async (req, res, next) => {
  try {
    const uid = req.user.uid;
    const { subject, message } = req.body;
    
    if (!subject || !message) {
      return res.status(400).json({ error: 'Subject and message are required' });
    }

    const { db } = require('../config/firebase.config');
    const ticketRef = db.collection('supportTickets').doc();
    await ticketRef.set({
      id: ticketRef.id,
      userId: uid,
      subject,
      message,
      status: 'open',
      createdAt: new Date().toISOString()
    });

    res.status(201).json({ message: 'Support ticket submitted successfully', ticketId: ticketRef.id });
  } catch (error) {
    next(error);
  }
};

const recalculateTargets = async (req, res, next) => {
  try {
    const uid = req.user.uid;
    const { weightKg } = req.body;
    
    if (weightKg === undefined) return res.status(400).json({ error: 'weightKg is required' });

    // We can fetch user profile to get their age, sex, height, activityLevel and recalculate
    const profile = await userService.getUserProfile(uid);
    if (!profile || !profile.onboarding) {
      return res.status(400).json({ error: 'User onboarding data not found' });
    }

    const o = profile.onboarding;
    const newBMR = userService.calculateBMR(weightKg, o.heightCm, o.age, o.biologicalSex);
    const newTargets = userService.calculateTargets(newBMR, o.activityLevel, weightKg, o.targetWeightKg);
    
    await userService.updateUserProfile(uid, {
      'onboarding.weightKg': weightKg,
      'onboarding.bmr': newBMR,
      targets: newTargets
    });
    
    res.status(200).json({ message: 'Targets recalculated successfully', newBMR, newTargets });
  } catch (error) {
    next(error);
  }
};

module.exports = {
  getProfile,
  onboardUser,
  updateProfile,
  forgotPassword,
  syncHealthApps,
  submitSupportTicket,
  recalculateTargets
};
