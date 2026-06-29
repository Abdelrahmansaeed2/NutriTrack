
import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nutri_track/core/network/api_client.dart';
import '../models/custom_recipe_models.dart';
import '../cubits/recipe_cubit.dart';
import '../cubits/recipe_state.dart';
import '../services/recipe_service.dart';

class CustomRecipeBuilderScreen extends StatefulWidget {
  final String? date;
  final String? mealType;
  const CustomRecipeBuilderScreen({super.key, this.date, this.mealType});

  @override
  State<CustomRecipeBuilderScreen> createState() =>
      _CustomRecipeBuilderScreenState();
}

class _CustomRecipeBuilderScreenState
    extends State<CustomRecipeBuilderScreen> {
  final _nameController = TextEditingController();

  final List<RecipeIngredient> _ingredients = [
    const RecipeIngredient(name: 'Rolled Oats',              quantity: '40g',         kcal: 152),
    const RecipeIngredient(name: 'Whey Protein Isolate',     quantity: '30g (1 Scoop)',kcal: 110),
    const RecipeIngredient(name: 'Almond Milk (Unsweetened)',quantity: '200ml',        kcal: 30),
  ];

  RecipeMacros get _macros => RecipeMacros.fromIngredients(_ingredients);

  void _removeIngredient(int index) {
    setState(() => _ingredients.removeAt(index));
  }

  void _showIngredientDialog({int? editIndex}) {
    final isEditing = editIndex != null;
    final ingredient = isEditing ? _ingredients[editIndex] : null;

    final nameController = TextEditingController(text: ingredient?.name);
    final qtyController = TextEditingController(text: ingredient?.quantity);
    final kcalController = TextEditingController(
        text: ingredient != null ? ingredient.kcal.toString() : '');

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(isEditing ? 'Edit Ingredient' : 'Add Ingredient'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: nameController,
                decoration: const InputDecoration(
                  labelText: 'Ingredient Name',
                  hintText: 'e.g. Rolled Oats',
                ),
              ),
              const SizedBox(height: 8),
              TextField(
                controller: qtyController,
                decoration: const InputDecoration(
                  labelText: 'Quantity',
                  hintText: 'e.g. 40g or 1 cup',
                ),
              ),
              const SizedBox(height: 8),
              TextField(
                controller: kcalController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: 'Calories (kcal)',
                  hintText: 'e.g. 150',
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                final name = nameController.text.trim();
                final qty = qtyController.text.trim();
                final kcal = int.tryParse(kcalController.text.trim()) ?? 0;

                if (name.isNotEmpty && qty.isNotEmpty) {
                  setState(() {
                    if (isEditing) {
                      _ingredients[editIndex] = RecipeIngredient(
                        name: name,
                        quantity: qty,
                        kcal: kcal,
                      );
                    } else {
                      _ingredients.add(RecipeIngredient(
                        name: name,
                        quantity: qty,
                        kcal: kcal,
                      ));
                    }
                  });
                  Navigator.pop(context);
                }
              },
              child: Text(isEditing ? 'Save' : 'Add'),
            ),
          ],
        );
      },
    );
  }

  void _addIngredient() {
    _showIngredientDialog();
  }

  void _saveRecipe(BuildContext context) {
    if (_nameController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter a recipe name')),
      );
      return;
    }
    context.read<RecipeCubit>().saveRecipe(
          name: _nameController.text.trim(),
          ingredients: _ingredients,
          macros: _macros,
          date: widget.date,
          mealType: widget.mealType,
        );
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return BlocProvider(
      create: (_) => RecipeCubit(RecipeService(ApiClient.instance.dio)),
      child: BlocConsumer<RecipeCubit, RecipeState>(
        listener: (context, state) {
          if (state is RecipeSuccess) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Recipe saved successfully!')),
            );
            Navigator.pop(context);
          } else if (state is RecipeError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.message)),
            );
          }
        },
        builder: (context, state) {
          return Scaffold(
            backgroundColor: cs.surface,
            body: SafeArea(
              child: Stack(
                children: [
                  Column(
                    children: [
                      _TopBar(),
                      Expanded(
                        child: SingleChildScrollView(
                          padding: const EdgeInsets.fromLTRB(16, 24, 16, 200),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              _RecipeNameInput(controller: _nameController),
                              const SizedBox(height: 24),
                              _IngredientsCard(
                                ingredients: _ingredients,
                                onRemove: _removeIngredient,
                                onEdit: (index) => _showIngredientDialog(editIndex: index),
                                onAdd: _addIngredient,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                  // Sticky footer
                  _StickyFooter(
                    macros: _macros,
                    onSave: () => _saveRecipe(context),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

class _TopBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: cs.surface,
        border: Border(bottom: BorderSide(color: cs.surfaceContainerHighest)),
      ),
      child: Row(
        children: [
          Material(
            color: Colors.transparent,
            child: InkWell(
              borderRadius: BorderRadius.circular(99),
              onTap: () => Navigator.pop(context),
              child: Padding(
                padding: const EdgeInsets.all(8),
                child: Icon(Icons.arrow_back, color: cs.onSurfaceVariant),
              ),
            ),
          ),
          Expanded(
            child: Text('Builder',
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.titleMedium),
          ),
          // Spacer 
          const SizedBox(width: 40),
        ],
      ),
    );
  }
}


class _RecipeNameInput extends StatelessWidget {
  final TextEditingController controller;
  const _RecipeNameInput({required this.controller});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('RECIPE NAME',
            style: TextStyle(
              fontFamily: 'Inter',
              fontSize: 11,
              fontWeight: FontWeight.w500,
              letterSpacing: 0.8,
              color: cs.onSurfaceVariant,
            )),
        const SizedBox(height: 8),
        TextField(
          controller: controller,
          style: TextStyle(
            fontFamily: 'Inter',
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: cs.onSurface,
          ),
          decoration: InputDecoration(
            hintText: 'e.g. Protein Packed Oats',
            hintStyle: TextStyle(
              fontFamily: 'Inter',
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: cs.outlineVariant,
            ),
            filled: true,
            fillColor: const Color(0xFFF3F4F6),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide.none,
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: cs.primaryContainer, width: 2),
            ),
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          ),
        ),
      ],
    );
  }
}


class _IngredientsCard extends StatelessWidget {
  final List<RecipeIngredient> ingredients;
  final ValueChanged<int> onRemove;
  final ValueChanged<int> onEdit;
  final VoidCallback onAdd;

  const _IngredientsCard({
    required this.ingredients,
    required this.onRemove,
    required this.onEdit,
    required this.onAdd,
  });

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: cs.surfaceContainerLowest,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF1F2937).withValues(alpha: 0.05),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          // Header
          Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Ingredients',
                    style: Theme.of(context).textTheme.titleMedium),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: cs.surfaceContainer,
                    borderRadius: BorderRadius.circular(99),
                  ),
                  child: Text('${ingredients.length} Items',
                      style: TextStyle(
                        fontFamily: 'Inter',
                        fontSize: 11,
                        fontWeight: FontWeight.w500,
                        letterSpacing: 0.5,
                        color: cs.onSurfaceVariant,
                      )),
                ),
              ],
            ),
          ),
          Divider(color: cs.surfaceContainerHighest, height: 1),
          const SizedBox(height: 8),
          // Ingredient List
          ...ingredients.asMap().entries.map((e) {
            return _IngredientItem(
              ingredient: e.value,
              onRemove: () => onRemove(e.key),
              onTap: () => onEdit(e.key),
            );
          }),
          const SizedBox(height: 8),
          // Add Button
          _AddIngredientButton(onTap: onAdd),
        ],
      ),
    );
  }
}

