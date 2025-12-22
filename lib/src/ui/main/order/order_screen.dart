import 'dart:convert';

import 'package:cafeapp/src/api/repository.dart';
import 'package:cafeapp/src/bloc/order/order_bloc.dart';
import 'package:cafeapp/src/dialog/center_dialog.dart';
import 'package:cafeapp/src/model/http_result.dart';
import 'package:cafeapp/src/model/place/place_model.dart';
import 'package:cafeapp/src/theme/app_colors.dart';
import 'package:cafeapp/src/theme/app_style.dart';
import 'package:cafeapp/src/utils/utils.dart';
import 'package:cafeapp/src/widget/food_card_widget.dart';
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
                Text(widget.data.hallName,style: AppStyle.font400(AppColors.grey),),
                Text(widget.data.name),
              ],
            ),
            Spacer(),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Joy xaqqi",style: AppStyle.font400(AppColors.grey),),
                Text("${Utils.formatNumber(widget.data.placePrice)} so'm",style: AppStyle.font600(AppColors.buttonColor),),
              ],
            )
          ],
        ),
        foregroundColor: AppColors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(25)
        ),
        backgroundColor: AppColors.inputColor,
      ),
      body: RefreshIndicator(
        backgroundColor: AppColors.buttonColor,
        color: AppColors.black,
        onRefresh: ()async{
          orderDetailBloc.getAllOrderDetail(widget.data.lastOrder.id);
        },
        child: StreamBuilder(
          stream: orderDetailBloc.getOrderDetailStream,
          builder: (context, asyncSnapshot) {
            if(asyncSnapshot.hasData){
              var data = asyncSnapshot.data!;
              return Column(
                children: [
                  Expanded(child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: ListView.builder(
                          itemCount: data.items.length,
                          itemBuilder: (ctx,index){
                            return Slidable(
                              endActionPane: ActionPane(motion: ScrollMotion(), children: [
                                SlidableAction(
                                  onPressed: (i){},
                                  backgroundColor: AppColors.background,
                                  foregroundColor: AppColors.red,
                                  icon: Icons.delete,
                                  label: "O'chirish",
                                ),
                                SlidableAction(
                                  onPressed: (i){},
                                  backgroundColor: AppColors.background,
                                  foregroundColor: AppColors.green,
                                  icon: Icons.edit,
                                  label: 'Tahrirlash',
                                ),
                              ]),
                                child: Stack(
                              children: [
                                FoodCardWidget(name: data.items[index].food.name, img: data.items[index].food.name, price: data.items[index].food.price,),
                                Positioned(
                                  bottom: 0,
                                  right: 0,
                                  child: Container(
                                    decoration: BoxDecoration(
                                        color: AppColors.background,
                                        borderRadius: BorderRadius.only(
                                          topLeft: Radius.circular(20),
                                        )
                                    ),
                                    child: Row(
                                      children: [
                                        IconButton(onPressed: ()async{
                                          CenterDialog.showLoadingDialog(context);
                                          Map updateOrder = {
                                            "place_id": data.id,
                                            "order_type": "waiter",
                                            "item":
                                              {
                                                "food_id": data.items[index].foodId,
                                                "weight_type": "pors", // pors yoki kg
                                                "quantity": data.items[index].quantity-1,
                                                "price": data.items[index].price
                                              }
                                          };
                                          if(data.items[index].quantity==1){
                                            Navigator.pop(context);

                                          }
                                          else{
                                            HttpResult res = await _repository.updateOrder(json.encode(updateOrder),widget.data.lastOrder.id);
                                            if(res.status >=200 && res.status<299){
                                              orderDetailBloc.getAllOrderDetail(widget.data.lastOrder.id);
                                              Navigator.pop(context);
                                            }
                                          }
                                        }, icon: Icon(Icons.remove,color: AppColors.white,),hoverColor: AppColors.buttonColor,highlightColor: AppColors.buttonColor,),
                                        SizedBox(width: 8.sp,),
                                        Text(Utils.formatNumber(data.items[index].quantity),style: AppStyle.font500(AppColors.white),),
                                        SizedBox(width: 8.sp,),
                                        IconButton(onPressed: ()async{
                                          CenterDialog.showLoadingDialog(context);
                                          Map updateOrder = {
                                            "place_id": data.place.id,
                                            "order_type": "waiter",
                                            "delete": false,
                                            "item":
                                            {
                                              "food_id": data.items[index].foodId,
                                              "weight_type": "pors", // pors yoki kg
                                              "quantity": data.items[index].quantity+1,
                                              "price": data.items[index].price
                                            }
                                          };
                                          HttpResult res = await _repository.updateOrder(json.encode(updateOrder),widget.data.lastOrder.id);
                                          if(res.status >=200 && res.status<299){
                                            orderDetailBloc.getAllOrderDetail(widget.data.lastOrder.id);
                                            Navigator.pop(context);
                                          }else{
                                            CenterDialog.showCenterDialog(ctx, res.result);
                                          }
                                        }, icon: Icon(Icons.add,color: AppColors.white,),hoverColor: AppColors.buttonColor,highlightColor: AppColors.buttonColor,),
                                      ],
                                    ),
                                  ),
                                )
                              ],
                            )
                            );
                          })
                  ),)
                ],
              );
            }else{
              orderDetailBloc.getAllOrderDetail(widget.data.lastOrder.id);
              return SizedBox();
            }
          }
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        label: Text('Taom qo\'shish',style: AppStyle.font600(AppColors.black),),
        icon: Icon(Icons.add,color: AppColors.black,),
        backgroundColor: AppColors.buttonColor,
        onPressed: (){}),
    );
  }
}
