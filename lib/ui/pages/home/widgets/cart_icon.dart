import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/providers/profile_provider.dart';
import '../../cart/cart_page.dart';

class CartIcon extends ConsumerWidget {
  @override
  Widget build(BuildContext context, ScopedReader watch) {
    final theme = Theme.of(context);
    final style = theme.textTheme;
    final profileAsync = watch(profileProvider);
    return IconButton(
      icon: Stack(
        children: [
          Icon(Icons.shopping_cart_outlined),
          profileAsync.data != null
              ? Positioned(
                  bottom: 0,
                  right: 0,
                  child: CircleAvatar(
                    radius: 8,
                    backgroundColor: Colors.black45,
                    child: Text(
                      profileAsync.data!.value.cartProducts.length.toString(),
                      style: style.overline!.copyWith(color: Colors.white),
                    ),
                  ),
                )
              : SizedBox(),
        ],
      ),
      onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => CartPage(),
          ),
        );
      },
    );
  }
}