class _IngredientItem extends StatefulWidget {
  final RecipeIngredient ingredient;
  final VoidCallback onRemove;
  final VoidCallback onTap;
  const _IngredientItem({required this.ingredient, required this.onRemove, required this.onTap});

  @override
  State<_IngredientItem> createState() => _IngredientItemState();
}

class _IngredientItemState extends State<_IngredientItem> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return MouseRegion(
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10),
        child: GestureDetector(
          onTap: widget.onTap,
          behavior: HitTestBehavior.opaque,
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(widget.ingredient.name,
                        style: Theme.of(context)
                            .textTheme
                            .bodyLarge
                            ?.copyWith(fontWeight: FontWeight.w500)),
                    const SizedBox(height: 2),
                    Text(widget.ingredient.quantity,
                        style: Theme.of(context).textTheme.labelSmall),
                  ],
                ),
              ),
              Text('${widget.ingredient.kcal} kcal',
                  style: TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    color: cs.onSurface,
                  )),
              const SizedBox(width: 8),
              // Delete button 
              GestureDetector(
                onTap: widget.onRemove,
                child: AnimatedOpacity(
                  opacity: _hovered ? 1.0 : 0.4,
                  duration: const Duration(milliseconds: 150),
                  child: Icon(Icons.close,
                      size: 18, color: cs.error),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}


class _AddIngredientButton extends StatelessWidget {
  final VoidCallback onTap;
  const _AddIngredientButton({required this.onTap});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: onTap,
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(vertical: 14),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: cs.primaryContainer.withValues(alpha: 0.5),
              width: 2,
              // dashed border 
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.add, color: cs.primaryContainer, size: 20),
              const SizedBox(width: 8),
              Text('Add Ingredient',
                  style: TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: cs.primaryContainer,
                  )),
            ],
          ),
        ),
      ),
    );
  }
}

