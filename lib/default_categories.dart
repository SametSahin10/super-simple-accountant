import 'package:flutter/material.dart';
import 'package:super_simple_accountant/extensions.dart';
import 'package:super_simple_accountant/models/category.dart';

final defaultCategories = <Category>[
  Category(id: 1, name: 'Food & Drinks'),
  Category(id: 2, name: 'Shopping'),
  Category(id: 3, name: 'Transport'),
  Category(id: 4, name: 'Home'),
  Category(id: 5, name: 'Entertainment'),
  Category(id: 6, name: 'Health'),
  Category(id: 7, name: 'Other'),
];

final categoryIcons = <int, IconData>{
  1: Icons.fastfood,
  2: Icons.shopping_cart,
  3: Icons.directions_bus,
  4: Icons.home,
  5: Icons.movie,
  6: Icons.local_hospital,
  7: Icons.category
};

String getTranslatedCategoryName(BuildContext context, int categoryId) {
  switch (categoryId) {
    case 1:
      return context.l10n.categoryFoodAndDrinks;
    case 2:
      return context.l10n.categoryShopping;
    case 3:
      return context.l10n.categoryTransport;
    case 4:
      return context.l10n.categoryHome;
    case 5:
      return context.l10n.categoryEntertainment;
    case 6:
      return context.l10n.categoryHealth;
    case 7:
      return context.l10n.categoryOther;
    default:
      return '';
  }
}
