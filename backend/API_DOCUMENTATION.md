# NutriTrack AI Backend API Documentation

Welcome to the NutriTrack AI Backend API documentation. This document outlines the available endpoints, authentication mechanisms, and request/response specifications for integration with the Flutter frontend and other services.

## Base URL

*   **Production API URL:** `https://nutritrack-backend-blond.vercel.app`
*   **Local Development URL:** `http://localhost:3000`

---

## Authentication

All endpoints under `/api/*` are protected and require a Firebase ID Token.

### Request Header
```http
Authorization: Bearer <FIREBASE_ID_TOKEN>
```

### Local Development / Testing Bypass
For testing and local development, you can bypass Firebase verification by using a hardcoded test token. The backend will map this token to a mock user:
*   **Test Token:** `TEST_TOKEN_123`
*   **Associated User ID (`uid`):** `test_user_123`
*   **Associated Email:** `test@example.com`

**Example Header:**
```http
Authorization: Bearer TEST_TOKEN_123
```

---

## Endpoints Quick Reference

### 1. General & Public
| Method | Route | Auth Required | Description |
| :--- | :--- | :--- | :--- |
| `GET` | `/` | No | Root welcome message |
| `GET` | `/health` | No | Basic health check |

### 2. User Management & Onboarding
| Method | Route | Auth Required | Description |
| :--- | :--- | :--- | :--- |
| `POST` | `/api/users/forgot-password` | No | Generates a Firebase password reset link |
| `GET` | `/api/users/profile` | Yes | Retrieves the current user's profile |
| `PUT` | `/api/users/profile` | Yes | Updates the user's profile information |
| `POST` | `/api/users/onboard` | Yes | Saves onboarding data and calculates targets |
| `POST` | `/api/users/sync-health` | Yes | Syncs data from external health integrations |
| `POST` | `/api/users/support` | Yes | Submits a support ticket |
| `POST` | `/api/users/recalculate-targets` | Yes | Recalculates BMR and macro targets |

### 3. Daily Tracking
| Method | Route | Auth Required | Description |
| :--- | :--- | :--- | :--- |
| `GET` | `/api/tracking/daily/:date` | Yes | Gets logs for a specific date (`YYYY-MM-DD`) |
| `POST` | `/api/tracking/daily/:date/meal` | Yes | Logs a meal item |
| `DELETE` | `/api/tracking/daily/:date/meal` | Yes | Deletes a logged meal item by index |
| `POST` | `/api/tracking/daily/:date/water` | Yes | Logs water intake |
| `DELETE` | `/api/tracking/daily/:date/water` | Yes | Deletes a water log entry by index |
| `POST` | `/api/tracking/daily/:date/weight` | Yes | Logs body weight for a date |
| `POST` | `/api/tracking/daily/:date/photo` | Yes | Uploads a progress photo |
| `POST` | `/api/tracking/fasting` | Yes | Logs a fasting window |

### 4. Grocery Lists
| Method | Route | Auth Required | Description |
| :--- | :--- | :--- | :--- |
| `GET` | `/api/tracking/grocery` | Yes | Gets all grocery lists for the user |
| `GET` | `/api/tracking/grocery/:listId` | Yes | Gets a specific grocery list |
| `POST` | `/api/tracking/grocery/:listId/item` | Yes | Manually adds an item to a grocery list |
| `PUT` | `/api/tracking/grocery/:listId/item` | Yes | Updates check status of a grocery item |
| `DELETE` | `/api/tracking/grocery/:listId/checked` | Yes | Clears all checked items from a list |

### 5. Recipes
| Method | Route | Auth Required | Description |
| :--- | :--- | :--- | :--- |
| `GET` | `/api/recipes` | Yes | Retrieves all user-created recipes |
| `POST` | `/api/recipes` | Yes | Creates a new recipe |
| `GET` | `/api/recipes/:id` | Yes | Retrieves a specific recipe |
| `PUT` | `/api/recipes/:id` | Yes | Updates a recipe |
| `DELETE` | `/api/recipes/:id` | Yes | Deletes a recipe |

