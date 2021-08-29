import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:grocery_app/ui/pages/products/product_page.dart';

import '../../../../core/models/product.dart';
import '../../../../core/providers/profile_provider.dart';
import '../../../../core/providers/repository_provider.dart';

class CartProductCard extends StatelessWidget {
  final int qt;
  final Product product;

  CartProductCard({
    required this.qt,
    required this.product,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final style = theme.textTheme;
    final profile = context.read(profileProvider).data!.value;
    final reposiory = context.read(repositoryProvider);
    return Padding(
      padding: const EdgeInsets.all(2.0),
      child: Dismissible(
        direction: DismissDirection.startToEnd,
        background: Container(
          color: Theme.of(context).primaryColorDark,
          child: Stack(
            children: [
              Positioned(
                top: 0,
                bottom: 0,
                left: 24,
                child: Icon(
                  Icons.delete_outline,
                  size: 40,
                  color: Colors.white,
                ),
              ),
            ],
          ),
        ),
        key: Key(product.id),
        onDismissed: (direction) {
          profile.removeFromCart(product.id);
          reposiory.saveCart(profile.cartProducts);
        },
        child: AspectRatio(
          aspectRatio: 3,
          child: GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ProductPage(product: product),
                ),
              );
            },
            child: Material(
              color: Colors.white,
              child: Row(
                children: [
                  Expanded(
                    flex: 6,
                    child: Padding(
                      padding: const EdgeInsets.all(4.0),
                      child: Image.network(product.images.first),
                    ),
                  ),
                  Expanded(
                    flex: 13,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(
                              top: 8, left: 8, right: 8, bottom: 4),
                          child: Text(
                            product.name,
                            style: TextStyle(
                              fontSize: 16,
                            ),
                          ),
                        ),
                        Row(
                          children: [
                            Expanded(
                              flex: 6,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(
                                        top: 4, left: 8, right: 8, bottom: 8),
                                    child: Text(
                                      product
                                          .options[profile
                                              .cartOptionIndex(product.id)]
                                          .amountLabel,
                                      style: TextStyle(
                                          fontSize: 12, color: Colors.grey),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Text(
                                      product
                                          .options[profile
                                              .cartOptionIndex(product.id)]
                                          .salePriceLabel,
                                      style: TextStyle(
                                          fontSize: 16,
                                          color:
                                              Theme.of(context).primaryColor),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Expanded(
                              flex: 7,
                              child: product
                                          .options[profile
                                              .cartOptionIndex(product.id)].quantity > 0
                                  ? Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceEvenly,
                                      children: [
                                        IconButton(
                                          splashRadius: 24,
                                          color: Theme.of(context).accentColor,
                                          splashColor: Theme.of(context)
                                              .accentColor
                                              .withOpacity(0.2),
                                          highlightColor: Colors.transparent,
                                          icon:
                                              Icon(Icons.remove_circle_outline),
                                          onPressed: () {
                                            profile.updateCartQuantity(
                                                product.id, -1);
                                            reposiory
                                                .saveCart(profile.cartProducts);
                                          },
                                        ),
                                        Text(
                                          qt.toString(),
                                          style: TextStyle(
                                            fontSize: 20,
                                          ),
                                        ),
                                        IconButton(
                                          splashRadius: 24,
                                          color: Theme.of(context).accentColor,
                                          splashColor: Theme.of(context)
                                              .accentColor
                                              .withOpacity(0.2),
                                          highlightColor: Colors.transparent,
                                          icon: Icon(Icons.add_circle_outline),
                                          onPressed: product
                                          .options[profile
                                              .cartOptionIndex(product.id)].quantity > qt
                                              ? () {
                                                  profile.updateCartQuantity(
                                                      product.id, 1);
                                                  reposiory.saveCart(
                                                      profile.cartProducts);
                                                }
                                              : null,
                                        ),
                                      ],
                                    )
                                  : Center(
                                      child: Text(
                                        "Out Of Stock",
                                        style: style.caption!.copyWith(
                                          color: theme.errorColor,
                                        ),
                                      ),
                                    ),
                            )
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
