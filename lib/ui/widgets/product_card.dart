import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../core/models/product.dart';
import '../../core/providers/profile_provider.dart';
import '../../core/providers/repository_provider.dart';
import '../pages/products/product_page.dart';

class ProductCard extends ConsumerWidget {
  final Product product;
  ProductCard({required this.product});
  @override
  Widget build(BuildContext context, ScopedReader watch) {
    final theme = Theme.of(context);
    final style = theme.textTheme;
    final profile = watch(profileProvider).data!.value;
    final repository = context.read(repositoryProvider);
    final option = profile.isInCart(product.id)
        ? product.options[profile.cartOptionIndex(product.id)]
        : product.options.where((element) => element.quantity>0).first;
    return GestureDetector(
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ProductPage(product: product),
        ),
      ),
      child: Card(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              child: Image.network(
                product.images.first,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(4.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(4.0),
                    child: Text(
                      product.name,
                      overflow: TextOverflow.ellipsis,
                      textAlign: TextAlign.center,
                      style: style.subtitle1,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(4),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.baseline,
                      textBaseline: TextBaseline.alphabetic,
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Text(
                          option.salePriceLabel,
                          style: style.headline6,
                        ),
                        Text(
                          option.priceLabel,
                          style: style.caption!.copyWith(
                            decoration: TextDecoration.lineThrough,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(4.0),
                    child: Text(
                      option.amountLabel,
                    ),
                  ),
                ],
              ),
            ),
            Divider(height: 0.5),
            SizedBox(
              height: 40,
              child: option.quantity > 0
                  ? (profile.isInCart(product.id)
                      ? Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            TextButton(
                              onPressed: () {
                                profile.updateCartQuantity(product.id, -1);
                                repository.saveCart(profile.cartProducts);
                              },
                              child: Icon(Icons.remove_circle_outline),
                            ),
                            Text(
                              profile.cartQuanity(product.id).toString(),
                            ),
                            TextButton(
                              onPressed: option.quantity>profile.cartQuanity(product.id)? () {
                                profile.updateCartQuantity(product.id, 1);
                                repository.saveCart(profile.cartProducts);
                              }:null,
                              child: Icon(Icons.add_circle_outline),
                            ),
                          ],
                        )
                      : TextButton(
                          onPressed: () async {
                            profile.addToCart(id: product.id,index: product.options.indexOf(option));
                            repository.saveCart(profile.cartProducts);
                          },
                          child: Icon(
                            Icons.add_shopping_cart,
                          ),
                        ))
                  : Center(
                      child: Text(
                        "Out Of Stock",
                        style: style.caption!.copyWith(
                          color: theme.errorColor,
                        ),
                      ),
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
