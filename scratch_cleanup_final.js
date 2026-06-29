const fs = require('fs');

function removeNav(file) {
  let content = fs.readFileSync(file, 'utf8');
  
  if (content.includes('// Custom Bottom Navigation Bar')) {
    const parts = content.split('// Custom Bottom Navigation Bar');
    if (parts.length > 1) {
        let before = parts[0];
        let after = parts[1];
        
        let containerIndex = after.indexOf('Container(');
        if (containerIndex !== -1) {
            let braceCount = 1;
            let i = containerIndex + 'Container('.length;
            while(braceCount > 0 && i < after.length) {
                if (after[i] === '(') braceCount++;
                if (after[i] === ')') braceCount--;
                i++;
            }
            if (after[i] === ',') i++;
            
            content = before + after.substring(i);
            fs.writeFileSync(file, content, 'utf8');
            console.log(`Cleaned redundant bottom nav from ${file}`);
        }
    }
  }
}

removeNav('/Users/abdelrahmansaeed/NutriTrack/lib/presentation/screens/advanced_daily_dashboard_screen.dart');
removeNav('/Users/abdelrahmansaeed/NutriTrack/lib/presentation/screens/api_food_search_screen.dart');
removeNav('/Users/abdelrahmansaeed/NutriTrack/lib/presentation/screens/ai_weekly_calendar_screen.dart');
