import 'package:flutter/material.dart';
import 'package:grocery_app/core/models/product.dart';
import 'package:grocery_app/core/providers/profile_provider.dart';
import 'package:grocery_app/core/providers/repository_provider.dart';
import 'package:grocery_app/ui/widgets/selection_tile.dart';
import 'package:grocery_app/utils/labels.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'widgets/product_image_viewer.dart';

class ProductPage extends ConsumerWidget {
  final Product product;

  const ProductPage({Key? key, required this.product}) : super(key: key);
  @override
  Widget build(BuildContext context, ScopedReader watch) {
    final theme = Theme.of(context);
    final style = theme.textTheme;

    final profile = watch(profileProvider).data!.value;
    final repository = context.read(repositoryProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text(product.name),
      ),
      bottomNavigationBar: Material(
        color: theme.cardColor,
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 24, vertical: 4),
          child: profile.isInCart(product.id)
              ? Row(
                  children: [
                    Text(
                      "${Labels.rupee}${product.options[profile.cartOptionIndex(product.id)].salePrice.toInt() * profile.cartQuanity(product.id)}",
                      style: style.headline6,
                    ),
                    Spacer(),
                    IconButton(
                      onPressed: () {
                        profile.updateCartQuantity(product.id, -1);
                        repository.saveCart(profile.cartProducts);
                      },
                      icon: Icon(Icons.remove),
                    ),
                    SizedBox(width: 16),
                    Text(profile.cartQuanity(product.id).toString()),
                    SizedBox(width: 16),
                    IconButton(
                      onPressed: () {
                        profile.updateCartQuantity(product.id, 1);
                        repository.saveCart(profile.cartProducts);
                      },
                      icon: Icon(Icons.add),
                    ),
                  ],
                )
              : MaterialButton(
                  onPressed: () {
                    profile.addToCart(id: product.id);
                    repository.saveCart(profile.cartProducts);
                  },
                  color: theme.accentColor,
                  child: Text("ADD TO CART"),
                ),
        ),
      ),
      body: ListView(
        children: [
          AspectRatio(
            aspectRatio: 1,
            child: Material(
              color: theme.cardColor,
              child: ProductImageViewer(
                images: product.images,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    product.name,
                    style: style.headline5,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    children: product.options.map(
                      (e) {
                        final value = profile.isInCart(product.id) &&
                            profile.cartOptionIndex(product.id) ==
                                product.options.indexOf(e);
                        return Material(
                          color: value ? theme.primaryColorLight : null,
                          child: SelectionTile(
                            value: value,
                            onTap: () {
                              if (!profile.isInCart(product.id)) {
                                profile.addToCart(
                                  id: product.id,
                                  index: product.options.indexOf(e),
                                );
                              } else if(!value){
                                profile.updateIndex(
                                  id: product.id,
                                  index: product.options.indexOf(e),
                                );
                              }

                              repository.saveCart(profile.cartProducts);
                            },
                            title: Text(
                              e.salePriceLabel,
                              style: style.headline6,
                            ),
                            subtitle: Text(
                              e.priceLabel,
                              style: style.caption!.copyWith(
                                decoration: TextDecoration.lineThrough,
                              ),
                            ),
                            traling: Text(
                              e.amountLabel,
                              style: style.headline6,
                            ),
                          ),
                        );
                      },
                    ).toList(),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    product.description,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
