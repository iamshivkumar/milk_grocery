import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../widgets/loading.dart';
import '../../widgets/product_card.dart';
import 'providers/search_keys_provider.dart';
import 'providers/search_view_model_provider.dart';

class ProductSearch extends SearchDelegate {
  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        icon: Icon(Icons.clear),
        onPressed: () {
          showSuggestions(context);
          query = "";
        },
      ),
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: AnimatedIcon(
        icon: AnimatedIcons.menu_arrow,
        progress: transitionAnimation,
      ),
      onPressed: () => close(context, null),
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    return Consumer(
      builder: (context, watch, child) {
        final productsModel =
            watch(searchViewModelProvider(query.toLowerCase()));
        return Builder(
          builder: (context) {
            if (productsModel.products.isEmpty) {
              productsModel.getProducts();
              if (productsModel.circleLoading) {
                return Center(child: CircularProgressIndicator());
              } else if (productsModel.products.isEmpty)
                return Center(
                  child: Text("No Products Available"),
                );
            }

            return NotificationListener<ScrollNotification>(
              onNotification: (notification) {
                if (!productsModel.busy &&
                    notification.metrics.pixels ==
                        notification.metrics.maxScrollExtent) {
                  productsModel.getProductsMore();
                }
                return true;
              },
              child: RefreshIndicator(
                onRefresh: () async {
                  context.refresh(
                    searchViewModelProvider(query.toLowerCase()),
                  );
                },
                child: CustomScrollView(
                  slivers: [
                    SliverPadding(
                      padding: EdgeInsets.all(8),
                      sliver: SliverGrid(
                        gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                          maxCrossAxisExtent: 200,
                          crossAxisSpacing: 8,
                          mainAxisSpacing: 8,
                          childAspectRatio: 0.7,
                        ),
                        delegate: SliverChildListDelegate(
                          productsModel.products
                              .map(
                                (e) => ProductCard(product: e),
                              )
                              .toList(),
                        ),
                      ),
                    ),
                    SliverToBoxAdapter(
                      child: Center(
                        child: productsModel.loading &&
                                productsModel.products.length > 5
                            ? Loading()
                            : SizedBox(),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return Consumer(
      builder: (context, watch, child) {
        var keysAsync = watch(searchKeysProvder);
        return keysAsync.when(
          data: (keys) {
            final suggestionList = query.isEmpty
                ? []
                : keys
                    .where((element) =>
                        element.toLowerCase().contains(query.toLowerCase()))
                    .toList();
            return ListView.builder(
              itemBuilder: (context, index) => ListTile(
                leading: Icon(Icons.search),
                trailing: Icon(Icons.north_west),
                onTap: () {
                  query = suggestionList[index];
                  showResults(context);
                },
                title: RichText(
                  text: TextSpan(
                    text: suggestionList[index].substring(0, query.length),
                    style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                    ),
                    children: [
                      TextSpan(
                        text: suggestionList[index].substring(query.length),
                        style: TextStyle(
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              itemCount: suggestionList.length,
            );
          },
          loading: () => CircularProgressIndicator(),
          error: (error, stackTrace) => Text(error.toString()),
        );
      },
    );
  }
}