class _StickyFooter extends StatelessWidget {
  final RecipeMacros macros;
  final VoidCallback onSave;
  const _StickyFooter({required this.macros, required this.onSave});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final state = context.watch<RecipeCubit>().state;

    final rings = [
      MacroRingData(
        label: 'PRO',
        grams: macros.protein,
        ringColor: const Color(0xFFEF4444),
        bgColor: const Color(0xFFFFB3AD),
        progress: (macros.protein / 50).clamp(0, 1),
      ),
      MacroRingData(
        label: 'CARB',
        grams: macros.carbs,
        ringColor: const Color(0xFF3B82F6),
        bgColor: const Color(0xFFADC6FF),
        progress: (macros.carbs / 100).clamp(0, 1),
      ),
      MacroRingData(
        label: 'FAT',
        grams: macros.fat,
        ringColor: const Color(0xFFEAB308),
        bgColor: const Color(0xFFFEF08A),
        progress: (macros.fat / 30).clamp(0, 1),
      ),
    ];

    return Positioned(
      bottom: 0, left: 0, right: 0,
      child: Container(
        decoration: BoxDecoration(
          color: cs.surfaceContainerLowest,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
          border: Border(top: BorderSide(color: cs.surfaceContainerHighest)),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFF1F2937).withValues(alpha: 0.08),
              blurRadius: 24,
              offset: const Offset(0, -8),
            ),
          ],
        ),
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Macros row
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                // Total Calories
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('TOTAL CALORIES',
                        style: TextStyle(
                          fontFamily: 'Inter',
                          fontSize: 11,
                          fontWeight: FontWeight.w500,
                          letterSpacing: 0.8,
                          color: cs.onSurfaceVariant,
                        )),
                    const SizedBox(height: 4),
                    RichText(
                      text: TextSpan(
                        children: [
                          TextSpan(
                            text: '${macros.totalKcal}',
                            style: TextStyle(
                              fontFamily: 'Inter',
                              fontSize: 24,
                              fontWeight: FontWeight.w700,
                              color: cs.onSurface,
                            ),
                          ),
                          TextSpan(
                            text: ' kcal',
                            style: TextStyle(
                              fontFamily: 'Inter',
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                              color: cs.onSurfaceVariant,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                // Macro Rings
                Row(
                  children: rings
                      .map((r) => Padding(
                            padding: const EdgeInsets.only(left: 16),
                            child: _MacroRing(data: r),
                          ))
                      .toList(),
                ),
              ],
            ),
            const SizedBox(height: 16),
            // Save Button
            ElevatedButton.icon(
              onPressed: state is RecipeLoading ? null : onSave,
              icon: state is RecipeLoading
                  ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: Colors.white,
                      ),
                    )
                  : const Icon(Icons.save_rounded),
              label: Text(state is RecipeLoading ? 'Saving...' : 'Save Recipe'),
              style: ElevatedButton.styleFrom(
                minimumSize: const Size(double.infinity, 52),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}


class _MacroRing extends StatelessWidget {
  final MacroRingData data;
  const _MacroRing({required this.data});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Column(
      children: [
        Text(data.label,
            style: TextStyle(
              fontFamily: 'Inter',
              fontSize: 11,
              fontWeight: FontWeight.w500,
              letterSpacing: 0.5,
              color: cs.onSurfaceVariant,
            )),
        const SizedBox(height: 4),
        SizedBox(
          width: 40,
          height: 40,
          child: Stack(
            alignment: Alignment.center,
            children: [
              // Background circle
              Container(
                decoration: BoxDecoration(
                  color: data.bgColor.withValues(alpha: 0.2),
                  shape: BoxShape.circle,
                ),
              ),
              // Ring
              CustomPaint(
                size: const Size(40, 40),
                painter: _MiniRingPainter(
                  progress: data.progress,
                  color: data.ringColor,
                ),
              ),
              // Label
              Text('${data.grams.round()}g',
                  style: TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 10,
                    fontWeight: FontWeight.w600,
                    color: cs.onSurface,
                  )),
            ],
          ),
        ),
      ],
    );
  }
}

class _MiniRingPainter extends CustomPainter {
  final double progress;
  final Color color;
  const _MiniRingPainter({required this.progress, required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final cx = size.width / 2;
    final cy = size.height / 2;
    final radius = size.width / 2 - 3;
    const strokeWidth = 3.0;

    canvas.drawArc(
      Rect.fromCircle(center: Offset(cx, cy), radius: radius),
      -math.pi / 2,
      2 * math.pi * progress,
      false,
      Paint()
        ..color = color
        ..style = PaintingStyle.stroke
        ..strokeWidth = strokeWidth
        ..strokeCap = StrokeCap.round,
    );
  }

  @override
  bool shouldRepaint(_MiniRingPainter old) =>
      old.progress != progress || old.color != color;
}