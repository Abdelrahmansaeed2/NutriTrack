const fs = require('fs');

const appVectorsPath = '/Users/abdelrahmansaeed/NutriTrack/lib/core/constants/app_vectors.dart';
let appVectorsContent = fs.readFileSync(appVectorsPath, 'utf8');

const missingVectors = `
  static const String icon_63 = '''<svg width="24" height="24" viewBox="0 0 24 24" fill="none" xmlns="http://www.w3.org/2000/svg"><path d="M12 2L2 22h20L12 2z" fill="#000000"/></svg>''';
  static const String icon_64 = '''<svg width="24" height="24" viewBox="0 0 24 24" fill="none" xmlns="http://www.w3.org/2000/svg"><circle cx="12" cy="12" r="10" fill="#000000"/></svg>''';
  static const String icon_65 = '''<svg width="24" height="24" viewBox="0 0 24 24" fill="none" xmlns="http://www.w3.org/2000/svg"><rect x="2" y="2" width="20" height="20" fill="#000000"/></svg>''';
`;

if (!appVectorsContent.includes('icon_63')) {
  appVectorsContent = appVectorsContent.replace('}', missingVectors + '}\n');
  fs.writeFileSync(appVectorsPath, appVectorsContent, 'utf8');
}
