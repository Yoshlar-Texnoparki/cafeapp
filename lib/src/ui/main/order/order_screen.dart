import 'dart:convert';

import 'package:cafeapp/src/api/repository.dart';
import 'package:cafeapp/src/bloc/order/order_bloc.dart';
import 'package:cafeapp/src/dialog/center_dialog.dart';
import 'package:cafeapp/src/model/http_result.dart';
import 'package:cafeapp/src/model/place/place_model.dart';
import 'package:cafeapp/src/theme/app_colors.dart';
import 'package:cafeapp/src/theme/app_style.dart';
import 'package:cafeapp/src/ui/food/foods_screen.dart';
import 'package:cafeapp/src/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

class OrderScreen extends StatefulWidget {
  final PlaceModel data;
  const OrderScreen({super.key, required this.data});

  @override
  State<OrderScreen> createState() => _OrderScreenState();
}

class _OrderScreenState extends State<OrderScreen> {
  @override
  void initState() {
    orderDetailBloc.getAllOrderDetail(widget.data.lastOrder.id);
    super.initState();
  }

  final Repository _repository = Repository();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        centerTitle: false,
        title: Row(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.data.hallName,
                  style: AppStyle.font400(AppColors.grey),
                ),
                Text(widget.data.name),
              ],
            ),
            Spacer(),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Joy xaqqi", style: AppStyle.font400(AppColors.grey)),
                Text(
                  "${Utils.formatNumber(widget.data.placePrice)} so'm",
                  style: AppStyle.font600(AppColors.buttonColor),
                ),
              ],
            ),
          ],
        ),
        foregroundColor: AppColors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
        backgroundColor: AppColors.inputColor,
      ),
      body: RefreshIndicator(
        backgroundColor: AppColors.buttonColor,
        color: AppColors.black,
        onRefresh: () async {
          orderDetailBloc.getAllOrderDetail(widget.data.lastOrder.id);
        },
        child: StreamBuilder(
          stream: orderDetailBloc.getOrderDetailStream,
          builder: (context, asyncSnapshot) {
            if (asyncSnapshot.hasData) {
              var data = asyncSnapshot.data!;
              return Column(
                children: [
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: ListView.builder(
                        itemCount: data.items.length,
                        itemBuilder: (ctx, index) {
                          return Slidable(
                            endActionPane: ActionPane(
                              motion: ScrollMotion(),
                              children: [
                                SlidableAction(
                                  onPressed: (i) {},
                                  backgroundColor: AppColors.background,
                                  foregroundColor: AppColors.red,
                                  icon: Icons.delete,
                                  label: "O'chirish",
                                ),
                              ],
                            ),
                            child: Container(
                              padding: EdgeInsets.all(4.r),
                              width: 1.sw,
                              margin: const EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 4,
                              ),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                color: AppColors.inputColor,
                              ),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Container(
                                    width: 70.r,
                                    height: 70.r,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10),
                                      color: AppColors.inputColor,
                                    ),
                                    child:
                                        data.items[index].food.image != "" &&
                                            data.items[index].food.image != null
                                        ? ClipRRect(
                                            borderRadius: BorderRadius.circular(
                                              10,
                                            ),
                                            child: Image.network(
                                              data.items[index].food.image
                                                  .toString(),
                                              fit: BoxFit.cover,
                                              errorBuilder:
                                                  (
                                                    context,
                                                    error,
                                                    stackTrace,
                                                  ) => Icon(
                                                    Icons.fastfood_sharp,
                                                    size: 34,
                                                    color: AppColors.grey,
                                                  ),
                                            ),
                                          )
                                        : Icon(
                                            Icons.fastfood_sharp,
                                            size: 34,
                                            color: AppColors.grey,
                                          ),
                                  ),
                                  SizedBox(width: 8.w),
                                  Expanded(
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          data.items[index].food.name,
                                          style: AppStyle.font800(
                                            AppColors.white,
                                          ),
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                        SizedBox(height: 8.h),
                                        Text(
                                          "${data.items[index].food.price} so'm",
                                          style: AppStyle.font800(
                                            AppColors.buttonColor,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Row(
                                    children: [
                                      IconButton(
                                        onPressed: () async {
                                          CenterDialog.showLoadingDialog(
                                            context,
                                          );
                                          double delta =
                                              data.items[index].weightType ==
                                                  'kg'
                                              ? 0.1
                                              : 1;
                                          Map updateOrder = {
                                            "place_id": data.place.id,
                                            "order_type": "waiter",
                                            "item": {
                                              "food_id":
                                                  data.items[index].foodId,
                                              "weight_type":
                                                  data.items[index].weightType,
                                              "quantity":
                                                  data.items[index].quantity -
                                                  delta,
                                              "price": data.items[index].price,
                                            },
                                          };
                                          if (data.items[index].quantity <=
                                              delta) {
                                            Navigator.pop(context);
                                          } else {
                                            HttpResult res = await _repository
                                                .updateOrder(
                                                  json.encode(updateOrder),
                                                  widget.data.lastOrder.id,
                                                );
                                            if (res.status >= 200 &&
                                                res.status < 299) {
                                              orderDetailBloc.getAllOrderDetail(
                                                widget.data.lastOrder.id,
                                              );
                                              Navigator.pop(context);
                                            } else {
                                              Navigator.pop(context);
                                              CenterDialog.showCenterDialog(
                                                ctx,
                                                res.result,
                                              );
                                            }
                                          }
                                        },
                                        icon: Icon(
                                          Icons.remove_circle,
                                          color: AppColors.grey,
                                          size: 24.sp,
                                        ),
                                        padding: EdgeInsets.zero,
                                        constraints: const BoxConstraints(),
                                      ),
                                      Padding(
                                        padding: EdgeInsets.symmetric(
                                          horizontal: 4.w,
                                        ),
                                        child: Text(
                                          data.items[index].weightType == 'kg'
                                              ? data.items[index].quantity
                                                    .toStringAsFixed(1)
                                              : data.items[index].quantity
                                                    .toInt()
                                                    .toString(),
                                          style: AppStyle.font800(
                                            AppColors.white,
                                          ),
                                        ),
                                      ),
                                      IconButton(
                                        onPressed: () async {
                                          CenterDialog.showLoadingDialog(
                                            context,
                                          );
                                          double delta =
                                              data.items[index].weightType ==
                                                  'kg'
                                              ? 0.1
                                              : 1;
                                          Map updateOrder = {
                                            "place_id": data.place.id,
                                            "order_type": "waiter",
                                            "delete": false,
                                            "item": {
                                              "food_id":
                                                  data.items[index].foodId,
                                              "weight_type":
                                                  data.items[index].weightType,
                                              "quantity":
                                                  data.items[index].quantity +
                                                  delta,
                                              "price": data.items[index].price,
                                            },
                                          };
                                          HttpResult res = await _repository
                                              .updateOrder(
                                                json.encode(updateOrder),
                                                widget.data.lastOrder.id,
                                              );
                                          if (res.status >= 200 &&
                                              res.status < 299) {
                                            orderDetailBloc.getAllOrderDetail(
                                              widget.data.lastOrder.id,
                                            );
                                            Navigator.pop(context);
                                          } else {
                                            Navigator.pop(context);
                                            CenterDialog.showCenterDialog(
                                              ctx,
                                              res.result,
                                            );
                                          }
                                        },
                                        icon: Icon(
                                          Icons.add_circle,
                                          color: AppColors.buttonColor,
                                          size: 28.sp,
                                        ),
                                        padding: EdgeInsets.zero,
                                        constraints: const BoxConstraints(),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                ],
              );
            } else {
              // orderDetailBloc.getAllOrderDetail(widget.data.lastOrder.id);
              return SizedBox();
            }
          },
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        label: Text('Taom qo\'shish', style: AppStyle.font600(AppColors.black)),
        icon: Icon(Icons.add, color: AppColors.black),
        backgroundColor: AppColors.buttonColor,
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (builder) {
                return FoodsScreen(
                  placeId: widget.data.id,
                  placeName: widget.data.name,
                  orderId: widget.data.lastOrder.id,
                );
              },
            ),
          );
        },
      ),
    );
  }
}
