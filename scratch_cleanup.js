const fs = require('fs');
const path = require('path');

const screensDir = '/Users/abdelrahmansaeed/NutriTrack/lib/presentation/screens';
const files = fs.readdirSync(screensDir).filter(f => f.endsWith('_screen.dart'));

let totalCleaned = 0;

files.forEach(file => {
  const filePath = path.join(screensDir, file);
  let content = fs.readFileSync(filePath, 'utf8');
  
  if (content.includes('// Bottom NavBar')) {
    // We want to delete the whole block starting with '// Bottom NavBar'
    // up to the end of the Container
    const regex = /\/\/ Bottom NavBar[\s\S]*?\]\s*,\s*\)\s*,/g;
    const newContent = content.replace(regex, '');
    
    // Some might end differently. Let's try to match the Container structure if regex fails or is too greedy
    // Actually, simple regex might fail due to nested brackets. 
    // Let's do simple string matching.
    const parts = content.split('// Bottom NavBar');
    if (parts.length > 1) {
        let before = parts[0];
        let after = parts[1];
        
        // Find the matching closing brace for Container(
        let containerIndex = after.indexOf('Container(');
        if (containerIndex !== -1) {
            let braceCount = 1;
            let i = containerIndex + 'Container('.length;
            while(braceCount > 0 && i < after.length) {
                if (after[i] === '(') braceCount++;
                if (after[i] === ')') braceCount--;
                i++;
            }
            
            // Add any trailing commas
            if (after[i] === ',') i++;
            
            content = before + after.substring(i);
            fs.writeFileSync(filePath, content, 'utf8');
            totalCleaned++;
            console.log(`Cleaned BottomNavBar from ${file}`);
        }
    }
  }
});

console.log(`Finished. Cleaned ${totalCleaned} files.`);
