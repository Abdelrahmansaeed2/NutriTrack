const getFoods = async (req, res, next) => {
  try {
    const { query, tag } = req.query;
    
    // Mock data based on Figma screen "API Food Search & Barcode"
    let mockFoods = [
      { id: '1', name: 'Grilled Chicken Breast', brand: 'Kirkland Signature', servingSize: '4 oz', calories: 130, macros: { protein: 26, carbs: 0, fat: 2 }, tags: ['High Protein'] },
      { id: '2', name: 'Greek Yogurt, Plain Nonfat', brand: 'Chobani', servingSize: '1 cup', calories: 120, macros: { protein: 22, carbs: 9, fat: 0 }, tags: ['High Protein', 'Vegetarian'] },
      { id: '3', name: 'Almonds, Roasted & Salted', brand: 'Blue Diamond', servingSize: '1 oz', calories: 170, macros: { protein: 6, carbs: 5, fat: 15 }, tags: ['Keto', 'Vegan'] }
    ];

    if (query) {
      mockFoods = mockFoods.filter(f => f.name.toLowerCase().includes(query.toLowerCase()));
    }

    if (tag && tag.toLowerCase() !== 'all') {
      mockFoods = mockFoods.filter(f => 
        f.tags && f.tags.some(t => t.toLowerCase() === tag.toLowerCase())
      );
    }

    res.status(200).json(mockFoods);
  } catch (error) {
    next(error);
  }
};

const getFoodById = async (req, res, next) => {
  try {
    const { id } = req.params;
    // Mock for Dynamic Food Detail screen
    const mockDetail = {
      id,
      name: 'Grilled Salmon',
      brand: 'Atlantic Salmon, wild caught',
      servingSize: '150g',
      calories: 312,
      macros: { protein: 34, carbs: 0, fat: 18 },
      micronutrients: { vitD: 'high', omega3: 'high', b12: 'moderate' },
      tags: ['HIGH PROTEIN']
    };
    
    res.status(200).json(mockDetail);
  } catch (error) {
    next(error);
  }
};

const scanBarcode = async (req, res, next) => {
  try {
    const { barcode } = req.body;
    if (!barcode) return res.status(400).json({ error: 'Barcode is required' });

    // Mock API response for barcode
    const mockFood = {
      id: `bc_${barcode}`,
      name: 'Mocked Barcode Item',
      brand: 'Scanned Brand',
      servingSize: '1 container',
      calories: 250,
      macros: { protein: 15, carbs: 30, fat: 8 }
    };
    res.status(200).json(mockFood);
  } catch (error) {
    next(error);
  }
};

const getFavorites = async (req, res, next) => {
  try {
    const uid = req.user.uid;
    // Mock database fetch for favorites
    res.status(200).json([{ id: '1', name: 'Grilled Chicken Breast', brand: 'Kirkland Signature', servingSize: '4 oz', calories: 130, macros: { protein: 26, carbs: 0, fat: 2 }, tags: ['High Protein'] }]);
  } catch (error) {
    next(error);
  }
};

const addFavorite = async (req, res, next) => {
  try {
    const uid = req.user.uid;
    const { id } = req.params;
    res.status(200).json({ message: 'Added to favorites', foodId: id });
  } catch (error) {
    next(error);
  }
};

const removeFavorite = async (req, res, next) => {
  try {
    const uid = req.user.uid;
    const { id } = req.params;
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
