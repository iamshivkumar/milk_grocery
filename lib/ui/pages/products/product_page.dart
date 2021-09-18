import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../core/models/product.dart';
import '../../../core/providers/profile_provider.dart';
import '../../../core/providers/repository_provider.dart';
import '../../../utils/labels.dart';
import '../../widgets/selection_tile.dart';
import '../subscribe/subscribe_page.dart';
import 'widgets/product_image_viewer.dart';

final indexProvider  = StateProvider.autoDispose<int>((ref)=>0);

class ProductPage extends ConsumerWidget {
  final Product product;

  const ProductPage({Key? key, required this.product}) : super(key: key);
  @override
  Widget build(BuildContext context, ScopedReader watch) {
    final theme = Theme.of(context);
    final style = theme.textTheme;
        final index = watch(indexProvider);

    final profile = watch(profileProvider).data!.value;
    final repository = context.read(repositoryProvider);
    final option = profile.isInCart(product.id,index.state)
        ? product.options[profile.cartOptionIndex(product.id)]
        : product.options.where((element) => element.quantity > 0).isNotEmpty?product.options.where((element) => element.quantity > 0).first:product.options.first;
    return Scaffold(
      appBar: AppBar(
        title: Text(product.name),
      ),
      bottomNavigationBar: Material(
        color: theme.cardColor,
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 24, vertical: 4),
          child: product.options[index.state].quantity>0
              ? (profile.isInCart(product.id,index.state)
                  ? Row(
                      children: [
                        Text(
                          "${Labels.rupee}${product.options[index.state].salePrice.toInt() * profile.cartQuanityM(product.id,index.state)}",
                          style: style.headline6,
                        ),
                        Spacer(),
                        IconButton(
                          onPressed: () {
                            profile.updateCartQuantityM(product.id, -1,index.state);
                            repository.saveCart(profile.cartProducts);
                          },
                          icon: Icon(Icons.remove),
                        ),
                        SizedBox(width: 16),
                        Text(profile.cartQuanityM(product.id,index.state).toString()),
                        SizedBox(width: 16),
                        IconButton(
                          onPressed:
                              profile.cartQuanityM(product.id,index.state) < option.quantity
                                  ? () {
                                      profile.updateCartQuantityM(product.id, 1,index.state);
                                      repository.saveCart(profile.cartProducts);
                                    }
                                  : null,
                          icon: Icon(Icons.add),
                        ),
                      ],
                    )
                  : Row(
                      children: [
                        product.isMilky
                            ? Expanded(
                                child: Padding(
                                  padding: const EdgeInsets.only(right: 8),
                                  child: MaterialButton(
                                    onPressed: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) =>
                                              SubscribePage(product: product),
                                        ),
                                      );
                                    },
                                    color: theme.primaryColor,
                                    child: Text("SUBSCRIBE"),
                                  ),
                                ),
                              )
                            : SizedBox(),
                        Expanded(
                          child: MaterialButton(
                            onPressed: () {
                              profile.addToCart(
                                  id: product.id,
                                  index: index.state);
                              repository.saveCart(profile.cartProducts);
                            },
                            color: theme.accentColor,
                            child: Text("ADD TO CART"),
                          ),
                        ),
                      ],
                    ))
              : SizedBox(
                  height: 48,
                  child: Center(
                    child: Text(
                      "Out Of Stock",
                      style: TextStyle(
                        color: theme.errorColor,
                      ),
                    ),
                  ),
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
                        final value = product.options.indexOf(e) == index.state;
                        return Material(
                          color: value ? theme.primaryColorLight : null,
                          child: SelectionTile(
                            value: value,
                            active: e.quantity > 0,
                            onTap: () {
                              index.state = product.options.indexOf(e);
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
