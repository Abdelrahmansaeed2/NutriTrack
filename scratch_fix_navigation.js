const fs = require('fs');
const path = require('path');

const screensDir = '/Users/abdelrahmansaeed/NutriTrack/lib/presentation/screens';

function ensureGoRouterImport(content) {
    if (!content.includes("package:go_router/go_router.dart")) {
        return content.replace("import 'package:flutter/material.dart';", "import 'package:flutter/material.dart';\nimport 'package:go_router/go_router.dart';");
    }
    return content;
}

const replacements = [
    {
        file: 'login_screen.dart',
        replace: [
            {
                find: /Navigator\.pushAndRemoveUntil\([\s\S]*?\(route\) => false,\s*\);/g,
                with: "context.go('/home');"
            },
            {
                find: /Navigator\.push\([\s\S]*?PhysicalMetricsScreen\(\)\)\);/g,
                with: "context.go('/onboarding/metrics');"
            }
        ]
    },
    {
        file: 'splash_welcome_screen.dart',
        replace: [
            {
                find: /Navigator\.push\([\s\S]*?LoginScreen\(\)\)\);/g,
                with: "context.go('/login');"
            }
        ]
    },
    {
        file: 'advanced_daily_dashboard_screen.dart',
        replace: [
            {
                find: /Navigator\.push\([\s\S]*?WaterTrackingScreen\(\)\)\);/g,
                with: "context.go('/home/water');"
            }
        ]
    },
    {
        file: 'physical_metrics_screen.dart',
        replace: [
            {
                find: /Navigator\.push\([\s\S]*?ActivityGoalScreen\(\)\)\);/g,
                with: "context.go('/onboarding/activity');"
            }
        ]
    },
    {
        file: 'activity_goal_screen.dart',
        replace: [
            {
                find: /Navigator\.push\([\s\S]*?ApiFoodSearchScreen\(\)\)\);/g, // Wait, activity goal went to food search in the mock?
                with: "context.go('/home');"
            },
            {
                find: /Navigator\.push\([\s\S]*?AdvancedDailyDashboardScreen\(\)\)\);/g,
                with: "context.go('/home');"
            }
        ]
    },
    {
        file: 'ai_weekly_calendar_screen.dart',
        replace: [
            {
                find: /Navigator\.push\([\s\S]*?AIMealPlanSetupScreen\(\)\)\);/g,
                with: "context.go('/planner/meal_plan_setup');"
            }
        ]
    }
];

replacements.forEach(r => {
    const filePath = path.join(screensDir, r.file);
    if (fs.existsSync(filePath)) {
        let content = fs.readFileSync(filePath, 'utf8');
        let initialContent = content;
        
        r.replace.forEach(rep => {
            content = content.replace(rep.find, rep.with);
        });
        
        if (content !== initialContent) {
            content = ensureGoRouterImport(content);
            fs.writeFileSync(filePath, content, 'utf8');
            console.log(`Updated routing in ${r.file}`);
        }
    }
});
