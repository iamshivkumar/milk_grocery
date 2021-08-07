import 'package:flutter/material.dart';
import 'package:grocery_app/core/models/order_product.dart';
import 'package:grocery_app/core/models/product.dart';
import 'package:grocery_app/core/providers/profile_provider.dart';
import 'package:grocery_app/ui/pages/cart/providers/product_provider.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../checkout/checkout_page.dart';
import 'widgets/cart_product_card.dart';

class CartPage extends ConsumerWidget {
  @override
  Widget build(BuildContext context, ScopedReader watch) {
    final profile = watch(profileProvider).data!.value;

    List<Product> products = [];

    final int items = profile.cartProducts.isNotEmpty
        ? profile.cartProducts
            .map((e) => e.qt)
            .reduce((value, element) => value + element)
        : 0;

    profile.cartProducts.forEach(
      (element) {
        var productFuture = watch(productFutureProvider(element.id));
        productFuture.whenData((value) => products.add(value));
      },
    );
    final double total = products.isNotEmpty
        ? products
            .map(
              (e) =>
                  e.options[profile.cartOptionIndex(e.id)].salePrice *
                  profile.cartQuanity(e.id),
            )
            .reduce((value, element) => value + element)
        : 0;
    return Scaffold(
      appBar: AppBar(
        title: Text("My Cart"),
      ),
      bottomNavigationBar: Material(
        color: Colors.white,
        elevation: 8,
        child: ListTile(
          title: Row(
            children: [
              Text(items.toString() + ' ' + 'Items'),
              Text(
                ' | ',
                style: TextStyle(fontSize: 32, fontWeight: FontWeight.w300),
              ),
              Text('₹' + total.toString()),
            ],
          ),
          trailing: MaterialButton(
            onPressed: products.isNotEmpty
                ? () async {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => CheckoutPage(
                          total: total,
                          items: items,
                          orderProducts: products
                              .map(
                                (e) => OrderProduct.fromProduct(
                                  product: e,
                                  cartProduct: profile.cartProduct(e.id),
                                ),
                              )
                              .toList(),
                        ),
                      ),
                    );
                  }
                : null,
            color: Theme.of(context).accentColor,
            child: Text('CHECKOUT NOW'),
          ),
        ),
      ),
      body: ListView(
        children: products
            .map(
              (e) => CartProductCard(
                product: e,
                qt: profile.cartQuanity(e.id),
              ),
            )
            .toList(),
      ),
    );
  }
}
