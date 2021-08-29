import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../core/models/product.dart';
import '../../../core/models/subscription.dart';
import '../../../utils/labels.dart';
import '../../../utils/utils.dart';
import '../../widgets/loading.dart';
import '../../widgets/selection_tile.dart';
import '../subscriptions/delivery_schedule_page.dart';
import 'providers/subscribe_view_model_provider.dart';
import 'widgets/schedule_preview.dart';

class SubscribePage extends HookWidget {
  final Product product;

  const SubscribePage({Key? key, required this.product}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final style = theme.textTheme;
    final model = useProvider(subscribeViewModelProvider);
    final _controller = useTextEditingController();
    return Scaffold(
      backgroundColor: theme.cardColor,
      appBar: AppBar(
        title: Text("Subscribe"),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
        child: model.loading
            ? Loading()
            : MaterialButton(
                color: theme.accentColor,
                onPressed: model.ready
                    ? () {
                        model.subscribe(
                            product: product,
                            onSubscribe: () {
                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => DeliverySchedulesPage(),
                                ),
                              );
                            });
                      }
                    : null,
                child: Text("CONFIRM"),
              ),
      ),
      body: ListView(
        padding: EdgeInsets.all(16),
        children: [
          ListTile(
            contentPadding: EdgeInsets.symmetric(horizontal: 8),
            leading: Image.network(product.images.first),
            title: Text(
              product.name,
              style: style.headline5,
            ),
            subtitle: Text(product.category!),
          ),
          Padding(
            padding: const EdgeInsets.all(8),
            child: Text("Product Options"),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: product.options
                  .map(
                    (e) => Material(
                      color: model.option == e ? theme.primaryColorLight : null,
                      child: SelectionTile(
                        value: model.option == e,
                        onTap: () => model.option = e,
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
                    ),
                  )
                  .toList(),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 8, top: 16),
            child: Text("Quantity"),
          ),
          Padding(
            padding: const EdgeInsets.all(8),
            child: Row(
              children: [
                IconButton(
                  onPressed: () {
                    if (model.quantity == 1) {
                      return;
                    }
                    model.quantity--;
                  },
                  icon: Icon(Icons.remove),
                ),
                SizedBox(width: 16),
                Text(model.quantity.toString()),
                SizedBox(width: 16),
                IconButton(
                  onPressed: () {
                    model.quantity++;
                  },
                  icon: Icon(Icons.add),
                ),
                Spacer(),
                model.option != null
                    ? Row(
                        crossAxisAlignment: CrossAxisAlignment.baseline,
                        textBaseline: TextBaseline.alphabetic,
                        children: [
                          Text(
                            Labels.rupee +
                                (model.quantity * model.option!.salePrice)
                                    .toInt()
                                    .toString() +
                                " /",
                            style: style.headline6,
                          ),
                          Text(
                            "per day",
                            style: style.caption,
                          )
                        ],
                      )
                    : SizedBox(),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8),
            child: Text("Subscription Start Date"),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextFormField(
              controller: _controller,
              readOnly: true,
              onTap: () async {
                final date = await showDatePicker(
                  context: context,
                  initialDate: DateTime.now().add(
                    Duration(days: 1),
                  ),
                  firstDate: DateTime.now().add(
                    Duration(days: 1),
                  ),
                  lastDate: DateTime.now().add(
                    Duration(days: 8),
                  ),
                );
                if (date == null) {
                  return;
                }
                model.startDate = DateTime(date.year, date.month, date.day);
                _controller.text = Utils.formatedDate(model.startDate!);
              },
            ),
          ),
          SizedBox(height: 8),
          Padding(
            padding: const EdgeInsets.all(8),
            child: Text("Delviery Day Options"),
          ),
          Padding(
            padding: const EdgeInsets.all(4),
            child: Wrap(
              children: DeliveryDay.values
                  .map(
                    (e) => Padding(
                      padding: const EdgeInsets.all(4),
                      child: ChoiceChip(
                        onSelected: (v) => model.deliveryDay = e,
                        label: Text(e),
                        selected: model.deliveryDay == e,
                      ),
                    ),
                  )
                  .toList(),
            ),
          ),
          SchedulePreview(dates: model.dates),
        ],
      ),
    );
  }
}
