import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import '../../../../core/models/order.dart';
import '../../../widgets/tow_text_row.dart';
import '../../../../utils/utils.dart';

import '../order_details_page.dart';

class OrderCard extends StatelessWidget {
  final Order order;
  const OrderCard({Key? key, required this.order}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      child: InkWell(
        onTap: () => Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => OrderDetailsPage(
              key: Key(order.id),
              order: order,
            ),
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            children: [
              TwoTextRow(
                text1: "Order Id",
                text2: order.orderId,
              ),
              Divider(
                height: 0.5,
              ),
              TwoTextRow(
                text1: "Delivery Date",
                text2: Utils.formatedDate(order.deliveryDate),
              ),
              TwoTextRow(
                text1: "Order Status",
                text2: order.status,
              ),
              TwoTextRow(
                text1: "Items",
                text2: "${order.items} Items purchased",
              ),
              TwoTextRow(
                text1: "Price",
                text2: "₹" + order.price.toString(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
