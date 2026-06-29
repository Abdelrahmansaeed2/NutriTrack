# NutriTrack AI 🍏

NutriTrack AI is a premium, AI-powered nutrition tracking and weekly meal planning application designed to deliver precision nutrition engineered for peak athletic performance. The project consists of a **Flutter Mobile App** (Frontend) and a **Node.js Express Serverless API** (Backend) integrated with Firebase and the Groq AI Llama-3 model.

---

## 🚀 Key Features

### 📱 Flutter Mobile App (Frontend)
*   **Premium Glassmorphic UI**: Vibrant, responsive designs matching Figma specifications with custom animations and transitions.
*   **Onboarding Flow**: Multi-step metrics input (Biological Sex, Age, Height, Weight, Target Weight, and Activity Level) with instant BMR and calorie target calculations.
*   **Firebase Authentication**: Complete Sign-Up, Login, and password reset flows.
*   **Advanced Daily Dashboard**: Daily calorie and water tracking, meal logging (Breakfast, Lunch, Dinner, Snacks), and interactive macro-nutrient progress rings.
*   **AI Meal Planner**: Generate a personalized 7-day meal plan based on target calories, dietary frameworks, and allergies.
*   **Smart Grocery Lists**: Automatically compile a grocery list from your weekly meal plan, with checkable items and custom category sorting.
*   **Food Search & Recipe Builder**: Search food items using the Open Food Facts API, barcode scanning, or build custom recipes.
*   **Progress Analytics**: Weight trend charts and nutritional analytics.

### ⚡ Node.js Express API (Backend)
*   **Groq AI Integration**: Leverages Llama-3 for generating weekly meal plans, suggesting meal swaps, and compiling grocery lists.
*   **Firestore Database**: Secure Firestore management via Firebase Admin SDK for storing user profiles, daily tracking logs, custom recipes, and grocery lists.
*   **Vercel Serverless Deployment**: Built-in support for Vercel Serverless Functions with a root-level routing configuration.
*   **Integration Testing**: Comprehensive test suite covering all 40 API endpoints with mock data and automatic test reporting.

---

## 📂 Project Structure

```text
NutriTrack/
├── assets/                    # Image and vector assets for the mobile app
├── backend/                   # Node.js Express Backend API
│   ├── src/
│   │   ├── controllers/      # API Controllers (Auth, AI, Tracking, etc.)
│   │   ├── routes/           # Express Route Definitions
│   │   ├── services/         # Business Logic & Third-Party Integrations
│   │   └── config/           # Firebase Admin & Groq configurations
│   ├── server.js             # API Entry Point
│   ├── vercel.json           # Vercel deployment configuration
│   └── test_all_endpoints.js # Integration Test Suite
├── lib/                       # Flutter Frontend App
│   ├── core/                 # Shared constants, themes, network clients, and routers
│   ├── features/             # Feature-driven modules (Auth, AI Planner, Tracking)
│   │   └── .../              # Models, UI screens, and ViewModels
│   ├── presentation/         # Cubits (State Management) and reusable UI widgets
│   ├── firebase_options.dart # Firebase configuration
│   └── main.dart             # App Entry Point
├── vercel.json                # Root-level Vercel deployment router
└── README.md                  # Project Documentation
```

---

## 🛠️ Getting Started

### 1. Backend Setup (Node.js)

#### Prerequisites
*   Node.js (v18 or higher)
*   Firebase Project with Firestore and Authentication enabled

#### Installation & Run
1.  Navigate to the backend directory:
    ```bash
    cd backend
    ```
2.  Install dependencies:
    ```bash
    npm install
    ```
3.  Create a `.env` file in the `backend/` directory:
    ```env
    PORT=3000
    GROQ_API_KEY=your_groq_api_key_here
    # Path to your Firebase Service Account JSON file:
    FIREBASE_SERVICE_ACCOUNT=./config/serviceAccountKey.json
    ```
4.  Place your Firebase Service Account JSON file at `backend/src/config/serviceAccountKey.json`.
5.  Start the local development server:
    ```bash
    npm run dev
    ```
    The server will start at `http://localhost:3000`.

#### Running Integration Tests
To execute the comprehensive 40-endpoint integration test suite:
```bash
# Make sure the local server is running, then execute:
node test_all_endpoints.js
```
The test results will be outputted directly to the console and saved in `test_results.md`.

---

### 2. Frontend Setup (Flutter)

#### Prerequisites
*   Flutter SDK (v3.0.0 or higher)
*   Android Studio / Xcode (for emulation/device testing)

#### Installation & Run
1.  Install Flutter dependencies in the root directory:
    ```bash
    flutter pub get
    ```
2.  Configure Firebase:
    Ensure your `lib/firebase_options.dart` contains the valid API keys, Project ID, and App IDs matching your Firebase Console configuration.
3.  Run the application on your connected emulator or physical device:
    ```bash
    flutter run
    ```

---

## 🔌 API Endpoints Summary

### 👤 User Endpoints (`/api/users`)
*   `POST /onboard` - Saves physical metrics and activity goals.
*   `GET /profile` - Fetches the authenticated user's profile.
*   `PUT /profile` - Updates profile information.
*   `POST /recalculate-targets` - Re-calculates calorie and macro targets.
*   `POST /sync-health` - Syncs steps and activity from Apple Health / Google Fit.

### 📊 Tracking Endpoints (`/api/tracking`)
*   `GET /daily/:date` - Fetches the daily log (calories, water, weight, meals).
*   `POST /daily/:date/weight` - Logs the user's weight.
*   `POST /daily/:date/water` - Logs water intake.
*   `POST /daily/:date/meal` - Logs a meal item.
*   `DELETE /daily/:date/meal` - Removes a logged meal item.
*   `POST /tracking/fasting` - Logs a fasting session.

### 🧠 AI Endpoints (`/api/ai`)
*   `POST /recommend-meal` - Suggests meals based on remaining daily calories.
*   `POST /generate-weekly-plan` - Generates a 7-day athletic meal plan.
*   `GET /weekly-plan/latest` - Fetches the latest meal plan.
*   `POST /swap-meal` - Swaps a meal with an alternative option.
*   `POST /generate-grocery-list` - Generates a grocery list from a weekly plan.

### 🛒 Grocery List Endpoints (`/api/tracking/grocery`)
*   `GET /` - Fetches all grocery lists.
*   `GET /latest` - Fetches the latest grocery list.
*   `POST /latest/item` - Adds a manual item to the latest grocery list (creates list if none exists).
*   `PUT /latest/item` - Toggles item checked status.
*   `DELETE /latest/checked` - Clears all checked items.

---

## ☁️ Deployment

The backend is configured for serverless deployment on **Vercel**. 

The root-level `vercel.json` ensures that all incoming traffic is cleanly routed to the Node.js Express application:
```json
{
  "version": 2,
  "builds": [
    {
      "src": "backend/server.js",
      "use": "@vercel/node"
    }
  ],
  "routes": [
    {
      "src": "/api/(.*)",
      "dest": "backend/server.js"
    },
    {
      "src": "/health",
      "dest": "backend/server.js"
    },
    {
      "src": "/",
      "dest": "backend/server.js"
    }
  ]
}
```
Deploying to Vercel is as simple as pushing changes to the connected GitHub repository.
