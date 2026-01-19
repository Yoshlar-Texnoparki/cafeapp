// import 'dart:async';
// import 'dart:convert';
import 'package:cafeapp/src/bloc/account/account_bloc.dart';
import 'package:cafeapp/src/bloc/hall/hall_category_bloc.dart';
import 'package:cafeapp/src/model/place/place_model.dart';
import 'package:cafeapp/src/theme/app_colors.dart';
import 'package:cafeapp/src/theme/app_style.dart';
import 'package:cafeapp/src/ui/main/order/order_screen.dart';
import 'package:cafeapp/src/utils/cache.dart';
import 'package:cafeapp/src/utils/utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shimmer/shimmer.dart';
// import 'package:shared_preferences/shared_preferences.dart';

// import 'package:web_socket_channel/io.dart';
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with TickerProviderStateMixin {
  TabController? _tabController;
  bool _showOnlyMyTables = false;

  @override
  void initState() {
    super.initState();
    accountBloc.getAccount();
    _tabController = TabController(length: 3, vsync: this);
    hallCategoryAndPlaceBloc.getHallCategoryAndPlace();
    // _initWebSocket();
  }

  /*
  Future<void> _initWebSocket() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    String token = preferences.getString("token") ?? "";

    final wsUrl = 'wss://cafe.geeks-soft.uz/ws/api/places?token=$token';

    _channel = IOWebSocketChannel.connect(
      Uri.parse(wsUrl),
      headers: {'Origin': 'https://cafe.geeks-soft.uz'},
      pingInterval: const Duration(seconds: 20),
    );

    _channel!.stream.listen(
      (message) {
        print("Soketdan xabar keldi: $message");
        try {
          final data = jsonDecode(message);
          if (data['event'] == "order_added" || data['event'] == "order_paid") {
            print("Ma'lumotlar yangilanmoqda...");
            hallCategoryAndPlaceBloc.getHallCategoryAndPlace();
          }
        } catch (e) {
          print("JSON xatosi: $e");
        }
      },
      onError: (error) {
        print("Soket xatosi: $error");
        _reconnect();
      },
      onDone: () {
        print("Soket yopildi");
        _reconnect();
      },
    );
  }
*/

  /*
  void _reconnect() {
    Future.delayed(const Duration(seconds: 5), () {
      if (mounted) _initWebSocket();
    });
  }
*/

  @override
  void dispose() {
    // _channel?.sink.close();
    _tabController?.dispose();
    super.dispose();
  }

  Color _getCardColor(PlaceModel place) {
    if (place.lastOrder.isActive &&
        place.lastOrder.waiterId == CacheService.getUserId()) {
      return AppColors.buttonColor.withOpacity(0.08);
    } else if (place.lastOrder.isActive &&
        place.lastOrder.waiterId != CacheService.getUserId()) {
      return Colors.redAccent.withOpacity(0.08);
    } else {
      return AppColors.green.withOpacity(0.08);
    }
  }

  Color _getBorderColor(PlaceModel place) {
    if (place.lastOrder.isActive &&
        place.lastOrder.waiterId == CacheService.getUserId()) {
      return AppColors.buttonColor;
    } else if (place.lastOrder.isActive &&
        place.lastOrder.waiterId != CacheService.getUserId()) {
      return Colors.redAccent;
    } else {
      return AppColors.green;
    }
  }

  IconData _getStatusIcon(PlaceModel place) {
    if (place.lastOrder.isActive) {
      return Icons.person;
    } else {
      return Icons.check_circle_outline;
    }
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        backgroundColor: AppColors.background,
        appBar: AppBar(
          surfaceTintColor: Colors.transparent,
          elevation: 0,
          backgroundColor: AppColors.inputColor,
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              StreamBuilder(
                stream: accountBloc.getAccountStream,
                builder: (context, asyncSnapshot) {
                  if (asyncSnapshot.hasData) {
                    var data = asyncSnapshot.data!;
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Text(
                              data.firstName,
                              style: AppStyle.font600(
                                AppColors.white,
                              ).copyWith(fontSize: 18.sp),
                            ),
                            SizedBox(width: 6.w),
                            Icon(
                              Icons.check_circle,
                              color: AppColors.green,
                              size: 18.sp,
                            ),
                          ],
                        ),
                        SizedBox(height: 2.h),
                        Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: 8.w,
                            vertical: 2.h,
                          ),
                          decoration: BoxDecoration(
                            color: AppColors.buttonColor.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(12.r),
                          ),
                          child: Text(
                            data.role == 'waiter' ? "Offisant" : data.role,
                            style: AppStyle.font400(
                              AppColors.buttonColor,
                            ).copyWith(fontSize: 10.sp),
                          ),
                        ),
                      ],
                    );
                  } else {
                    return Shimmer.fromColors(
                      baseColor: AppColors.inputColor,
                      highlightColor: AppColors.grey.withOpacity(0.3),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            width: 100.w,
                            height: 18.h,
                            decoration: BoxDecoration(
                              color: AppColors.white,
                              borderRadius: BorderRadius.circular(4.r),
                            ),
                          ),
                          SizedBox(height: 4.h),
                          Container(
                            width: 60.w,
                            height: 12.h,
                            decoration: BoxDecoration(
                              color: AppColors.white,
                              borderRadius: BorderRadius.circular(4.r),
                            ),
                          ),
                        ],
                      ),
                    );
                  }
                },
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 0.w, vertical: 6.h),
                decoration: BoxDecoration(
                  color: AppColors.background,
                  borderRadius: BorderRadius.circular(20.r),
                  border: Border.all(
                    color: _showOnlyMyTables
                        ? AppColors.buttonColor
                        : AppColors.grey.withOpacity(0.3),
                    width: 1.5,
                  ),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    SizedBox(width: 8.w),
                    Text(
                      "Zakazlarim",
                      style: AppStyle.font400(
                        _showOnlyMyTables
                            ? AppColors.buttonColor
                            : AppColors.grey,
                      ).copyWith(fontSize: 12.sp),
                    ),
                    SizedBox(
                      height: 24.h,
                      child: CupertinoSwitch(
                        value: _showOnlyMyTables,
                        activeColor: AppColors.buttonColor,
                        onChanged: (value) {
                          setState(() {
                            _showOnlyMyTables = value;
                          });
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          shape: OutlineInputBorder(borderRadius: BorderRadius.circular(20)),
        ),
        body: Column(
          children: [
            Expanded(
              child: Padding(
                padding: EdgeInsets.only(left: 8.sp, right: 8.sp, top: 94.sp),
                child: StreamBuilder(
                  stream: hallCategoryAndPlaceBloc.getHallCategoryStream,
                  builder: (context, asyncSnapshot) {
                    if (asyncSnapshot.hasData) {
                      var categories = asyncSnapshot.data!;
                      if (_tabController?.length !=
                          categories.hallCategoryModel.length) {
                        _tabController = TabController(
                          length: categories.hallCategoryModel.length,
                          vsync: this,
                        );
                      }

                      if (_showOnlyMyTables) {
                        final allMyPlaces = categories.placeModel.where((
                          place,
                        ) {
                          return place.lastOrder.waiterId ==
                              CacheService.getUserId();
                        }).toList();

                        return Padding(
                          padding: EdgeInsets.symmetric(horizontal: 4.w),
                          child: GridView.builder(
                            itemCount: allMyPlaces.length,
                            gridDelegate:
                                SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 3,
                                  crossAxisSpacing: 12.w,
                                  mainAxisSpacing: 12.h,
                                  childAspectRatio: 0.85,
                                ),
                            itemBuilder: (context, index) {
                              return _buildTableCard(allMyPlaces[index], index);
                            },
                          ),
                        );
                      }

                      return TabBarView(
                        controller: _tabController,
                        children: List.generate(
                          categories.hallCategoryModel.length,
                          (tabIndex) {
                            final currentCategory =
                                categories.hallCategoryModel[tabIndex];
                            final filteredPlaces = categories.placeModel.where((
                              place,
                            ) {
                              return place.hallId == currentCategory.id;
                            }).toList();

                            return Padding(
                              padding: EdgeInsets.symmetric(horizontal: 4.w),
                              child: GridView.builder(
                                itemCount: filteredPlaces.length,
                                gridDelegate:
                                    SliverGridDelegateWithFixedCrossAxisCount(
                                      crossAxisCount: 3,
                                      crossAxisSpacing: 12.w,
                                      mainAxisSpacing: 12.h,
                                      childAspectRatio: 0.85,
                                    ),
                                itemBuilder: (context, index) {
                                  return _buildTableCard(
                                    filteredPlaces[index],
                                    index,
                                  );
                                },
                              ),
                            );
                          },
                        ),
                      );
                    } else {
                      return _buildShimmerGrid();
                    }
                  },
                ),
              ),
            ),
          ],
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerTop,
        floatingActionButton: Container(
          padding: EdgeInsets.symmetric(vertical: 4.h, horizontal: 4.w),
          height: 60.h,
          decoration: BoxDecoration(
            border: Border.all(color: AppColors.grey.withOpacity(0.3)),
            borderRadius: BorderRadius.circular(25),
            color: AppColors.inputColor,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.2),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          margin: EdgeInsets.only(left: 16.w, right: 16.h, top: 84.h),
          child: StreamBuilder(
            stream: hallCategoryAndPlaceBloc.getHallCategoryStream,
            builder: (context, asyncSnapshot) {
              if (asyncSnapshot.hasData) {
                var data = asyncSnapshot.data!;
                if (_showOnlyMyTables) {
                  return Center(
                    child: Text(
                      "Mening zakazlarim",
                      style: AppStyle.font800(
                        AppColors.buttonColor,
                      ).copyWith(fontSize: 14.sp),
                    ),
                  );
                }
                return TabBar.secondary(
                  isScrollable: true,
                  tabAlignment: TabAlignment.start,
                  labelPadding: EdgeInsets.symmetric(
                    vertical: 16.h,
                    horizontal: 42.w,
                  ),
                  labelStyle: AppStyle.font800(
                    AppColors.black,
                  ).copyWith(fontSize: 14.sp),
                  unselectedLabelStyle: AppStyle.font600(
                    AppColors.grey,
                  ).copyWith(fontSize: 14.sp),
                  indicatorSize: TabBarIndicatorSize.tab,
                  indicator: BoxDecoration(
                    color: AppColors.buttonColor,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.buttonColor.withOpacity(0.3),
                        blurRadius: 8,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  dividerColor: Colors.transparent,
                  unselectedLabelColor: AppColors.grey,
                  controller: _tabController,
                  tabs: data.hallCategoryModel.map((halls) {
                    return Text(halls.name);
                  }).toList(),
                );
              } else {
                return _buildShimmerTabBar();
              }
            },
          ),
        ),
      ),
    );
  }

  Widget _buildTableCard(PlaceModel place, int index) {
    return TweenAnimationBuilder<double>(
      duration: Duration(milliseconds: 300 + (index * 50)),
      tween: Tween(begin: 0.0, end: 1.0),
      builder: (context, value, child) {
        return Opacity(
          opacity: value,
          child: Transform.scale(scale: 0.8 + (0.2 * value), child: child),
        );
      },
      child: GestureDetector(
        onTap: () {
          // Agar stol band bo'lsa va boshqa ofitsiantga tegishli bo'lsa, kirish mumkin emas
          if (place.lastOrder.isActive &&
              place.lastOrder.waiterId != CacheService.getUserId()) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(
                  "Bu stol boshqa ofitsiantga tegishli!",
                  style: AppStyle.font600(AppColors.white),
                ),
                backgroundColor: Colors.redAccent,
                behavior: SnackBarBehavior.floating,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12.r),
                ),
                margin: EdgeInsets.all(16.w),
                duration: const Duration(seconds: 2),
              ),
            );
            return;
          }

          // Bo'sh stol yoki o'z stollariga kirish mumkin
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (builder) {
                return OrderScreen(data: place);
              },
            ),
          );
        },
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16.r),
            color: _getCardColor(place),
            border: Border.all(color: _getBorderColor(place), width: 2),
          ),
          child: Column(
            children: [
              // Status indicator
              Container(
                padding: EdgeInsets.symmetric(vertical: 4.h),
                decoration: BoxDecoration(
                  color: _getBorderColor(place).withOpacity(0.2),
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(14.r),
                    topRight: Radius.circular(14.r),
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      _getStatusIcon(place),
                      color: _getBorderColor(place),
                      size: 14.sp,
                    ),
                  ],
                ),
              ),

              // Room icon
              Expanded(
                child: Container(
                  alignment: Alignment.center,
                  padding: EdgeInsets.symmetric(vertical: 8.h),
                  child: Image.asset(
                    "assets/images/room.png",
                    color: _getBorderColor(place),
                    height: 50.h,
                  ),
                ),
              ),

              // Table name
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 8.w),
                child: Text(
                  place.name,
                  style: AppStyle.font800(
                    AppColors.white,
                  ).copyWith(fontSize: 16.sp),
                  textAlign: TextAlign.center,
                ),
              ),

              SizedBox(height: 4.h),

              // Total price
              if (place.lastOrder.totalSumma != 0)
                Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        AppColors.background,
                        AppColors.background.withOpacity(0.8),
                      ],
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                    ),
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(14.r),
                      bottomRight: Radius.circular(14.r),
                    ),
                  ),
                  padding: EdgeInsets.symmetric(vertical: 8.h),
                  child: Text(
                    Utils.formatNumber(place.lastOrder.totalSumma),
                    style: AppStyle.font800(
                      AppColors.buttonColor,
                    ).copyWith(fontSize: 14.sp),
                    textAlign: TextAlign.center,
                  ),
                )
              else
                Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: AppColors.background.withOpacity(0.5),
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(14.r),
                      bottomRight: Radius.circular(14.r),
                    ),
                  ),
                  padding: EdgeInsets.symmetric(vertical: 8.h),
                  child: Text(
                    "Bo'sh",
                    style: AppStyle.font600(
                      AppColors.grey,
                    ).copyWith(fontSize: 12.sp),
                    textAlign: TextAlign.center,
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildShimmerGrid() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 4.w),
      child: GridView.builder(
        itemCount: 12,
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3,
          crossAxisSpacing: 12.w,
          mainAxisSpacing: 12.h,
          childAspectRatio: 0.85,
        ),
        itemBuilder: (context, index) {
          return Shimmer.fromColors(
            baseColor: AppColors.inputColor,
            highlightColor: AppColors.grey.withOpacity(0.3),
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16.r),
                color: AppColors.white,
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildShimmerTabBar() {
    return Shimmer.fromColors(
      baseColor: AppColors.inputColor,
      highlightColor: AppColors.grey.withOpacity(0.3),
      child: Row(
        children: List.generate(
          3,
          (index) => Container(
            margin: EdgeInsets.only(right: 8.w),
            padding: EdgeInsets.symmetric(horizontal: 32.w, vertical: 16.h),
            decoration: BoxDecoration(
              color: AppColors.white,
              borderRadius: BorderRadius.circular(20.r),
            ),
          ),
        ),
      ),
    );
  }
}