### 6. AI Features (Groq-Powered)
| Method | Route | Auth Required | Description |
| :--- | :--- | :--- | :--- |
| `POST` | `/api/ai/generate-weekly-plan` | Yes | Generates a 7-day meal plan based on macros |
| `POST` | `/api/ai/generate-grocery-list` | Yes | Generates a grocery list from a weekly plan |
| `POST` | `/api/ai/swap-meal` | Yes | Swaps a specific meal in a plan with an AI alternative |
| `POST` | `/api/ai/recommend-meal` | Yes | Recommends a meal based on remaining macros |
| `GET` | `/api/ai/weekly-plan` | Yes | Gets the latest generated weekly plan |
| `GET` | `/api/ai/weekly-plan/:id` | Yes | Gets a weekly plan by ID |

### 7. Analytics
| Method | Route | Auth Required | Description |
| :--- | :--- | :--- | :--- |
| `GET` | `/api/analytics/dashboard` | Yes | Gets comprehensive dashboard and progress statistics |
| `GET` | `/api/analytics/export` | Yes | Exports user data as a JSON file |

### 8. Food Database & Search
| Method | Route | Auth Required | Description |
| :--- | :--- | :--- | :--- |
| `GET` | `/api/foods/search` | Yes | Searches the food database |
| `GET` | `/api/foods/:id` | Yes | Gets details for a specific food item |
| `POST` | `/api/foods/barcode` | Yes | Scans a barcode to retrieve food details |
| `GET` | `/api/foods/favorites` | Yes | Retrieves user's favorite foods |
| `POST` | `/api/foods/favorites/:id` | Yes | Adds a food to favorites |
| `DELETE` | `/api/foods/favorites/:id` | Yes | Removes a food from favorites |
| `POST` | `/api/foods/custom` | Yes | Creates a custom user food |

---

## Detailed Endpoint Specifications

### 1. General & Public

#### Root Welcome
*   **Route:** `GET /`
*   **Response:**
    ```json
    {
      "status": "OK",
      "message": "Welcome to the NutriTrack AI Backend API. Use /health to check status."
    }
    ```

#### Health Check
*   **Route:** `GET /health`
*   **Response:**
    ```json
    {
      "status": "OK",
      "message": "NutriTrack Backend is running."
    }
    ```

---

### 2. User Management & Onboarding

#### Forgot Password
*   **Route:** `POST /api/users/forgot-password`
*   **Request Body:**
    ```json
    {
      "email": "user@example.com"
    }
    ```
*   **Response (Success):**
    ```json
    {
      "message": "Password reset link generated",
      "link": "https://identitytoolkit.googleapis.com/v1/accounts:resetPassword?..."
    }
    ```

#### Get Profile
*   **Route:** `GET /api/users/profile`
*   **Response (Success):**
    ```json
    {
      "uid": "test_user_123",
      "email": "test@example.com",
      "onboarding": {
        "name": "Alex",
        "biologicalSex": "Male",
        "age": 28,
        "heightCm": 180,
        "weightKg": 80,
        "targetWeightKg": 75,
        "activityLevel": "Active",
        "bmr": 1810
      },
      "targets": {
        "calories": 2300,
        "protein": 150,
        "carbs": 250,
        "fat": 70
      }
    }
    ```

#### Onboard User
*   **Route:** `POST /api/users/onboard`
*   **Request Body (Validation: Joi):**
    ```json
    {
      "name": "Alex", // Optional
      "bio": "Getting fit!", // Optional
      "biologicalSex": "Male", // Required, ["Male", "Female"]
      "age": 28, // Required, min 10, max 120
      "heightCm": 180, // Required, min 50, max 300
      "weightKg": 80, // Required, min 20, max 500
      "targetWeightKg": 75, // Required, min 20, max 500
      "activityLevel": "Active" // Required, ["Sedentary", "Active", "Athlete"]
    }
    ```
