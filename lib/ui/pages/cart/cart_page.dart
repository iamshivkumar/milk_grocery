import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../core/models/order_product.dart';
import '../../../core/models/product.dart';
import '../../../core/providers/profile_provider.dart';
import '../checkout/checkout_page.dart';
import 'providers/product_provider.dart';
import 'widgets/cart_product_card.dart';

class CartPage extends ConsumerWidget {
  @override
  Widget build(BuildContext context, ScopedReader watch) {
    final profile = watch(profileProvider).data!.value;

    List<Product> products = [];


    profile.cartProducts.forEach(
      (element) {
        var productFuture = watch(productFutureProvider(element.id));
        productFuture.whenData((value) {
          if (value.options[element.optionIndex].quantity < element.qt) {
            element.qt = value.options[element.optionIndex].quantity;
          }
          products.add(value);
        });
      },
    );
    if(products.length!=profile.cartProducts.length){
      return Scaffold(
        appBar: AppBar(
        title: Text("My Cart"),
      ),
      );
    }

    final int items = profile.cartProducts.isNotEmpty
        ? profile.cartProducts.map((e) =>e.qt>0?e.qt:0).reduce((value, element) => value + element)
        : 0;
    final double total = profile.cartProducts.isNotEmpty
        ? profile.cartProducts
            .map(
              (e) =>
                  products.where((element) => element.id==e.id).first.options[e.optionIndex].salePrice *
                  e.qt,
            )
            .reduce((value, element) => value + element)
        : 0;
    // final double total = products.isNotEmpty
    //     ? products
    //         .map(
    //           (e) =>
    //               e.options[profile.cartOptionIndex(e.id)].salePrice *
    //               (profile.cartQuanity(e.id)>0?profile.cartQuanity(e.id):0),
    //         )
    //         .reduce((value, element) => value + element)
    //     : 0;
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
            onPressed: items>0
                ? () async {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => CheckoutPage(
                          total: total,
                          items: items,
                          orderProducts: profile.cartProducts
                              .map(
                                (e) => OrderProduct.fromProduct(
                                  product: products.where((element) => element.id==e.id).first,
                                  cartProduct: e,
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
      body:  ListView(
        children: profile.cartProducts
            .map(
              (e) => CartProductCard(
                product: products.where((s) => s.id==e.id).first,
                qt: e.qt,
                index: e.optionIndex,
              ),
            )
            .toList(),
      ),
    );
  }
}
