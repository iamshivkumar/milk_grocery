import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:grocery_app/ui/pages/home/providers/categories_provider.dart';
import 'package:grocery_app/ui/pages/home/providers/popular_products_provider.dart';
import 'package:grocery_app/ui/pages/home/widgets/cart_icon.dart';
import 'package:grocery_app/ui/pages/search/search_page.dart';
import 'package:grocery_app/ui/widgets/product_card.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'widgets/category_card.dart';

class HomePage extends ConsumerWidget {
  @override
  Widget build(BuildContext context, ScopedReader watch) {
    final categoriesAsync = watch(categoriesProvider);
    final popularProductsAsync = watch(popularProductsProvider);
    final theme = Theme.of(context);
    final style = theme.textTheme;
    return Scaffold(
      appBar: AppBar(
        title: Text("My Grocery"),
        actions: [
          IconButton(
            onPressed: ()=>showSearch(context: context, delegate: ProductSearch(),),
            icon: Icon(Icons.search),
          ),
          CartIcon()
        ],
      ),
      body: ListView(
        children: [
          SizedBox(height: 16),
          CarouselSlider(
            options: CarouselOptions(
              aspectRatio: 5 / 2,
              viewportFraction: 0.9,
            ),
            items: [1, 2, 3, 4, 5].map((i) {
              return Builder(
                builder: (BuildContext context) {
                  return Container(
                    width: MediaQuery.of(context).size.width,
                    margin: EdgeInsets.symmetric(horizontal: 4),
                    decoration: BoxDecoration(color: Colors.amber),
                    child: SizedBox(),
                  );
                },
              );
            }).toList(),
          ),
          SizedBox(height: 16),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Text(
              "Categories",
              style: style.headline6,
            ),
          ),
          categoriesAsync.when(
            data: (categories) => GridView.count(
              padding: EdgeInsets.all(12),
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              crossAxisCount: 3,
              children: categories
                  .map(
                    (e) => CategoryCard(category: e),
                  )
                  .toList(),
            ),
            loading: () => Center(child: CircularProgressIndicator()),
            error: (e, s) => Text(
              e.toString(),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Text(
              "Popular",
              style: style.headline6,
            ),
          ),
          popularProductsAsync.when(
            data: (products) => GridView.count(
              padding: EdgeInsets.all(12),
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              crossAxisCount: 2,
              childAspectRatio: 2/3,
              children: products
                  .map(
                    (e) => ProductCard(product: e),
                  )
                  .toList(),
            ),
            loading: () => Center(),
            error: (e, s) => Text(e.toString())
          ),
        ],
      ),
    );
  }
}