*   **Response (Success):**
    ```json
    {
      "message": "User onboarded successfully",
      "profile": { ... }
    }
    ```

#### Recalculate Targets
*   **Route:** `POST /api/users/recalculate-targets`
*   **Request Body:**
    ```json
    {
      "weightKg": 79.5
    }
    ```
*   **Response (Success):**
    ```json
    {
      "message": "Targets recalculated successfully",
      "newBMR": 1803,
      "newTargets": {
        "calories": 2291,
        "protein": 149,
        "carbs": 249,
        "fat": 70
      }
    }
    ```

---

### 3. Daily Tracking

#### Get Daily Log
*   **Route:** `GET /api/tracking/daily/:date`
    *   `:date` format: `YYYY-MM-DD` (e.g., `2026-06-28`)
*   **Response (Success):**
    ```json
    {
      "date": "2026-06-28",
      "meals": {
        "breakfast": [
          {
            "foodId": "1",
            "name": "Grilled Chicken Breast",
            "quantity": 1.5,
            "calories": 195,
            "macros": { "protein": 39, "carbs": 0, "fat": 3 }
          }
        ],
        "lunch": [],
        "dinner": [],
        "snacks": []
      },
      "waterIntake": [
        { "amountMl": 250, "type": "water", "timestamp": "2026-06-28T08:00:00.000Z" }
      ],
      "weightKg": 80.0,
      "progressPhotoUrl": "https://example.com/photo.jpg"
    }
    ```

#### Log Meal Item
*   **Route:** `POST /api/tracking/daily/:date/meal`
*   **Request Body:**
    ```json
    {
      "mealType": "breakfast", // ["breakfast", "lunch", "dinner", "snacks"]
      "item": {
        "foodId": "1",
        "name": "Grilled Chicken Breast",
        "quantity": 1.5,
        "calories": 195,
        "macros": {
          "protein": 39,
          "carbs": 0,
          "fat": 3
        }
      }
    }
    ```

#### Remove Meal Item
*   **Route:** `DELETE /api/tracking/daily/:date/meal`
*   **Request Body:**
    ```json
    {
      "mealType": "breakfast",
      "index": 0 // Zero-based index of the item in the array
    }
    ```

---

### 4. Grocery Lists

#### Get Grocery Lists
*   **Route:** `GET /api/tracking/grocery`
*   **Response (Success):**
    ```json
    [
      {
        "id": "list_abc123",
        "planId": "weekly_plan_xyz",
        "createdAt": "2026-06-28T05:00:00Z",
        "items": [
          { "name": "Chicken Breast", "quantity": "1.5 kg", "isChecked": false },
          { "name": "Greek Yogurt", "quantity": "1 tub", "isChecked": true }
        ]
      }
    ]
    ```

#### Update Grocery Item Status
*   **Route:** `PUT /api/tracking/grocery/:listId/item`
*   **Request Body:**
    ```json
    {
      "itemName": "Chicken Breast",
      "isChecked": true
    }
    ```

---

### 5. Recipes

#### Create Recipe
*   **Route:** `POST /api/recipes`
*   **Request Body:**
    ```json
    {
      "name": "Protein Oatmeal",
      "totals": {
        "calories": 350,
        "protein": 25,
        "carbs": 45,
        "fat": 6
      },
      "ingredients": [
        { "name": "Rolled Oats", "quantity": "50g", "calories": 190 },
        { "name": "Whey Protein", "quantity": "30g", "calories": 120 },
        { "name": "Chia Seeds", "quantity": "1 tbsp", "calories": 40 }
      ]
    }
    ```

---

### 6. AI Features (Groq-Powered)

#### Generate Weekly Plan
*   **Route:** `POST /api/ai/generate-weekly-plan`
*   **Request Body:**
    ```json
    {
      "startDate": "2026-06-29"
    }
    ```
