import 'package:cafeapp/src/bloc/order/order_bloc.dart';
import 'package:cafeapp/src/model/order/order_detail.dart';
import 'package:cafeapp/src/theme/app_colors.dart';
import 'package:cafeapp/src/theme/app_style.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';

class OrderHistoryScreen extends StatefulWidget {
  const OrderHistoryScreen({super.key});

  @override
  State<OrderHistoryScreen> createState() => _OrderHistoryScreenState();
}

class _OrderHistoryScreenState extends State<OrderHistoryScreen> {
  @override
  void initState() {
    super.initState();
    orderDetailBloc.getAllOrders();
  }

  Future<void> _refreshOrders() async {
    orderDetailBloc.getAllOrders();
  }

  String _getStatusText(bool isActive) {
    if (isActive) {
      return 'Faol';
    } else {
      return 'Yakunlangan';
    }
  }

  Color _getStatusColor(bool isActive) {
    if (isActive) {
      return AppColors.buttonColor;
    } else {
      return AppColors.green;
    }
  }

  String _formatDate(DateTime date) {
    return DateFormat('dd.MM.yyyy HH:mm').format(date);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.inputColor,
        foregroundColor: AppColors.white,
        title: Text(
          'Buyurtmalar tarixi',
          style: AppStyle.font800(AppColors.white),
        ),
        elevation: 0,
      ),
      body: StreamBuilder<List<OrderDetailModel>>(
        stream: orderDetailBloc.getOrderHistoryStream,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return _buildLoadingState();
          }

          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return _buildEmptyState();
          }

          final orders = snapshot.data!;
          return RefreshIndicator(
            onRefresh: _refreshOrders,
            color: AppColors.buttonColor,
            backgroundColor: AppColors.inputColor,
            child: ListView.builder(
              padding: EdgeInsets.all(16.r),
              itemCount: orders.length,
              itemBuilder: (context, index) {
                final order = orders[index];
                return _buildOrderCard(order, index);
              },
            ),
          );
        },
      ),
    );
  }

  Widget _buildLoadingState() {
    return ListView.builder(
      padding: EdgeInsets.all(16.r),
      itemCount: 5,
      itemBuilder: (context, index) {
        return Container(
          margin: EdgeInsets.only(bottom: 16.h),
          padding: EdgeInsets.all(16.r),
          decoration: BoxDecoration(
            color: AppColors.inputColor,
            borderRadius: BorderRadius.circular(16.r),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 150.w,
                height: 20.h,
                decoration: BoxDecoration(
                  color: AppColors.background,
                  borderRadius: BorderRadius.circular(4.r),
                ),
              ),
              SizedBox(height: 12.h),
              Container(
                width: double.infinity,
                height: 60.h,
                decoration: BoxDecoration(
                  color: AppColors.background,
                  borderRadius: BorderRadius.circular(4.r),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.receipt_long_outlined, size: 80.sp, color: AppColors.grey),
          SizedBox(height: 16.h),
          Text(
            'Hali buyurtmalar yo\'q',
            style: AppStyle.font800(AppColors.grey).copyWith(fontSize: 18.sp),
          ),
          SizedBox(height: 8.h),
          Text(
            'Buyurtmalar bu yerda ko\'rinadi',
            style: AppStyle.font400(AppColors.grey),
          ),
        ],
      ),
    );
  }

  Widget _buildOrderCard(OrderDetailModel order, int index) {
    return TweenAnimationBuilder<double>(
      duration: Duration(milliseconds: 300 + (index * 100)),
      tween: Tween(begin: 0.0, end: 1.0),
      builder: (context, value, child) {
        return Opacity(
          opacity: value,
          child: Transform.translate(
            offset: Offset(0, 20 * (1 - value)),
            child: child,
          ),
        );
      },
      child: Container(
        margin: EdgeInsets.only(bottom: 16.h),
        decoration: BoxDecoration(
          color: AppColors.inputColor,
          borderRadius: BorderRadius.circular(16.r),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            borderRadius: BorderRadius.circular(16.r),
            onTap: () {
              // Navigate to order details if needed
            },
            child: Padding(
              padding: EdgeInsets.all(16.r),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Header: Order number, date, and status
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Buyurtma #${order.id}',
                            style: AppStyle.font800(
                              AppColors.white,
                            ).copyWith(fontSize: 18.sp),
                          ),
                          SizedBox(height: 4.h),
                          Text(
                            _formatDate(order.regDate),
                            style: AppStyle.font400(AppColors.grey),
                          ),
                        ],
                      ),
                      Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 12.w,
                          vertical: 6.h,
                        ),
                        decoration: BoxDecoration(
                          color: _getStatusColor(
                            order.isActive,
                          ).withOpacity(0.2),
                          borderRadius: BorderRadius.circular(20.r),
                          border: Border.all(
                            color: _getStatusColor(order.isActive),
                            width: 1.5,
                          ),
                        ),
                        child: Text(
                          _getStatusText(order.isActive),
                          style: AppStyle.font800(
                            _getStatusColor(order.isActive),
                          ).copyWith(fontSize: 12.sp),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 16.h),

                  // Place info
                  Container(
                    padding: EdgeInsets.all(12.r),
                    decoration: BoxDecoration(
                      color: AppColors.background,
                      borderRadius: BorderRadius.circular(12.r),
                    ),
                    child: Row(
                      children: [
                        Icon(
                          Icons.location_on_outlined,
                          color: AppColors.buttonColor,
                          size: 20.sp,
                        ),
                        SizedBox(width: 8.w),
                        Expanded(
                          child: Text(
                            order.place.name,
                            style: AppStyle.font600(AppColors.white),
                          ),
                        ),
                      ],
                    ),
                  ),

                  SizedBox(height: 12.h),

                  // Items list
                  ...order.items.take(3).map((item) {
                    return Padding(
                      padding: EdgeInsets.only(bottom: 8.h),
                      child: Row(
                        children: [
                          Container(
                            width: 6.w,
                            height: 6.w,
                            decoration: BoxDecoration(
                              color: AppColors.buttonColor,
                              shape: BoxShape.circle,
                            ),
                          ),
                          SizedBox(width: 8.w),
                          Expanded(
                            child: Text(
                              item.food.name,
                              style: AppStyle.font500(AppColors.white),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          Text(
                            '${item.weightType == 'kg' ? item.quantity : item.quantity.toInt()} ${item.weightType == 'kg' ? 'kg' : 'ta'}',
                            style: AppStyle.font400(AppColors.grey),
                          ),
                        ],
                      ),
                    );
                  }).toList(),

                  if (order.items.length > 3)
                    Padding(
                      padding: EdgeInsets.only(left: 14.w, top: 4.h),
                      child: Text(
                        '+ yana ${order.items.length - 3} ta mahsulot',
                        style: AppStyle.font400(
                          AppColors.grey,
                        ).copyWith(fontStyle: FontStyle.italic),
                      ),
                    ),

                  SizedBox(height: 16.h),

                  // Divider
                  Container(height: 1, color: AppColors.background),

                  SizedBox(height: 12.h),

                  // Total price
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Jami:',
                        style: AppStyle.font800(
                          AppColors.white,
                        ).copyWith(fontSize: 16.sp),
                      ),
                      Text(
                        '${order.totalPrice} so\'m',
                        style: AppStyle.font800(
                          AppColors.buttonColor,
                        ).copyWith(fontSize: 18.sp),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
