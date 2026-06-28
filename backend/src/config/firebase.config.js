const admin = require('firebase-admin');
const dotenv = require('dotenv');
const fs = require('fs');
const path = require('path');

dotenv.config();

let db;

try {
  let serviceAccount;
  
  if (process.env.FIREBASE_SERVICE_ACCOUNT_JSON) {
    serviceAccount = JSON.parse(process.env.FIREBASE_SERVICE_ACCOUNT_JSON);
    console.log('Firebase Admin Initialized using service account JSON string.');
  } else if (process.env.FIREBASE_SERVICE_ACCOUNT_PATH && fs.existsSync(process.env.FIREBASE_SERVICE_ACCOUNT_PATH)) {
    const absolutePath = path.resolve(process.cwd(), process.env.FIREBASE_SERVICE_ACCOUNT_PATH);
    serviceAccount = require(absolutePath);
    console.log('Firebase Admin Initialized using service account file.');
  }

  if (serviceAccount) {
    admin.initializeApp({
      credential: admin.credential.cert(serviceAccount)
    });
  } else {
    // Fallback to application default credentials or mock for dev if no key exists yet
    console.warn('Warning: No Firebase credentials provided. Attempting to initialize with default credentials.');
    admin.initializeApp();
  }
  
  db = admin.firestore();
} catch (error) {
  console.error('Error initializing Firebase Admin:', error.message);
}

module.exports = {
  admin,
  db
};
