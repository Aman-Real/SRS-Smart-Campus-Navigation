import 'package:flutter/material.dart';

class FilterChips extends StatefulWidget {
  final List<String> categories;
  final List<String> selectedCategories;
  final Function(List<String>) onSelectionChanged;

  const FilterChips({
    Key? key,
    required this.categories,
    required this.selectedCategories,
    required this.onSelectionChanged,
  }) : super(key: key);

  @override
  State<FilterChips> createState() => _FilterChipsState();
}

class _FilterChipsState extends State<FilterChips> {
  late List<String> _selected;

  @override
  void initState() {
    super.initState();
    _selected = List.from(widget.selectedCategories);
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: widget.categories.map((category) {
          final isSelected = _selected.contains(category);
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4),
            child: FilterChip(
              label: Text(category),
              selected: isSelected,
              onSelected: (bool selected) {
                setState(() {
                  if (selected) {
                    _selected.add(category);
                  } else {
                    _selected.removeWhere((element) => element == category);
                  }
                });
                widget.onSelectionChanged(_selected);
              },
              backgroundColor: Colors.transparent,
              side: BorderSide(
                color: isSelected
                    ? Theme.of(context).primaryColor
                    : Colors.grey[400]!,
              ),
              labelStyle: TextStyle(
                color: isSelected
                    ? Theme.of(context).primaryColor
                    : Colors.grey[700],
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}
