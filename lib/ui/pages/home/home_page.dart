import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'providers/banners_provider.dart';
import 'providers/categories_provider.dart';
import 'providers/popular_products_provider.dart';
import 'widgets/cart_icon.dart';
import '../products/category_products_page.dart';
import '../search/search_page.dart';
import '../../widgets/product_card.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'widgets/category_card.dart';
import 'widgets/drawer_animation.dart';
import 'widgets/my_drawer.dart';

class HomePage extends ConsumerWidget {
  @override
  Widget build(BuildContext context, ScopedReader watch) {
    final categoriesAsync = watch(categoriesProvider);
    final popularProductsAsync = watch(popularProductsProvider);
    final bannersAsync = watch(bannersProvider);
    final theme = Theme.of(context);
    final style = theme.textTheme;
    return DrawerAnimation(
      drawerBuilder: (context, close) => MyDrawer(close: close),
      homeBuilder: (context, open) => Scaffold(
        appBar: AppBar(
          leading: Builder(
            builder: (context) => IconButton(
              icon: Icon(Icons.menu),
              onPressed: open,
            ),
          ),
          title: Text("Kisan Nest"),
          actions: [
            IconButton(
              onPressed: () => showSearch(
                context: context,
                delegate: ProductSearch(),
              ),
              icon: Icon(Icons.search),
            ),
            CartIcon()
          ],
        ),
        body: ListView(
          children: [
            SizedBox(height: 16),
            bannersAsync.when(
              data: (banners) => CarouselSlider(
                options: CarouselOptions(
                  autoPlay: true,
                  autoPlayCurve: Curves.easeInOut,
                  aspectRatio: 5 / 2,
                  viewportFraction: 0.9,
                ),
                items: banners.map((i) {
                  return SizedBox(
                    width: MediaQuery.of(context).size.width,
                    child: GestureDetector(
                      onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              CategoryProductsPage(category: i.category),
                        ),
                      ),
                      child: Card(
                        child: Image.network(
                          i.image,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),
              loading: () => Center(
                child: CircularProgressIndicator(),
              ),
              error: (e, s) => Text(
                e.toString(),
              ),
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
                childAspectRatio: 2 / 3,
                children: products
                    .map(
                      (e) => ProductCard(product: e),
                    )
                    .toList(),
              ),
              loading: () => Center(),
              error: (e, s) => Text(
                e.toString(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
