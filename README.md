<div align="center">

# NutriTrack AI

### *Precision Nutrition Engineered for Peak Performance*

[![Flutter](https://img.shields.io/badge/Flutter-3.0+-02569B?logo=flutter&logoColor=white)](https://flutter.dev)
[![Node.js](https://img.shields.io/badge/Node.js-18+-339933?logo=node.js&logoColor=white)](https://nodejs.org)
[![Firebase](https://img.shields.io/badge/Firebase-Firestore%20%7C%20Auth-FFCA28?logo=firebase&logoColor=black)](https://firebase.google.com)
[![Vercel](https://img.shields.io/badge/Deployed%20on-Vercel-000000?logo=vercel&logoColor=white)](https://vercel.com)
[![Groq AI](https://img.shields.io/badge/AI-Groq%20Llama--3-FF6B35)](https://groq.com)
[![License: MIT](https://img.shields.io/badge/License-MIT-green.svg)](LICENSE)

NutriTrack AI is a **full-stack, AI-powered nutrition tracking and meal planning app** built with Flutter and a Node.js serverless backend. From personalized 7-day meal plans to real-time macro tracking and smart grocery lists — everything is powered by Llama-3 AI and Firebase.

</div>

---

## ✨ What's New (Latest Release)

| Feature | Description |
|---|---|
| 🎨 **Light & Dark Theme** | Fully working system-aware theme toggle in Settings |
| 🍳 **Custom Recipe Builder** | Interactive ingredient dialog with name, quantity & calorie inputs |
| 🏠 **Live Home Refresh** | Home screen updates instantly after saving a recipe — no stale data |
| 🔄 **Race Condition Fix** | Uses the `POST /meal` response log directly — no second API call needed |
| 👤 **Realistic Profile Avatar** | Professional photo asset replacing placeholder |
| 🔧 **Context Bug Fix** | Captures `Navigator` and `Cubit` before bottom sheet pops to avoid dead-context crashes |

---

## 🚀 Key Features

### 📱 Flutter Frontend

- **Premium Glassmorphic UI** — Vibrant designs with custom animations, micro-interactions, and smooth transitions
- **Light & Dark Mode** — Fully themed using Flutter's `ThemeData` + persistent `SharedPreferences` toggle
- **Firebase Authentication** — Sign-Up, Login, and password reset flows with Firebase Auth
- **Advanced Daily Dashboard** — Calorie ring, macro progress bars (Protein / Carbs / Fats), meal sections, and water tracker
- **AI Weekly Meal Planner** — One-tap AI-generated 7-day meal plan (breakfast, lunch, dinner, snacks) with daily macro targets
- **Custom Recipe Builder** — Build your own meals, add/edit/delete ingredients interactively, auto-logs to the daily tracker
- **Food Search** — Search food items with calorie and macro info, log them directly to any meal slot
- **Smart Grocery Lists** — Auto-compiled from your weekly plan with category grouping and checkbox completion tracking
- **Water Tracking** — Log intake in cups/glasses/bottles, visualized with progress bar
- **Progress Analytics** — Weight trend charts, calorie history, and nutritional analytics dashboard
- **BLoC State Management** — Clean architecture with Cubit-based state handling per feature

### ⚡ Node.js Backend

- **Groq Llama-3 AI** — Weekly meal plan generation, meal swap suggestions, and smart grocery list compilation
- **Firebase Admin SDK** — Secure Firestore CRUD for user profiles, daily logs, recipes, and grocery lists
- **40+ REST API Endpoints** — Covering auth, tracking, AI, recipes, and grocery management
- **Vercel Serverless** — Zero-config deployment with serverless functions
- **Integration Test Suite** — 40-endpoint test coverage with auto-generated `test_results.md`

---

## 🏗️ Architecture

```
NutriTrack/
├── assets/                        # App images, icons, and fonts
│   └── images/
│       └── avatar.jpeg            # Realistic profile photo asset
│
├── backend/                       # Node.js Express Serverless API
│   ├── src/
│   │   ├── controllers/           # Route handlers (auth, AI, tracking, recipes)
│   │   ├── routes/                # Express route definitions
│   │   ├── services/              # Business logic & third-party integrations
│   │   │   ├── tracking.service.js
│   │   │   ├── ai.service.js
│   │   │   ├── recipe.service.js
│   │   │   └── analytics.service.js
│   │   └── config/                # Firebase Admin & Groq config
│   ├── server.js                  # Entry point
│   ├── vercel.json                # Vercel deployment config
│   └── test_all_endpoints.js      # Integration test suite
│
└── lib/                           # Flutter App
    ├── core/
    │   ├── network/               # Dio API client with auth token injection
    │   ├── theme/                 # AppTheme (light + dark ThemeData)
    │   └── widgets/               # Shared Header widget
    │
    ├── features/                  # Feature-first modular architecture
    │   ├── analytics/             # Trends & charts (Cubit + Service + Screen)
    │   ├── custom recipe/         # Recipe builder (Cubit + Service + Models)
    │   ├── daily dashboard/       # Home screen (Cubit + Service + Screen)
    │   ├── food details/          # Food detail view + meal logging
    │   ├── foodSearch/            # Food search with filters
    │   ├── grocery/               # Grocery list (Cubit + Service + Widgets)
    │   ├── settings/              # Theme toggle, profile settings, logout
    │   ├── waterTracking/         # Water intake tracking
    │   └── weeklyMealPlanner/     # AI weekly plan viewer
    │
    ├── nutri_track_app.dart       # App root with BlocProviders & ThemeMode
    └── main.dart                  # Entry point
```

---

## 🛠️ Getting Started

### Prerequisites

| Tool | Version |
|---|---|
| Flutter SDK | ≥ 3.0.0 |
| Dart | ≥ 3.0.0 |
| Node.js | ≥ 18.0.0 |
| Firebase Project | Firestore + Auth enabled |
| Groq API Key | [Get one free](https://console.groq.com) |

---

### 1. Backend Setup

```bash
# Navigate to backend
cd backend

# Install dependencies
npm install

# Create environment file
cat > .env << 'EOF'
PORT=3000
GROQ_API_KEY=your_groq_api_key_here
FIREBASE_SERVICE_ACCOUNT=./src/config/serviceAccountKey.json
EOF
```

> Place your Firebase Service Account JSON at `backend/src/config/serviceAccountKey.json`

```bash
# Start local dev server
npm run dev
# → Running at http://localhost:3000
```

**Run Integration Tests:**
```bash
node test_all_endpoints.js
# Runs all 40 endpoints and saves results to test_results.md
```

---

### 2. Flutter Frontend Setup

```bash
# Install dependencies
flutter pub get

# Run on connected device
flutter run
```

> Ensure `lib/firebase_options.dart` has your Firebase project credentials (Project ID, API keys, App IDs).

---

## 🔌 API Reference

### 👤 User Endpoints — `/api/users`

| Method | Endpoint | Description |
|--------|----------|-------------|
| `POST` | `/onboard` | Save physical metrics & activity goals |
| `GET` | `/profile` | Fetch authenticated user's profile |
| `PUT` | `/profile` | Update profile information |
| `POST` | `/recalculate-targets` | Re-calculate calorie & macro targets |
| `POST` | `/sync-health` | Sync steps from Apple Health / Google Fit |

### 📊 Tracking Endpoints — `/api/tracking`

| Method | Endpoint | Description |
|--------|----------|-------------|
| `GET` | `/daily/:date` | Fetch full daily log |
| `POST` | `/daily/:date/weight` | Log body weight |
| `POST` | `/daily/:date/water` | Log water intake |
| `POST` | `/daily/:date/meal` | Log a meal item (returns updated log) |
| `DELETE` | `/daily/:date/meal` | Remove a logged meal item |
| `POST` | `/tracking/fasting` | Log a fasting session |

### 🧠 AI Endpoints — `/api/ai`

| Method | Endpoint | Description |
|--------|----------|-------------|
| `POST` | `/recommend-meal` | Suggest meals based on remaining calories |
| `POST` | `/generate-weekly-plan` | Generate a 7-day AI meal plan |
| `GET` | `/weekly-plan/latest` | Fetch the latest meal plan |
| `POST` | `/swap-meal` | Swap a meal with an AI alternative |
| `POST` | `/generate-grocery-list` | Generate grocery list from weekly plan |

### 🍳 Recipe Endpoints — `/api/recipes`

| Method | Endpoint | Description |
|--------|----------|-------------|
| `POST` | `/` | Create a custom recipe |
| `GET` | `/` | List all saved recipes |
| `GET` | `/:id` | Fetch a specific recipe |
| `DELETE` | `/:id` | Delete a recipe |

### 🛒 Grocery Endpoints — `/api/tracking/grocery`

| Method | Endpoint | Description |
|--------|----------|-------------|
| `GET` | `/` | Fetch all grocery lists |
| `GET` | `/latest` | Fetch the latest grocery list |
| `POST` | `/latest/item` | Add a manual item |
| `PUT` | `/latest/item` | Toggle item checked status |
| `DELETE` | `/latest/checked` | Clear all checked items |

---

## 🎨 Design System

| Token | Value |
|---|---|
| **Primary Color** | `#4CAF50` (NutriGreen) |
| **Font** | Inter / System default |
| **Corner Radius** | 12px (cards), 99px (pills) |
| **Theme** | Light + Dark, toggle persisted via SharedPreferences |
| **State Management** | Flutter BLoC (Cubit pattern) |
| **HTTP Client** | Dio with automatic Bearer token injection |

---

## ☁️ Deployment

The backend is deployed as a **Vercel Serverless Function**.

```json
// vercel.json
{
  "version": 2,
  "builds": [{ "src": "backend/server.js", "use": "@vercel/node" }],
  "routes": [
    { "src": "/api/(.*)", "dest": "backend/server.js" },
    { "src": "/health", "dest": "backend/server.js" },
    { "src": "/", "dest": "backend/server.js" }
  ]
}
```

**Live Backend:** `https://nutritrack-backend-blond.vercel.app`

Push to the connected GitHub repository to auto-deploy via Vercel CI/CD.

---

## 🧪 Tech Stack

| Layer | Technology |
|---|---|
| **Mobile** | Flutter 3, Dart, BLoC/Cubit |
| **Backend** | Node.js 18, Express.js |
| **AI** | Groq Cloud — Llama-3 8B |
| **Database** | Firebase Firestore |
| **Auth** | Firebase Authentication |
| **Deployment** | Vercel Serverless |
| **HTTP** | Dio (Flutter), Axios (Node) |

---

## 👥 Team

Built with:
Abd Elrahman Saeed And
Abd Elrahman Nader And
Ebrahim reda And
Mohmeed Maher 