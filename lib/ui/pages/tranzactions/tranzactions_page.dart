import 'package:flutter/material.dart';
import 'package:grocery_app/ui/pages/tranzactions/providers/tranzactions_view_model_provider.dart';
import 'package:grocery_app/utils/utils.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../widgets/loading.dart';

class TranzactionsPage extends ConsumerWidget {
  @override
  Widget build(BuildContext context, ScopedReader watch) {
    final model = watch(tranzactionsViewModelProvider);
    return Scaffold(
      appBar: AppBar(
        title: Text("Tranzactions History"),
      ),
      body: model.tranzactions.isEmpty
          ? Loading()
          : NotificationListener<ScrollNotification>(
              onNotification: (notification) {
                if (!model.busy &&
                    notification.metrics.pixels ==
                        notification.metrics.maxScrollExtent) {
                  model.getProductsMore();
                }
                return true;
              },
              child: RefreshIndicator(
                onRefresh: () async =>
                    context.refresh(tranzactionsViewModelProvider),
                child: CustomScrollView(
                  slivers: [
                    SliverList(
                      delegate: SliverChildListDelegate(
                        model.tranzactions
                            .map(
                              (e) => ListTile(
                                title: Text(e.amountLabel),
                                subtitle: Text(e.type),
                                trailing: Text(Utils.formatedDateTime(e.createdAt)),
                              ),
                            )
                            .toList(),
                      ),
                    ),
                    SliverToBoxAdapter(
                      child: Center(
                        child: model.loading && model.tranzactions.length > 8
                            ? Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: CircularProgressIndicator(),
                              )
                            : SizedBox(),
                      ),
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}
