const express = require('express');
const cors = require('cors');
const dotenv = require('dotenv');

// Load environment variables
dotenv.config();

const app = express();

// Global Middlewares
app.use(cors());
app.use(express.json());

// Root route
app.get('/', (req, res) => {
  res.status(200).json({ status: 'OK', message: 'Welcome to the NutriTrack AI Backend API. Use /health to check status.' });
});

// Basic health check route
app.get('/health', (req, res) => {
  res.status(200).json({ status: 'OK', message: 'NutriTrack Backend is running.' });
});

// Import specific routes
const userRoutes = require('./src/routes/user.routes');
const trackingRoutes = require('./src/routes/tracking.routes');
const recipeRoutes = require('./src/routes/recipe.routes');
const aiRoutes = require('./src/routes/ai.routes');
const analyticsRoutes = require('./src/routes/analytics.routes');
const foodRoutes = require('./src/routes/food.routes');

app.use('/api/users', userRoutes);
app.use('/api/tracking', trackingRoutes);
app.use('/api/recipes', recipeRoutes);
app.use('/api/ai', aiRoutes);
app.use('/api/analytics', analyticsRoutes);
app.use('/api/foods', foodRoutes);

// Global Error Handler
app.use((err, req, res, next) => {
  console.error(err.stack);
  const statusCode = err.status || err.statusCode || 500;
  res.status(statusCode).json({
    error: statusCode === 500 ? 'Internal Server Error' : 'Bad Request',
    message: err.message
  });
});

const PORT = process.env.PORT || 3000;

// Only listen if not running in a serverless environment (e.g. Vercel)
if (process.env.NODE_ENV !== 'production') {
  app.listen(PORT, () => {
    console.log(`Server is running on port ${PORT}`);
  });
}

module.exports = app;
