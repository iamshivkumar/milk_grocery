
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/models/order_product.dart';
import '../../widgets/tow_text_row.dart';
import '../orders/orders_page.dart';
import 'checkout_view_model/checkout_view_model_provider.dart';

class CheckoutPage extends ConsumerWidget {
  final List<OrderProduct> orderProducts;
  final double total;
  final int items;

  const CheckoutPage({
    Key? key,
    required this.orderProducts,
    required this.total,
    required this.items,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, ScopedReader watch) {
    final theme = Theme.of(context);
    final model = watch(checkoutViewModelProvider);
    return Scaffold(
      appBar: AppBar(
        title: Text('Place Order'),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
        child: MaterialButton(
          color: theme.accentColor,
          onPressed: () {
            model.payOrder(
              products: orderProducts,
              price: total,
              items: items,
              onOrder: () {
                Navigator.pop(context);
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => OrdersPage(),
                  ),
                );
              },
            );
          },
          child: Text((total - model.walletAmount).toInt()>0? "PAY":"CONFIRM"),
        ),
      ),
      body: SingleChildScrollView(
        child: Card(
          margin: EdgeInsets.all(16),
          child: Column(
            children: [
              Column(
                children: orderProducts.map(
                  (e) {
                    return ListTile(
                      leading: SizedBox(
                        height: 56,
                        width: 56,
                        child: Image.network(
                          e.image,
                        ),
                      ),
                      title: Text(e.name),
                      subtitle: Text(
                          e.qt.toString() + " Items x ₹" + e.price.toString()),
                      trailing: Text(
                        "₹" + (e.qt * e.price).toString(),
                      ),
                    );
                  },
                ).toList(),
              ),
              model.profile.walletAmount != 0
                  ? Material(
                      color: theme.primaryColorDark,
                      child: ListTile(
                        dense: true,
                        minLeadingWidth: 0,
                        leading: Icon(Icons.account_balance_wallet_outlined),
                        title: Text(
                          'Wallet Amount: ₹' +
                              (model.profile.walletAmount - model.walletAmount)
                                  .toString(),
                        ),
                        trailing: model.walletAmount == 0
                            ? IconButton(
                                icon: Icon(Icons.arrow_forward_ios),
                                onPressed: () => model.useWallet(total),
                              )
                            : IconButton(
                                icon: Icon(Icons.close),
                                onPressed: model.cancelUsingWallet,
                              ),
                      ),
                    )
                  : SizedBox(),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: [
                    TwoTextRow(
                      text1: 'Total ($items Items)',
                      text2: '₹' + total.toString(),
                    ),
                    TwoTextRow(
                      text1: 'Wallet Amount',
                      text2: '₹' + model.walletAmount.toInt().toString(),
                    ),
                   (total - model.walletAmount).toInt()>0? TwoTextRow(
                      text1: 'Razorpay',
                      text2:
                          '₹' + (total - model.walletAmount).toInt().toString(),
                    ):SizedBox(),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
