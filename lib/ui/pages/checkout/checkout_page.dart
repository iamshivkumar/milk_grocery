// import 'package:flutter/foundation.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:google_maps_flutter/google_maps_flutter.dart';

// import '../../core/enums/delivery_by.dart';
// import '../../core/models/order_product.dart';
// import '../../utils/utils.dart';
// import '../orders/orders_page.dart';
// import '../widgets/tow_text_row.dart';
// import 'checkout_view_model/checkout_view_model_provider.dart';
// import 'widgets/selection_tile.dart';

// class CheckoutPage extends ConsumerWidget {
//   final List<OrderProduct> orderProducts;
//   final double total;
//   final int items;

//   const CheckoutPage(
//       {Key? key,
//       required this.orderProducts,
//       required this.total,
//       required this.items})
//       : super(key: key);

//   @override
//   Widget build(BuildContext context, ScopedReader watch) {
//     final theme = Theme.of(context);
//     final model = watch(checkoutViewModelProvider);
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Place Order'),
//       ),
//       body: Stepper(
//         currentStep: model.currentStep,
//         onStepTapped: model.ready ? model.setStep : null,
//         controlsBuilder: (context, {onStepCancel, onStepContinue}) => Padding(
//           padding: const EdgeInsets.symmetric(vertical: 16),
//           child: Row(
//             children: [
//               MaterialButton(
//                 child: Text(model.currentStep == 2
//                     ? model.paymentMethod == "Razorpay"
//                         ? "PAY"
//                         : "CONFIRM"
//                     : "CONTINUE"),
//                 onPressed: model.currentStep == 0 && model.ready ||
//                         model.currentStep == 1 ||
//                         model.currentStep == 2 && model.paymentMethod != null
//                     ? onStepContinue
//                     : null,
//                 color: theme.accentColor,
//               ),
//               SizedBox(
//                 width: 16,
//               ),
//               TextButton(
//                 onPressed: model.back,
//                 child: Text(model.currentStep == 0 ? 'CANCEL' : 'BACK'),
//               )
//             ],
//           ),
//         ),
//         onStepContinue: () {
//           if (model.currentStep == 2) {
//             model.payOrder(
//                 products: orderProducts,
//                 total: total,
//                 items: items,
//                 onOrder: () {
//                   Navigator.pop(context);
//                   Navigator.pushReplacement(
//                     context,
//                     MaterialPageRoute(
//                       builder: (context) => OrdersPage(),
//                     ),
//                   );
//                 });
//           } else {
//             model.next();
//           }
//         },
//         onStepCancel: () =>
//             model.currentStep == 0 ? Navigator.pop(context) : model.back(),
//         type: StepperType.vertical,
//         steps: [
//           Step(
//             isActive: true,
//             state: model.currentStep == 0
//                 ? StepState.editing
//                 : model.currentStep > 0
//                     ? StepState.complete
//                     : StepState.indexed,
//             title: Text("Delivery Options"),
//             content: Column(
//               children: [
//                 Material(
//                   color: theme.primaryColor,
//                   child: Column(
//                     children: [
//                       ListTile(
//                         title: Text('Delivery Day'),
//                       ),
//                       Column(
//                           children: Utils.deliveryDates
//                               .map(
//                                 (e) => SelectionTile(
//                                   value: model.date == e,
//                                   onTap: () => model.date = e,
//                                   title: Text(
//                                     Utils.weekday(e),
//                                   ),
//                                 ),
//                               )
//                               .toList())
//                     ],
//                   ),
//                 ),
//                 SizedBox(
//                   height: 8,
//                 ),
//                 Material(
//                   color: theme.primaryColor,
//                   child: Column(
//                     children: [
//                       ListTile(
//                         title: Text('Delivery By'),
//                       ),
//                       Column(
//                         children: DeliveyBy.values
//                             .map((e) => SelectionTile(
//                                   value: model.deliveyBy == e,
//                                   onTap: () => model.deliveyBy = e,
//                                   title: Text(
//                                     describeEnum(e),
//                                   ),
//                                 ))
//                             .toList(),
//                       ),
//                     ],
//                   ),
//                 ),
//                 SizedBox(
//                   height: 8,
//                 ),
//                 Material(
//                   color: theme.primaryColor,
//                   child: Column(
//                     children: [
//                       ListTile(
//                         title: Text('Delivery Address'),
//                       ),
//                       Column(
//                         children: model.profile.locations
//                             .map(
//                               (e) => ListTile(
//                                 onTap: () => model.geoPoint = e,
//                                 selectedTileColor: theme.primaryColorDark,
//                                 selected: model.geoPoint == e,
//                                 contentPadding: EdgeInsets.symmetric(
//                                     horizontal: 16, vertical: 8),
//                                 title: AspectRatio(
//                                   aspectRatio: 2,
//                                   child: GoogleMap(
//                                     liteModeEnabled: true,
//                                     key: Key(e.toString()),
//                                     initialCameraPosition: CameraPosition(
//                                       target: LatLng(e.latitude, e.longitude),
//                                       zoom: 16,
//                                     ),
//                                     markers: {
//                                       Marker(
//                                         markerId: MarkerId("1"),
//                                         position:
//                                             LatLng(e.latitude, e.longitude),
//                                       ),
//                                     },
//                                   ),
//                                 ),
//                                 subtitle: Padding(
//                                   padding: const EdgeInsets.only(top: 8),
//                                   child: Text(
//                                     e.toString(),
//                                     style: TextStyle(fontSize: 14),
//                                   ),
//                                 ),
//                               ),
//                             )
//                             .toList(),
//                       )
//                     ],
//                   ),
//                 ),
//               ],
//             ),
//           ),
//           Step(
//             isActive: model.ready,
//             state: model.currentStep == 1
//                 ? StepState.editing
//                 : model.currentStep > 0
//                     ? StepState.complete
//                     : StepState.indexed,
//             title: Text("Order Details"),
//             content: Column(
//               children: [
//                 Material(
//                   color: theme.primaryColor,
//                   child: Column(
//                     children: [
//                       Column(
//                         children: orderProducts.map((e) {
//                           return ListTile(
//                             leading: SizedBox(
//                               height: 56,
//                               width: 56,
//                               child: Image.network(
//                                 e.image,
//                               ),
//                             ),
//                             title: Text(e.name),
//                             subtitle: Text(e.qt.toString() +
//                                 " Items x ₹" +
//                                 e.price.toString()),
//                             trailing: Text(
//                               "₹" + (e.qt * e.price).toString(),
//                             ),
//                           );
//                         }).toList(),
//                       ),
//                       model.profile.walletAmount != 0
//                           ? Material(
//                               color: theme.primaryColorDark,
//                               child: ListTile(
//                                 dense: true,
//                                 minLeadingWidth: 0,
//                                 leading:
//                                     Icon(Icons.account_balance_wallet_outlined),
//                                 title: Text(
//                                   'Wallet Amount: ₹' +
//                                       (model.profile.walletAmount -
//                                               model.walletAmount)
//                                           .toString(),
//                                 ),
//                                 trailing: model.walletAmount == 0
//                                     ? IconButton(
//                                         icon: Icon(Icons.arrow_forward_ios),
//                                         onPressed: () => model.useWallet(total),
//                                       )
//                                     : IconButton(
//                                         icon: Icon(Icons.close),
//                                         onPressed: model.cancelUsingWallet,
//                                       ),
//                               ),
//                             )
//                           : SizedBox(),
//                       Padding(
//                         padding: const EdgeInsets.all(8.0),
//                         child: Column(
//                           children: [
//                             TwoTextRow(
//                               text1: 'Items $items',
//                               text2: '₹' + total.toString(),
//                             ),
//                             TwoTextRow(
//                               text1: 'Delivery charge',
//                               text2:
//                                   '₹' + model.deliveryCharge.toInt().toString(),
//                             ),
//                             TwoTextRow(
//                               text1: 'Wallet Amount',
//                               text2:
//                                   '₹' + model.walletAmount.toInt().toString(),
//                             ),
//                             TwoTextRow(
//                               text1: 'Total Price',
//                               text2: '₹' +
//                                   (total +
//                                           model.deliveryCharge -
//                                           model.walletAmount)
//                                       .toInt()
//                                       .toString(),
//                             ),
//                           ],
//                         ),
//                       )
//                     ],
//                   ),
//                 )
//               ],
//             ),
//           ),
//           Step(
//             isActive: model.ready,
//             state: model.currentStep == 2
//                 ? StepState.editing
//                 : model.currentStep > 2
//                     ? StepState.complete
//                     : StepState.indexed,
//             title: Text('Payment & Confirmation'),
//             content: Column(
//               children: [
//                 Material(
//                   color: theme.primaryColor,
//                   child: Column(
//                     children: [
//                       ListTile(
//                         title: Text('Payment Method'),
//                       ),
//                       Column(
//                         children: ["Razorpay", "Cash On Delivery"]
//                             .map(
//                               (e) => SelectionTile(
//                                 value: model.paymentMethod == e,
//                                 onTap: () => model.paymentMethod = e,
//                                 title: Text(e),
//                               ),
//                             )
//                             .toList(),
//                       ),
//                       model.paymentMethod == "Razorpay"
//                           ? Padding(
//                               padding: const EdgeInsets.all(16.0),
//                               child: Text(
//                                 'Order will be confirmed once a payment successful.',
//                                 style:
//                                     TextStyle(color: Colors.grey, fontSize: 13),
//                               ),
//                             )
//                           : SizedBox()
//                     ],
//                   ),
//                 ),
//               ],
//             ),
//           )
//         ],
//       ),
//     );
//   }
// }
