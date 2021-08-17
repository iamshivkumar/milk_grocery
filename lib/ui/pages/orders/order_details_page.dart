import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:grocery_app/core/providers/repository_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/models/order.dart';
import '../../../enums/order_status.dart';
import '../../../utils/utils.dart';
import '../../widgets/tow_text_row.dart';

class OrderDetailsPage extends StatelessWidget {
  final Order order;
  const OrderDetailsPage({Key? key, required this.order}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final style = theme.textTheme;
    return Scaffold(
      appBar: AppBar(
        title: Text('Order Details'),
      ),
      body: ListView(
        padding: EdgeInsets.all(4),
        children: [
          WhiteCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    'Products',
                    style: style.headline6,
                  ),
                ),
                Column(
                  children: order.products.map((e) {
                    return ListTile(
                      title: Text(e.name),
                      leading: Image.network(e.image),
                      subtitle: Text(
                          e.qt.toString() + " Items x ₹" + e.price.toString()),
                      trailing: Text(
                        "₹" + (e.qt * e.price).toString(),
                      ),
                    );
                  }).toList(),
                )
              ],
            ),
          ),
          WhiteCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    'Order Summary',
                    style: style.headline6,
                  ),
                ),
                TwoTextRow(
                  text1: "Items (${order.items})",
                  text2: '₹' + order.price.toString(),
                ),
                TwoTextRow(
                  text1: "Wallet Amount",
                  text2: '₹' + order.walletAmount.toString(),
                ),
                TwoTextRow(
                  text1: 'Total Price',
                  text2: '₹' + order.total.toString(),
                )
              ],
            ),
          ),
          WhiteCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    'Delivery Details',
                    style: style.headline6,
                  ),
                ),
                TwoTextRow(text1: "Status", text2: order.status),
                TwoTextRow(
                  text1: "Delivery Date",
                  text2: Utils.formatedDate(order.deliveryDate),
                ),
              ],
            ),
          ),
          WhiteCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    'Payment',
                    style: style.headline6,
                  ),
                ),
                TwoTextRow(
                    text1: "Status", text2: order.paid ? "Paid" : "Not paid"),
                TwoTextRow(text1: "Payment Method", text2: order.paymentMethod),
              ],
            ),
          ),
          order.status != OrderStatus.delivered &&
                  order.status != OrderStatus.cancelled &&
                  order.status != OrderStatus.returned
              ? Padding(
                  padding: const EdgeInsets.all(4.0),
                  child: MaterialButton(
                    onPressed: () {
                      showDialog(
                        context: context,
                        builder: (context) => AlertDialog(
                          title:
                              Text('Are you sure you want cancel this order?'),
                          actions: [
                            TextButton(
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              child: Text('No'),
                            ),
                            MaterialButton(
                              onPressed: () async {
                                Navigator.pop(context);
                                context.read(repositoryProvider).cancelOrder(
                                      orderId: order.id,
                                      price: order.price,
                                      products: order.products,
                                    );
                                Navigator.pop(context);
                              },
                              color: theme.accentColor,
                              child: Text('Yes'),
                            ),
                          ],
                        ),
                      );
                    },
                    color: Theme.of(context).accentColor,
                    child: Text('CANCEL ORDER'),
                  ),
                )
              : SizedBox(),
        ],
      ),
    );
  }
}

class WhiteCard extends StatelessWidget {
  final Widget child;
  WhiteCard({required this.child});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: child,
      ),
    );
  }
}
