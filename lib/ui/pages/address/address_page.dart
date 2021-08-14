import 'package:flutter/material.dart';
import '../../../core/providers/profile_provider.dart';
import '../auth/add_area_page.dart';
import '../auth/providers/add_area_view_model_provider.dart';
import '../../widgets/loading.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class AddressPage extends ConsumerWidget {
  @override
  Widget build(BuildContext context, ScopedReader watch) {
    final theme = Theme.of(context);
    final style = theme.textTheme;
    final profileStream = watch(profileProvider);
    return Scaffold(
      appBar: AppBar(
        title: Text("My Delivery Address"),
      ),
      bottomNavigationBar: profileStream.data != null
          ? Material(
              color: theme.cardColor,
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                child: MaterialButton(
                  color: theme.accentColor,
                  onPressed: () {
                    context
                        .read(addAreaViewModelProvider)
                        .initializeForEdit(profileStream.data!.value);
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => AreaPickPage(),
                      ),
                    );
                  },
                  child: Text("EDIT ADDRESS"),
                ),
              ),
            )
          : SizedBox(),
      body: profileStream.when(
        data: (profile) => ListView(
          padding: EdgeInsets.all(2),
          children: [
            Padding(
              padding: const EdgeInsets.all(2.0),
              child: Material(
                color: Colors.white,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          "Milk Man Mobile Number:",
                          style: style.caption,
                        ),
                      ),
                      Row(
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              profile.milkManId ?? "",
                              style: style.headline6,
                            ),
                          ),
                          Spacer(),
                          IconButton(
                            onPressed: () {},
                            icon: Icon(Icons.call),
                          )
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(2.0),
              child: Material(
                color: Colors.white,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          "Area",
                          style: style.caption,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          profile.area ?? "",
                          style: style.headline6,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(2.0),
              child: Material(
                color: Colors.white,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          "House /Flat/ Block No",
                          style: style.caption,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          profile.number ?? "",
                          style: style.headline6,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(2.0),
              child: Material(
                color: Colors.white,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          "Landmark",
                          style: style.caption,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          profile.landMark ?? "",
                          style: style.headline6,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
        loading: () => Loading(),
        error: (e, s) => Text(
          e.toString(),
        ),
      ),
    );
  }
}
