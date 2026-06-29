const { db } = require('../config/firebase.config');

const mapProduct = (product) => {
  if (!product) return null;

  const nutriments = product.nutriments || {};
  
  // Calculate energy in kcal per 100g or serving
  let calories = 0;
  if (nutriments['energy-kcal_100g'] !== undefined) {
    calories = Math.round(nutriments['energy-kcal_100g']);
  } else if (nutriments['energy-kcal_serving'] !== undefined) {
    calories = Math.round(nutriments['energy-kcal_serving']);
  } else if (nutriments['energy_100g'] !== undefined) {
    // Convert kJ to kcal
    calories = Math.round(nutriments['energy_100g'] / 4.184);
  }

  const protein = Math.round(nutriments['proteins_100g'] || nutriments['proteins_serving'] || 0);
  const carbs = Math.round(nutriments['carbohydrates_100g'] || nutriments['carbohydrates_serving'] || 0);
  const fat = Math.round(nutriments['fat_100g'] || nutriments['fat_serving'] || 0);

  // Generate tags based on characteristics
  const tags = [];
  if (protein > 15) tags.push('High Protein');
  if (carbs < 5) tags.push('Keto');
  
  const ingredientsAnalysis = product.ingredients_analysis_tags || [];
  if (ingredientsAnalysis.includes('en:vegan')) {
    tags.push('Vegan');
  } else if (ingredientsAnalysis.includes('en:vegetarian')) {
    tags.push('Vegetarian');
  }

  // Fallback tag if empty
  if (tags.length === 0) tags.push('Standard');

  return {
    id: product.code || product._id || Math.random().toString(),
    name: product.product_name || product.product_name_en || 'Unknown Food',
    brand: product.brands || 'Generic',
    servingSize: product.serving_size || '100g',
    calories: calories || 0,
    macros: { protein, carbs, fat },
    tags
  };
};

const getFoods = async (req, res, next) => {
  try {
    const { query, tag } = req.query;
    
    // Default search if none is provided so user gets some items
    const searchQuery = query || 'chicken';

    let url = `https://world.openfoodfacts.org/cgi/search.pl?json=true&page_size=24&search_terms=${encodeURIComponent(searchQuery)}`;

    const response = await fetch(url, {
      headers: { 'User-Agent': 'NutriTrack - Node.js Backend - Version 1.0' }
    });
    
    if (!response.ok) {
      return res.status(200).json([]);
    }

    const contentType = response.headers.get('content-type') || '';
    if (!contentType.includes('application/json')) {
      return res.status(200).json([]);
    }

    const data = await response.json();
    
    const products = data.products || [];
    let mappedFoods = products.map(mapProduct).filter(Boolean);

    // Apply local tag filter if requested
    if (tag && tag.toLowerCase() !== 'all') {
      mappedFoods = mappedFoods.filter(f => 
        f.tags && f.tags.some(t => t.toLowerCase() === tag.toLowerCase())
      );
    }

    res.status(200).json(mappedFoods);
  } catch (error) {
    next(error);
  }
};

const getFoodById = async (req, res, next) => {
  try {
    const { id } = req.params;
    
    const url = `https://world.openfoodfacts.org/api/v2/product/${id}.json`;
    const response = await fetch(url, {
      headers: { 'User-Agent': 'NutriTrack - Node.js Backend - Version 1.0' }
    });
    
    if (!response.ok) {
      return res.status(404).json({ error: 'Product not found' });
    }

    const data = await response.json();
    if (!data.product) {
      return res.status(404).json({ error: 'Product details not found' });
    }

    const mappedFood = mapProduct(data.product);
    
    // Add micronutrients detail for details page
    const nutriments = data.product.nutriments || {};
    mappedFood.micronutrients = {
      vitD: nutriments['vitamin-d_100g'] !== undefined ? 'present' : 'none',
      omega3: nutriments['omega-3-fatty-acids_100g'] !== undefined ? 'present' : 'none',
      b12: nutriments['vitamin-b12_100g'] !== undefined ? 'present' : 'none'
    };

    res.status(200).json(mappedFood);
  } catch (error) {
    next(error);
  }
};

const scanBarcode = async (req, res, next) => {
  try {
    const { barcode } = req.body;
    if (!barcode) return res.status(400).json({ error: 'Barcode is required' });

    const url = `https://world.openfoodfacts.org/api/v2/product/${barcode}.json`;
    const response = await fetch(url, {
      headers: { 'User-Agent': 'NutriTrack - Node.js Backend - Version 1.0' }
    });
    
    if (!response.ok) {
      return res.status(404).json({ error: 'Product not found' });
    }

    const data = await response.json();
    if (!data.product) {
      return res.status(404).json({ error: 'Product details not found' });
    }

    const mappedFood = mapProduct(data.product);
    res.status(200).json(mappedFood);
  } catch (error) {
    next(error);
  }
};

const getFavorites = async (req, res, next) => {
  try {
    const uid = req.user.uid;
    const snapshot = await db.collection('users').doc(uid).collection('favorites').get();
    const favorites = snapshot.docs.map(doc => doc.data());
    res.status(200).json(favorites);
  } catch (error) {
    next(error);
  }
};

const addFavorite = async (req, res, next) => {
  try {
    const uid = req.user.uid;
    const { id } = req.params;
    
    let foodItem = req.body;
    
    // If body is empty, fetch the details from Open Food Facts
    if (!foodItem || !foodItem.name) {
      const url = `https://world.openfoodfacts.org/api/v2/product/${id}.json`;
      const response = await fetch(url, {
        headers: { 'User-Agent': 'NutriTrack - Node.js Backend - Version 1.0' }
      });
      if (response.ok) {
        const data = await response.json();
        if (data.product) {
          foodItem = mapProduct(data.product);
        }
      }
    }
    
    if (!foodItem || !foodItem.name) {
      return res.status(400).json({ error: 'Food item details could not be retrieved' });
    }

    await db.collection('users').doc(uid).collection('favorites').doc(id).set(foodItem);
    res.status(200).json({ message: 'Added to favorites', foodId: id, food: foodItem });
  } catch (error) {
    next(error);
  }
};

const removeFavorite = async (req, res, next) => {
  try {
    const uid = req.user.uid;
    const { id } = req.params;
    await db.collection('users').doc(uid).collection('favorites').doc(id).delete();
    res.status(200).json({ message: 'Removed from favorites', foodId: id });
  } catch (error) {
    next(error);
  }
};

const createCustomFood = async (req, res, next) => {
  try {
    const uid = req.user.uid;
    const { name, servingSize, calories, macros } = req.body;
    if (!name || !calories || !macros) {
      return res.status(400).json({ error: 'Name, calories, and macros are required' });
    }
    
    const newFood = {
      id: `custom_${Date.now()}`,
      userId: uid,
      name,
      brand: 'Custom',
      servingSize: servingSize || '1 serving',
      calories,
      macros,
      isCustom: true
    };
    
    res.status(201).json({ message: 'Custom food created', food: newFood });
  } catch (error) {
    next(error);
  }
};

module.exports = {
  getFoods,
  getFoodById,
  scanBarcode,
  getFavorites,
  addFavorite,
  removeFavorite,
  createCustomFood
};
