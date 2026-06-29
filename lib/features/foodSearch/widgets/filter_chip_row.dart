import 'package:flutter/material.dart';

class FilterChipRow extends StatelessWidget {
  final List<String> tags;
  final String selectedTag;
  final ValueChanged<String> onTagSelected;

  const FilterChipRow({
    super.key,
    required this.tags,
    required this.selectedTag,
    required this.onTagSelected,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 36,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: tags.length,
        separatorBuilder: (_, __) => const SizedBox(width: 8),
        itemBuilder: (context, index) {
          final tag = tags[index];
          final isSelected = tag.toLowerCase() == selectedTag.toLowerCase();
          return GestureDetector(
            onTap: () => onTagSelected(tag),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
              decoration: BoxDecoration(
                color: isSelected ? const Color(0xFF1DB574) : Colors.white,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: isSelected ? const Color(0xFF1DB574) : Colors.grey[300]!,
                ),
              ),
              child: Text(
                tag,
                style: TextStyle(
                  color: isSelected ? Colors.white : Colors.grey[700],
                  fontSize: 13,
                  fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}