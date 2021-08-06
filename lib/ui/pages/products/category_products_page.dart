import 'package:flutter/material.dart';
import 'package:grocery_app/core/models/category.dart';
import 'package:grocery_app/ui/pages/products/providers/products_view_model_provider.dart';
import 'package:grocery_app/ui/widgets/loading.dart';
import 'package:grocery_app/ui/widgets/product_card.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class CategoryProductsPage extends ConsumerWidget {
  final ProductCategory category;
  const CategoryProductsPage({Key? key, required this.category})
      : super(key: key);
  @override
  Widget build(BuildContext context, ScopedReader watch) {
    final model = watch(productsViewModelProvider(category.name));
    return Scaffold(
      appBar: AppBar(
        title: Text(category.name),
      ),
      body: model.products.isEmpty
          ? Loading()
          : NotificationListener<ScrollNotification>(
              onNotification: (notification) {
                if (!model.busy &&
                    notification.metrics.pixels ==
                        notification.metrics.maxScrollExtent) {
                  model.getProductsMore();
                }
                return true;
              },
              child: RefreshIndicator(
                onRefresh: () async =>
                    context.refresh(productsViewModelProvider(category.name)),
                child: CustomScrollView(
                  slivers: [
                    SliverPadding(
                      padding: EdgeInsets.all(12),
                      sliver: SliverGrid(
                        gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                          maxCrossAxisExtent: 200,
                          childAspectRatio: 0.7,
                        ),
                        delegate: SliverChildListDelegate(
                          model.products
                              .map(
                                (e) => ProductCard(product: e),
                              )
                              .toList(),
                        ),
                      ),
                    ),
                    SliverToBoxAdapter(
                      child: Center(
                        child: model.loading && model.products.length > 5
                            ? Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: CircularProgressIndicator(),
                              )
                            : SizedBox(),
                      ),
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}
