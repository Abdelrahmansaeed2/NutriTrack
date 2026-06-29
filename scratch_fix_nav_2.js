const fs = require('fs');

function replaceNav(file) {
  let content = fs.readFileSync(file, 'utf8');
  let original = content;
  if (!content.includes('package:go_router/go_router.dart')) {
    content = content.replace("import 'package:flutter/material.dart';", "import 'package:flutter/material.dart';\nimport 'package:go_router/go_router.dart';");
  }
  
  while (content.includes('Navigator.push(')) {
    let startIndex = content.indexOf('Navigator.push(');
    let braceCount = 1;
    let i = startIndex + 'Navigator.push('.length;
    while (braceCount > 0 && i < content.length) {
      if (content[i] === '(') braceCount++;
      if (content[i] === ')') braceCount--;
      i++;
    }
    if (content[i] === ';') i++;
    
    let block = content.substring(startIndex, i);
    
    let dest = "context.go('/home');"; 
    if (block.includes('LoginScreen')) dest = "context.go('/login');";
    else if (block.includes('PhysicalMetricsScreen')) dest = "context.go('/onboarding/metrics');";
    else if (block.includes('ActivityGoalScreen')) dest = "context.go('/onboarding/activity');";
    else if (block.includes('WaterTrackingScreen')) dest = "context.go('/home/water');";
    else if (block.includes('AIMealPlanSetupScreen') || block.includes('AiMealPlanSetupScreen')) dest = "context.go('/planner/meal_plan_setup');";
    
    content = content.substring(0, startIndex) + dest + content.substring(i);
  }
  
  if (content !== original) {
    fs.writeFileSync(file, content);
    console.log(`Fixed ${file}`);
  }
}

const files = [
    '/Users/abdelrahmansaeed/NutriTrack/lib/presentation/screens/splash_welcome_screen.dart',
    '/Users/abdelrahmansaeed/NutriTrack/lib/presentation/screens/login_screen.dart',
    '/Users/abdelrahmansaeed/NutriTrack/lib/presentation/screens/physical_metrics_screen.dart',
    '/Users/abdelrahmansaeed/NutriTrack/lib/presentation/screens/advanced_daily_dashboard_screen.dart',
    '/Users/abdelrahmansaeed/NutriTrack/lib/presentation/screens/activity_goal_screen.dart',
    '/Users/abdelrahmansaeed/NutriTrack/lib/presentation/screens/ai_weekly_calendar_screen.dart'
];

files.forEach(f => {
    try {
        replaceNav(f);
    } catch(e) {
        console.log(`Error on ${f}: ${e.message}`);
    }
});
