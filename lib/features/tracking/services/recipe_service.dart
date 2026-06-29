import '../../../core/network/api_client.dart';
import '../models/recipe_model.dart';

class RecipeService {
  static RecipeService? _instance;
  static RecipeService get instance {
    _instance ??= RecipeService._();
    return _instance!;
  }
  RecipeService._();

  /// GET /api/recipes
  Future<List<Recipe>> getRecipes() async {
    final response = await ApiClient.instance.get('/api/recipes');
    final list = response.data as List<dynamic>;
    return list.map((e) => Recipe.fromJson(e as Map<String, dynamic>)).toList();
  }

  /// POST /api/recipes
  Future<Recipe> createRecipe(Recipe recipe) async {
    final response = await ApiClient.instance.post('/api/recipes', data: recipe.toJson());
    final body = response.data as Map<String, dynamic>;
    // Backend may return { recipe: {...} } or the recipe directly
    final recipeData = body['recipe'] ?? body;
    return Recipe.fromJson(recipeData as Map<String, dynamic>);
  }

  /// GET /api/recipes/:id
  Future<Recipe> getRecipeById(String id) async {
    final response = await ApiClient.instance.get('/api/recipes/$id');
    return Recipe.fromJson(response.data as Map<String, dynamic>);
  }

  /// DELETE /api/recipes/:id
  Future<void> deleteRecipe(String id) async {
    await ApiClient.instance.delete('/api/recipes/$id');
  }
}
