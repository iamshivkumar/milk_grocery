import 'package:flutter/material.dart';
import 'package:grocery_app/core/providers/repository_provider.dart';
import 'package:grocery_app/enums/subscription_status.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/models/subscription.dart';
import '../../../../utils/utils.dart';

class SubscriptionCard extends StatelessWidget {

  final Subscription subscription;
  const SubscriptionCard({Key? key, required this.subscription})
      : super(key: key);

  Color color() {
    switch (subscription.status) {
      case SubscriptionStatus.active:
        return Colors.green;
      case SubscriptionStatus.inactive:
        return Colors.amber;
      case SubscriptionStatus.closed:
        return Colors.red;
      default:
        return Colors.black;
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final style = theme.textTheme;
    final repository = context.read(repositoryProvider);
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
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 8, bottom: 16),
                  child: Text(
                    subscription.status,
                    style: TextStyle(
                      color: color(),
                    ),
                  ),
                ),
                Spacer(),
                subscription.status != SubscriptionStatus.closed
                    ? TextButton(
                        onPressed: () {
                          showDialog(
                            context: context,
                            builder: (context) => AlertDialog(
                              title: Text(
                                'Are you sure you want to ${subscription.status == SubscriptionStatus.active ? "pause" : "resume"} this subscription?',
                              ),
                              actions: [
                                TextButton(
                                  onPressed: () {
                                    Navigator.pop(context);
                                  },
                                  child: Text("NO"),
                                ),
                                MaterialButton(
                                  color: theme.accentColor,
                                  child: Text("YES"),
                                  onPressed: () {
                                    repository.updateSubScriptionStatus(
                                      status: subscription.status ==
                                              SubscriptionStatus.active
                                          ? SubscriptionStatus.inactive
                                          : SubscriptionStatus.active,
                                      id: subscription.id,
                                    );
                                    Navigator.pop(context);
                                  },
                                ),
                              ],
                            ),
                          );
                        },
                        child: Text(
                            subscription.status == SubscriptionStatus.active
                                ? "PAUSE"
                                : "RESUME"),
                      )
                    : SizedBox(),
                subscription.status != SubscriptionStatus.closed
                    ? TextButton(
                        style: ButtonStyle(
                          foregroundColor:
                              MaterialStateProperty.all(theme.errorColor),
                          overlayColor: MaterialStateProperty.all(
                              theme.errorColor.withOpacity(0.2)),
                        ),
                        onPressed: () {
                          showDialog(
                            context: context,
                            builder: (context) => AlertDialog(
                              title: Text(
                                'Are you sure you want to close this subscription?',
                              ),
                              actions: [
                                TextButton(
                                  onPressed: () {
                                    Navigator.pop(context);
                                  },
                                  child: Text("NO"),
                                ),
                                MaterialButton(
                                  color: theme.accentColor,
                                  child: Text("YES"),
                                  onPressed: () {
                                    repository.updateSubScriptionStatus(
                                      status: SubscriptionStatus.closed,
                                      id: subscription.id,
                                    );
                                    Navigator.pop(context);
                                  },
                                ),
                              ],
                            ),
                          );
                        },
                        child: Text("CLOSE"),
                      )
                    : SizedBox(),
              ],
            ),
          )
        ],
      ),
    );
  }
}