*   **Response (Success):**
    ```json
    {
      "message": "Weekly plan generated successfully",
      "plan": {
        "id": "plan_1719548400000",
        "startDate": "2026-06-29",
        "days": {
          "2026-06-29": {
            "meals": {
              "breakfast": { "name": "Greek Yogurt with Berries", "calories": 250, "protein": 20, "carbs": 30, "fat": 5 },
              "lunch": { "name": "Turkey Wrap", "calories": 450, "protein": 35, "carbs": 40, "fat": 15 },
              "dinner": { "name": "Grilled Salmon with Asparagus", "calories": 600, "protein": 45, "carbs": 10, "fat": 40 },
              "snacks": { "name": "Mixed Almonds", "calories": 200, "protein": 6, "carbs": 5, "fat": 18 }
            }
          }
          // Contains 7 days in total
        }
      }
    }
    ```

#### Swap Meal
*   **Route:** `POST /api/ai/swap-meal`
*   **Request Body:**
    ```json
    {
      "planId": "plan_1719548400000",
      "date": "2026-06-29",
      "mealType": "dinner"
    }
    ```
*   **Response (Success):**
    ```json
    {
      "message": "Meal swapped successfully",
      "swappedMeal": {
        "name": "Baked Cod with Quinoa",
        "calories": 580,
        "protein": 42,
        "carbs": 48,
        "fat": 10
      }
    }
    ```

#### Recommend Meal (On-the-Fly)
*   **Route:** `POST /api/ai/recommend-meal`
*   **Request Body:**
    ```json
    {
      "remainingCalories": 500,
      "remainingProtein": 40
    }
    ```
*   **Response (Success):**
    ```json
    {
      "message": "Meal recommended",
      "suggestion": {
        "name": "Tuna Salad with Olive Oil",
        "calories": 420,
        "protein": 38,
        "carbs": 5,
        "fat": 28,
        "description": "High-protein tuna mixed with fresh greens and light olive oil dressing to meet your target."
      }
    }
    ```

---

### 7. Analytics

#### Get Dashboard Stats
*   **Route:** `GET /api/analytics/dashboard`
*   **Response (Success):**
    ```json
    {
      "summary": {
        "currentWeight": 80.0,
        "weightChange": -0.5,
        "averageCalories": 2150,
        "waterComplianceRate": 0.85
      },
      "weeklyAdherence": [
        { "date": "2026-06-22", "calories": 2200, "targetCalories": 2300, "protein": 145, "targetProtein": 150 },
        { "date": "2026-06-23", "calories": 2100, "targetCalories": 2300, "protein": 152, "targetProtein": 150 }
        // ...
      ],
      "weightTrend": [
        { "date": "2026-06-22", "weightKg": 80.5 },
        { "date": "2026-06-28", "weightKg": 80.0 }
      ]
    }
    ```

---

### 8. Food Database & Search

#### Search Foods
*   **Route:** `GET /api/foods/search`
*   **Query Parameters:**
    *   `query`: Term to search (e.g. `chicken`)
    *   `tag`: Filter tag (e.g. `High Protein`, `Keto`, `Vegan`, `Vegetarian`). Use `all` or omit to ignore.
*   **Response (Success):**
    ```json
    [
      {
        "id": "1",
        "name": "Grilled Chicken Breast",
        "brand": "Kirkland Signature",
        "servingSize": "4 oz",
        "calories": 130,
        "macros": { "protein": 26, "carbs": 0, "fat": 2 },
        "tags": ["High Protein"]
      }
    ]
    ```

#### Scan Barcode
*   **Route:** `POST /api/foods/barcode`
*   **Request Body:**
    ```json
    {
      "barcode": "012345678901"
    }
    ```
*   **Response (Success):**
    ```json
    {
      "id": "bc_012345678901",
      "name": "Mocked Barcode Item",
      "brand": "Scanned Brand",
      "servingSize": "1 container",
      "calories": 250,
      "macros": { "protein": 15, "carbs": 30, "fat": 8 }
    }
    ```
