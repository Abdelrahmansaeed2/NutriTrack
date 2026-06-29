import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../cubits/grocery_cubit.dart';
import '../cubits/grocery_state.dart';
import '../widgets/grocery_category_section.dart';
import '../widgets/grocery_progress_card.dart';

class GroceryListScreen extends StatefulWidget {
  const GroceryListScreen({super.key});

  @override
  State<GroceryListScreen> createState() => _GroceryListScreenState();
}

class _GroceryListScreenState extends State<GroceryListScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<GroceryCubit>().loadGroceryLists();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeader(),
            Expanded(
              child: BlocBuilder<GroceryCubit, GroceryState>(
                builder: (context, state) {
                  if (state is GroceryLoading || state is GroceryGenerating) {
                    return const Center(
                      child:
                          CircularProgressIndicator(color: Color(0xFF1DB574)),
                    );
                  }
                  if (state is GroceryError) {
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(Icons.error_outline,
                              size: 48, color: Colors.grey),
                          const SizedBox(height: 12),
                          Text(state.message,
                              style: const TextStyle(color: Colors.grey)),
                          const SizedBox(height: 16),
                          ElevatedButton(
                            onPressed: () =>
                                context.read<GroceryCubit>().loadGroceryLists(),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF1DB574),
                            ),
                            child: const Text('Retry'),
                          ),
                        ],
                      ),
                    );
                  }
                  if (state is GroceryLoaded) {
                    final list = state.selectedList;
                    final grouped = list.groupedByCategory;
                    return SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: 16),
                          GroceryProgressCard(
                            totalItems: list.totalItems,
                            remainingItems: list.remainingItems,
                            onClearChecked: () =>
                                context.read<GroceryCubit>().clearChecked(),
                          ),
                          const SizedBox(height: 12),
                          ...grouped.entries.map((entry) => Column(
                                children: [
                                  GroceryCategorySection(
                                    category: entry.key,
                                    items: entry.value,
                                    onToggle: (item) =>
                                        context.read<GroceryCubit>().toggleItem(
                                              item.name,
                                              item.isChecked,
                                            ),
                                  ),
                                  const SizedBox(height: 12),
                                ],
                              )),
                          const SizedBox(height: 24),
                        ],
                      ),
                    );
                  }
                  return const SizedBox.shrink();
                },
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showAddItemDialog(context),
        backgroundColor: const Color(0xFF1DB574),
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              const CircleAvatar(
                radius: 18,
                backgroundColor: Color(0xFF1DB574),
                child: Icon(Icons.person, color: Colors.white, size: 18),
              ),
              const SizedBox(width: 8),
              Text(
                'NutriTrack AI',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      color: const Color(0xFF1DB574),
                      fontWeight: FontWeight.bold,
                    ),
              ),
            ],
          ),
          IconButton(
            icon: const Icon(Icons.notifications_outlined),
            color: const Color(0xFF1DB574),
            onPressed: () {},
          ),
        ],
      ),
    );
  }

  void _showAddItemDialog(BuildContext context) {
    final nameController = TextEditingController();
    final quantityController = TextEditingController();
    String selectedCategory = 'Produce';
    const categories = [
      'Produce',
      'Dairy',
      'Meat & Proteins',
      'Grains',
      'Pantry',
      'Beverages',
      'Other',
    ];
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) => Padding(
        padding: EdgeInsets.only(
          left: 16,
          right: 16,
          top: 24,
          bottom: MediaQuery.of(context).viewInsets.bottom + 24,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Add Item',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: nameController,
              decoration: InputDecoration(
                hintText: 'Item name',
                filled: true,
                fillColor: Colors.grey[100],
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
            const SizedBox(height: 12),
            StatefulBuilder(
              builder: (context, setModalState) =>
                  DropdownButtonFormField<String>(
                initialValue: selectedCategory,
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Colors.grey[100],
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide.none,
                  ),
                ),
                items: categories
                    .map((c) => DropdownMenuItem(value: c, child: Text(c)))
                    .toList(),
                onChanged: (val) =>
                    setModalState(() => selectedCategory = val!),
              ),
            ),
            TextField(
              controller: quantityController,
              decoration: InputDecoration(
                hintText: 'Quantity (e.g. 1 kg)',
                filled: true,
                fillColor: Colors.grey[100],
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  if (nameController.text.isNotEmpty &&
                      quantityController.text.isNotEmpty) {
                    final state = context.read<GroceryCubit>().state;
                    if (state is GroceryLoaded) {
                      context.read<GroceryCubit>().addItem(
                            listId: state.selectedList.id,
                            name: nameController.text.trim(),
                            quantity: quantityController.text.trim(),
                              category: selectedCategory,
                          );
                    }
                    Navigator.pop(context);
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF1DB574),
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: const Text(
                  'Add Item',
                  style: TextStyle(color: Colors.white, fontSize: 15),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
