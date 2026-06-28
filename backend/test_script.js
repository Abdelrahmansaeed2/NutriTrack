const fs = require('fs');

const BASE_URL = 'http://localhost:3000/api';
const HEADERS = {
  'Authorization': 'Bearer TEST_TOKEN_123',
  'Content-Type': 'application/json'
};

const results = [];
let passed = 0;
let failed = 0;

const logResult = (endpoint, method, status, responseData) => {
  const isSuccess = status >= 200 && status < 300;
  if (isSuccess) passed++; else failed++;
  results.push({ endpoint, method, status, success: isSuccess, response: responseData });
  console.log(`[${isSuccess ? 'PASS' : 'FAIL'}] ${method} ${endpoint} (Status: ${status})`);
};

const runTests = async () => {
  try {
    let res = await fetch(`${BASE_URL}/users/profile`, { method: 'GET', headers: HEADERS });
    let data = await res.json();
    logResult('/users/profile', 'GET', res.status, data);

    res = await fetch(`${BASE_URL}/users/profile`, { 
      method: 'PUT', headers: HEADERS, 
      body: JSON.stringify({ bio: 'Testing updates' }) 
    });
    data = await res.json();
    logResult('/users/profile', 'PUT', res.status, data);

    res = await fetch(`${BASE_URL}/users/onboard`, { 
      method: 'POST', headers: HEADERS, 
      body: JSON.stringify({ name: 'Tester', biologicalSex: 'Male', age: 30, heightCm: 180, weightKg: 80, targetWeightKg: 75, activityLevel: 'Active' }) 
    });
    data = await res.json();
    logResult('/users/onboard', 'POST', res.status, data);

    const date = new Date().toISOString().split('T')[0];
    res = await fetch(`${BASE_URL}/tracking/daily/${date}/weight`, { 
      method: 'POST', headers: HEADERS, 
      body: JSON.stringify({ weightKg: 79.5 }) 
    });
    data = await res.json();
    logResult('/tracking/daily/:date/weight', 'POST', res.status, data);

    res = await fetch(`${BASE_URL}/tracking/daily/${date}/water`, { 
      method: 'POST', headers: HEADERS, 
      body: JSON.stringify({ amountMl: 500, type: 'Bottle' }) 
    });
    data = await res.json();
    logResult('/tracking/daily/:date/water', 'POST', res.status, data);

    res = await fetch(`${BASE_URL}/recipes`, { 
      method: 'POST', headers: HEADERS, 
      body: JSON.stringify({ name: 'Test Recipe', calories: 300, macros: { protein: 20, carbs: 30, fat: 10 }, ingredients: [] }) 
    });
    data = await res.json();
    logResult('/recipes', 'POST', res.status, data);
    
    res = await fetch(`${BASE_URL}/recipes`, { method: 'GET', headers: HEADERS });
    data = await res.json();
    logResult('/recipes', 'GET', res.status, data);

    res = await fetch(`${BASE_URL}/analytics/dashboard`, { method: 'GET', headers: HEADERS });
    data = await res.json();
    logResult('/analytics/dashboard', 'GET', res.status, data);

    res = await fetch(`${BASE_URL}/foods/search?q=chicken`, { method: 'GET', headers: HEADERS });
    data = await res.json();
    logResult('/foods/search', 'GET', res.status, data);

    console.log("Calling Groq AI... this may take a few seconds.");
    res = await fetch(`${BASE_URL}/ai/recommend-meal`, { 
      method: 'POST', headers: HEADERS, 
      body: JSON.stringify({ remainingCalories: 500, remainingProtein: 40 }) 
    });
    data = await res.json();
    logResult('/ai/recommend-meal', 'POST', res.status, data);

  } catch (error) {
    console.error('Test script crashed:', error);
  }

  const report = `# API Integration Test Summary\n\n**Total Tests:** ${passed + failed} | **Passed:** ${passed} | **Failed:** ${failed}\n\n` + 
    results.map(r => `- **[${r.success ? 'PASS' : 'FAIL'}]** \`${r.method} ${r.endpoint}\` (Status: ${r.status})\n  *Response snippet:* ${JSON.stringify(r.response).substring(0, 80)}...`).join('\n\n');
  
  fs.writeFileSync('/Users/abdelrahmansaeed/.gemini/antigravity-ide/brain/e8f3554b-0363-444a-bcf4-b03b1d77e7c7/test_results.md', report);
  console.log('Tests complete! Wrote artifact to test_results.md');
};

runTests();
