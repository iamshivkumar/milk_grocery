import 'package:flutter/material.dart';
import 'package:grocery_app/core/models/category.dart';
import 'package:grocery_app/ui/pages/products/category_products_page.dart';

class CategoryCard extends StatelessWidget {
  const CategoryCard({Key? key, required this.category}) : super(key: key);
  final ProductCategory category;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => CategoryProductsPage(category: category.name),
        ),
      ),
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(4),
          child: Column(
            children: [
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(4),
                  child: Image.network(category.image),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(4),
                child: Text(category.name),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
