import 'package:cached_network_image/cached_network_image.dart';
import 'package:expandable/expandable.dart';
import 'package:flutter/material.dart';
import 'package:mobile/core/constants/app/app_constants.dart';
import 'package:mobile/core/init/theme/color_theme.dart';
import 'package:mobile/locator.dart';
import 'package:mobile/view/orders/model/order_model.dart';
import 'package:mobile/view/orders/viewmodel/orders_view_model.dart';

class TrackProductBig extends StatelessWidget {
  final OrderModel order;
  const TrackProductBig({
    Key? key,
    required this.order,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
        children: order.orderDetails!
            .map((e) => _expandablePanel(context, e))
            .toList());
  }

  ExpandablePanel _expandablePanel(
    BuildContext context,
    OrderDetails _orderDetails,
  ) {
    return ExpandablePanel(
      header: InkWell(
        child: Container(
          height: 80,
          margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
          //padding: const EdgeInsets.all(12),
          width: double.infinity,
          decoration: BoxDecoration(
            color: AppColors.white,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.start,
            mainAxisSize: MainAxisSize.max,
            children: [
              imageClip(_orderDetails.product?.photos?.first.photoUrl),
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(width: 20),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(10, 15, 5, 5),
                    child: Text(_orderDetails.product!.title!.length >= 12 ?
                      _orderDetails.product!.title!.substring(0, 12) :
                          _orderDetails.product!.title!,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: AppColors.black,
                      ),
                    ),
                  ),
                  Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.fromLTRB(10, 5, 5, 10),
                        child: Text(
                          _orderDetails.product!.distributor ?? "Goal Design",
                          style: const TextStyle(
                            color: AppColors.darkGray,
                            fontWeight: FontWeight.w200,
                            fontSize: 12,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              Row(
                children: [
                  const SizedBox(width: 30),
                  Text(
                    "₺${(_orderDetails.product!.price ?? 0) * (_orderDetails.quantity ?? 0)}",
                    style: const TextStyle(
                      color: AppColors.primary,
                      fontWeight: FontWeight.w800,
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
      collapsed: const Text(""),
      expanded: _status(
        context,
        _orderDetails.product?.id,
        (_orderDetails.product!.price ?? 0).toDouble(),
        ((_orderDetails.product!.price ?? 0) * (_orderDetails.quantity ?? 0))
            .toDouble(),
        _orderDetails.orderStatus!,
        _orderDetails.quantity.toString(),
      ),
    );
  }

  ClipRRect imageClip(String? img) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(12),
      child: AspectRatio(
        aspectRatio: 1,
        child: CachedNetworkImage(
          imageUrl: img ?? ApplicationConstants.PRODUCT_IMG,
          width: 60,
          height: 60,
          fit: BoxFit.fill,
        ),
      ),
    );
  }

  OutlinedButton _refundButton(BuildContext context) {
    late OrdersViewModel viewModel;

    return OutlinedButton(
      onPressed: () async {
        viewModel = locator<OrdersViewModel>();
        await viewModel.refund(
          context: context,
          orderId: order.orderDetails!.first.id,
        );
      },
      child: const Text(
        "Refund",
        style: TextStyle(
          color: AppColors.primaryLight,
          fontSize: 14,
          fontWeight: FontWeight.w700,
        ),
      ),
      style: OutlinedButton.styleFrom(
          backgroundColor: AppColors.white,
          primary: AppColors.primary,
          fixedSize: const Size(100, 30),
          side: const BorderSide(width: 1.0, color: AppColors.darkGray)),
    );
  }

  InkWell _status(
    BuildContext context,
    int? _id,
    double? _price,
    double? _total,
    String status,
    String quantity,
  ) {
    return InkWell(
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
        //padding: const EdgeInsets.all(12),
        width: double.infinity,
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("Order-ID: $_id",
                      style: const TextStyle(
                        color: AppColors.black,
                        fontWeight: FontWeight.w700,
                      )),
                  Text("Quantitiy: $quantity",
                      style: const TextStyle(
                        color: AppColors.darkGray,
                        fontWeight: FontWeight.w600,
                      ))
                ],
              ),
              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  if (status == "PROCESSING")
                    RichText(
                      text: const TextSpan(
                        children: [
                          WidgetSpan(
                              child: Icon(Icons.call_received,
                                  color: AppColors.primaryLight, size: 24)),
                          TextSpan(
                              text: " PROCESSING",
                              style: TextStyle(
                                  color: AppColors.primaryLight, fontSize: 24)),
                        ],
                      ),
                    ),
                  if (status == "INTRANSIT")
                    RichText(
                      text: const TextSpan(
                        children: [
                          WidgetSpan(
                              child: Icon(Icons.local_shipping,
                                  color: AppColors.azure, size: 24)),
                          TextSpan(
                              text: " INTRANSIT",
                              style: TextStyle(
                                  color: AppColors.azure, fontSize: 24))
                        ],
                      ),
                    ),
                  if (status == "DELIVERED")
                    RichText(
                      text: const TextSpan(
                        children: [
                          WidgetSpan(
                              child: Icon(Icons.local_shipping,
                                  color: Colors.green, size: 24)),
                          TextSpan(
                              text: " DELIVERED",
                              style:
                                  TextStyle(color: Colors.green, fontSize: 24))
                        ],
                      ),
                    ),
                  if (status == "REFUNDED")
                    RichText(
                      text: const TextSpan(
                        children: [
                          WidgetSpan(
                              child: Icon(Icons.local_shipping,
                                  color: Colors.indigoAccent, size: 24)),
                          TextSpan(
                              text: " REFUNDED",
                              style: TextStyle(
                                  color: Colors.indigoAccent, fontSize: 24))
                        ],
                      ),
                    ),
                  if (status != "REFUNDED") _refundButton(context),
                ],
              ),
              const SizedBox(height: 10),
              Row(
                children: const [
                  Text(
                    "Delivery Address",
                    style: TextStyle(
                      color: AppColors.black,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    order.address?.personalName ?? "",
                    style: const TextStyle(
                        color: AppColors.black, fontWeight: FontWeight.w600),
                  ),
                  Text(
                    order.address?.phoneNumber ?? "",
                    style: const TextStyle(
                        color: AppColors.black, fontWeight: FontWeight.w400),
                  ),
                ],
              ),
              Row(
                children: [
                  Flexible(
                    child: Text(
                      order.address!.fullAddress ??
                          "Orta Mahallesi, Üniversite Caddesi\nNo:27 Tuzla, 34956 İstanbul",
                      style: const TextStyle(
                        color: AppColors.black,
                        fontSize: 14,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ),
                ],
              ),
              Row(
                children: [
                  Text(
                    order.address!.name ?? "Charles Leclerc - 90505***4567",
                    style: const TextStyle(
                      color: AppColors.black,
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  )
                ],
              ),
              const SizedBox(height: 20),
              Row(
                children: const [
                  Text(
                    "Payment Information",
                    style: TextStyle(
                      color: AppColors.black,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 5),
              Row(
                children: [
                  Text(
                    "Payment Method: ${order.credit?.paymentMethod}",
                    style: const TextStyle(
                      color: AppColors.black,
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Card information: ${order.credit?.cardNumber ?? "**** **** **** ****"}",
                    style: const TextStyle(
                      color: AppColors.black,
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  Text(
                    order.credit?.cardName ?? "",
                    style: const TextStyle(
                      color: AppColors.black,
                      fontSize: 14,
                      fontWeight: FontWeight.w400,
                    ),
                  )
                ],
              ),
              const SizedBox(height: 5),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: const [
                  Text(
                    "Shipment",
                    style: TextStyle(
                        color: AppColors.black,
                        fontSize: 14,
                        fontWeight: FontWeight.w400),
                  ),
                  Text(
                    "Free",
                    style: TextStyle(
                        color: AppColors.black,
                        fontSize: 14,
                        fontWeight: FontWeight.w700),
                  )
                ],
              ),
              const SizedBox(height: 5),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    "Sum",
                    style: TextStyle(
                        color: AppColors.black,
                        fontSize: 14,
                        fontWeight: FontWeight.w400),
                  ),
                  Text(
                    "₺${_price ?? 380}",
                    style: const TextStyle(
                        color: AppColors.black,
                        fontSize: 14,
                        fontWeight: FontWeight.w700),
                  )
                ],
              ),
              const SizedBox(height: 5),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    "Sum",
                    style: TextStyle(
                        color: AppColors.black,
                        fontSize: 14,
                        fontWeight: FontWeight.w400),
                  ),
                  Text(
                    "₺${_total ?? 380}",
                    style: const TextStyle(
                        color: AppColors.black,
                        fontSize: 14,
                        fontWeight: FontWeight.w700),
                  )
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
