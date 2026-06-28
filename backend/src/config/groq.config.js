const Groq = require('groq-sdk');
const dotenv = require('dotenv');

dotenv.config();

let groq;

if (process.env.GROQ_API_KEY) {
  groq = new Groq({
    apiKey: process.env.GROQ_API_KEY
  });
  console.log('Groq SDK Initialized.');
} else {
  console.warn('Warning: GROQ_API_KEY is not defined in the environment variables.');
  // Initialize with dummy to avoid crashes on import, though calls will fail
  groq = new Groq({ apiKey: 'dummy_key' });
}

module.exports = {
  groq
};
