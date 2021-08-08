
import 'package:flutter/material.dart';
import 'package:grocery_app/core/models/product.dart';
import 'package:grocery_app/ui/pages/products/widgets/product_image_viewer.dart';
import 'package:grocery_app/ui/pages/subscribe/subscribe_page.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class MilkProductPage extends ConsumerWidget {
  final Product product;

  const MilkProductPage({Key? key, required this.product}) : super(key: key);
  @override
  Widget build(BuildContext context, ScopedReader watch) {
    final theme = Theme.of(context);
    final style = theme.textTheme;
    return Scaffold(
      appBar: AppBar(
        title: Text(product.name),
      ),
      bottomNavigationBar: Material(
        color: theme.cardColor,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 4),
          child: MaterialButton(
            color: theme.accentColor,
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => SubscribePage(product: product),
              ),
            ),
            child: Text("SUBSCRIBE"),
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
                        return Material(
                          child: ListTile(
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
                            trailing: Text(
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
