import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/models/subscription.dart';
import '../../../../core/providers/repository_provider.dart';
import '../../../../enums/order_status.dart';
import '../../../../utils/labels.dart';
import '../providers/schedule_view_model_provider.dart';

class DeliveryScheduleCard extends StatelessWidget {
  final Subscription subscription;
  final DateTime dateTime;

  const DeliveryScheduleCard(
      {Key? key, required this.subscription, required this.dateTime})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final style = theme.textTheme;
    final delivery = subscription.deliveries
        .where((element) => element.date == dateTime)
        .first;
    final model = context.read(scheduleViewModelProvider);
    final repo = context.read(repositoryProvider);
    
    Color color(){
      switch (delivery.status) {
        case OrderStatus.cancelled:
          return Colors.red;
        case OrderStatus.delivered:
          return Colors.green;

        default:
           return theme.primaryColor;
      }
    }

    return AspectRatio(
      aspectRatio: 3,
      child: Card(
        child: Row(
          children: [
            Expanded(
              flex: 6,
              child: Padding(
                padding: const EdgeInsets.all(4.0),
                child: Image.network(subscription.image),
              ),
            ),
            Expanded(
              flex: 6,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(
                        top: 8, left: 8, right: 8, bottom: 4),
                    child: Text(
                      subscription.productName,
                      style: style.subtitle1,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(
                        top: 4, left: 8, right: 8, bottom: 8),
                    child: Text(
                      subscription.option.amountLabel,
                      style: style.caption,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      subscription.option.priceLabel,
                      style: style.subtitle1!.copyWith(
                        color: theme.primaryColor,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              flex: 7,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Text(
                    delivery.status,
                    style: style.overline!.copyWith(
                      color: color(),
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      model.editable
                          ? IconButton(
                              splashRadius: 24,
                              color: theme.accentColor,
                              splashColor: theme.accentColor.withOpacity(0.2),
                              highlightColor: Colors.transparent,
                              icon: Icon(Icons.remove_circle_outline),
                              onPressed: delivery.quantity > 0
                                  ? () {
                                      if (delivery.quantity == 1) {
                                        delivery.status = OrderStatus.cancelled;
                                      }
                                      delivery.quantity--;
                                      repo.saveDeliveries(
                                          id: subscription.id,
                                          deliveries: subscription.deliveries);
                                    }
                                  : null,
                            )
                          : SizedBox(),
                      Text(
                        delivery.quantity.toString(),
                        style: style.headline6,
                      ),
                      model.editable
                          ? IconButton(
                              splashRadius: 24,
                              color: theme.accentColor,
                              splashColor: theme.accentColor.withOpacity(0.2),
                              highlightColor: Colors.transparent,
                              icon: Icon(Icons.add_circle_outline),
                              onPressed: () {
                                if (delivery.quantity == 0) {
                                  delivery.status = OrderStatus.pending;
                                }
                                delivery.quantity++;
                                repo.saveDeliveries(
                                  id: subscription.id,
                                  deliveries: subscription.deliveries,
                                );
                              },
                            )
                          : SizedBox(),
                    ],
                  ),
                  RichText(
                    text: TextSpan(
                      text: "Total: ",
                      style: style.caption,
                      children: [
                        TextSpan(
                          text: Labels.rupee +
                              (delivery.quantity *
                                      subscription.option.salePrice)
                                  .toInt()
                                  .toString(),
                          style: style.subtitle1,
                        )
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
