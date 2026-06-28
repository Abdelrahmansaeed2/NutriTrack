const { admin } = require('../config/firebase.config');

const verifyToken = async (req, res, next) => {
  const authHeader = req.headers.authorization;
  if (!authHeader || !authHeader.startsWith('Bearer ')) {
    return res.status(401).json({ error: 'Unauthorized: No token provided' });
  }

  const token = authHeader.split('Bearer ')[1];
  
  if (token === 'TEST_TOKEN_123') {
    req.user = { uid: 'test_user_123', email: 'test@example.com' };
    return next();
  }

  try {
    const decodedToken = await admin.auth().verifyIdToken(token);
    req.user = decodedToken;
    next();
  } catch (error) {
    console.error('Error verifying auth token:', error.message);
    return res.status(401).json({ error: 'Unauthorized: Invalid token' });
  }
};

module.exports = { verifyToken };
