import 'package:flutter/material.dart';
import 'package:grocery_app/core/models/subscription.dart';
import 'package:grocery_app/utils/utils.dart';

class SubscriptionCard extends StatelessWidget {
  final Subscription subscription;

  const SubscriptionCard({Key? key, required this.subscription})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final style = theme.textTheme;
    return Card(
      child: Column(
        children: [
          AspectRatio(
            aspectRatio: 5,
            child: Row(
              children: [
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(4),
                    child: Image.network(subscription.image),
                  ),
                ),
                Expanded(
                  flex: 2,
                  child: Padding(
                    padding: const EdgeInsets.all(4),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Text(
                          subscription.productName,
                          style: style.subtitle1,
                        ),
                        Text(
                          subscription.option.salePriceLabel +
                              " / " +
                              subscription.option.amountLabel,
                          style: style.subtitle2!.copyWith(
                            color: theme.primaryColor,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Expanded(
                  flex: 2,
                  child: Padding(
                    padding: const EdgeInsets.all(4),
                    child: Center(
                      child: RichText(
                        text: TextSpan(
                          text: "Daily Quantity: ",
                          style: style.bodyText1!.copyWith(
                            color: style.caption!.color,
                          ),
                          children: [
                            TextSpan(
                              text: subscription.deliveries.last.quantity
                                  .toString(),
                              style: style.bodyText1,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Text(
                  "Start date: " + Utils.formatedDate(subscription.startDate),
                  style: style.caption,
                ),
                Spacer(),
                Text(
                  "End date: " + Utils.formatedDate(subscription.endDate),
                  style: style.caption,
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
