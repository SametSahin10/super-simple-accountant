import 'package:flutter/material.dart';
import 'package:super_simple_accountant/colors.dart';
import 'package:super_simple_accountant/default_categories.dart';
import 'package:super_simple_accountant/extensions.dart';
import 'package:super_simple_accountant/models/category.dart';

class CategoryDropdown extends StatefulWidget {
  final Category? initialCategory;
  final Function(Category) onCategorySelected;

  const CategoryDropdown({
    super.key,
    required this.onCategorySelected,
    this.initialCategory,
  });

  @override
  State<CategoryDropdown> createState() => _CategoryDropdownState();
}

class _CategoryDropdownState extends State<CategoryDropdown> {
  Category? _selectedCategory;

  @override
  void initState() {
    super.initState();
    _selectedCategory = widget.initialCategory;
  }

  @override
  Widget build(BuildContext context) {
    return DropdownButtonHideUnderline(
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey),
          borderRadius: BorderRadius.circular(5.0),
        ),
        child: DropdownButton<Category>(
          value: _selectedCategory,
          itemHeight: null,
          isExpanded: true,
          icon: const Padding(
            padding: EdgeInsets.only(right: 8),
            child: Icon(Icons.arrow_drop_down, color: primaryColor),
          ),
          hint: Container(
            padding: const EdgeInsets.symmetric(vertical: 22, horizontal: 16),
            child: Row(
              children: [
                const Icon(Icons.category, color: primaryColor, size: 22),
                const SizedBox(width: 10),
                Text(
                  context.l10n.categoryDropdownHint,
                  style: const TextStyle(fontSize: 16),
                ),
              ],
            ),
          ),
          onChanged: (Category? newValue) {
            setState(() {
              _selectedCategory = newValue;
            });

            widget.onCategorySelected(newValue!);
          },
          items: _createItems(context).toList(),
        ),
      ),
    );
  }

  Iterable<DropdownMenuItem<Category>> _createItems(BuildContext context) {
    return defaultCategories.map<DropdownMenuItem<Category>>(
      (Category category) {
        final icon = categoryIcons[category.id];
        final categoryName = getTranslatedCategoryName(context, category.id);

        return DropdownMenuItem<Category>(
          value: category,
          child: Padding(
            padding: const EdgeInsets.only(left: 12),
            child: Row(
              children: [
                Icon(icon, color: primaryColor, size: 22),
                const SizedBox(width: 12),
                Padding(
                  padding: const EdgeInsets.only(top: 3),
                  child: Text(categoryName),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
