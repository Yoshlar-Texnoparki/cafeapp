import 'dart:async';
import 'dart:convert';
import 'package:cafeapp/src/bloc/account/account_bloc.dart';
import 'package:cafeapp/src/bloc/hall/hall_category_bloc.dart';
import 'package:cafeapp/src/theme/app_colors.dart';
import 'package:cafeapp/src/theme/app_style.dart';
import 'package:cafeapp/src/ui/main/order/order_screen.dart';
import 'package:cafeapp/src/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:web_socket_channel/io.dart';
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with TickerProviderStateMixin {
  TabController? _tabController;
  IOWebSocketChannel? _channel;

  @override
  void initState() {
    super.initState();
    accountBloc.getAccount();
    _tabController = TabController(length: 3, vsync: this);
    hallCategoryAndPlaceBloc.getHallCategoryAndPlace();
    _initWebSocket();
  }

  Future<void> _initWebSocket() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    String token = preferences.getString("token") ?? "";

    final wsUrl = 'wss://cafe.geeks-soft.uz/ws/api/places?token=$token';

    _channel = IOWebSocketChannel.connect(
      Uri.parse(wsUrl),
      headers: {
        'Origin': 'https://cafe.geeks-soft.uz',
      },
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

  void _reconnect() {
    Future.delayed(const Duration(seconds: 5), () {
      if (mounted) _initWebSocket();
    });
  }

  @override
  void dispose() {
    _channel?.sink.close();
    _tabController?.dispose();
    super.dispose();
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
                          Text(data.firstName, style: AppStyle.font600(AppColors.white)),
                          Text(data.role, style: AppStyle.font400(AppColors.white)),
                        ],
                      );
                    } else {
                      return const SizedBox();
                    }
                  }),
              Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                      color: AppColors.background,
                      borderRadius: BorderRadius.circular(20)),
                  child: Text("1 560 000 so'm", style: AppStyle.font800(AppColors.green))),
            ],
          ),
          shape: OutlineInputBorder(
            borderRadius: BorderRadius.circular(20),
          ),
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
                      if (_tabController?.length != categories.hallCategoryModel.length) {
                        _tabController = TabController(
                            length: categories.hallCategoryModel.length, vsync: this);
                      }

                      return TabBarView(
                        controller: _tabController,
                        children: List.generate(
                          categories.hallCategoryModel.length,
                              (tabIndex) {
                            final currentCategory = categories.hallCategoryModel[tabIndex];
                            final filteredPlaces = categories.placeModel.where((place) {
                              return place.hallId == currentCategory.id;
                            }).toList();

                            return GridView.builder(
                              itemCount: filteredPlaces.length,
                              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 3,
                                crossAxisSpacing: 12.w,
                                mainAxisSpacing: 12.h,
                                childAspectRatio: 0.85,
                              ),
                              itemBuilder: (context, index) {
                                return GestureDetector(
                                  onTap: () {
                                    Navigator.push(context, MaterialPageRoute(builder: (builder) {
                                      return OrderScreen(data: filteredPlaces[index]);
                                    }));
                                  },
                                  child: Container(
                                    alignment: Alignment.center,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(15),
                                      color: filteredPlaces[index].lastOrder.isActive?Colors.redAccent.withOpacity(0.4):AppColors.green.withOpacity(0.4),
                                    ),
                                    child: Column(
                                      children: [
                                        Container(
                                            alignment: Alignment.center,
                                            height: 70,
                                            child: Image.asset("assets/images/room.png",
                                                color: AppColors.grey)),
                                        Center(
                                          child: Text(
                                            filteredPlaces[index].name,
                                            style: AppStyle.font800(AppColors.white),
                                          ),
                                        ),
                                        const Spacer(),
                                        filteredPlaces[index].lastOrder.totalSumma == 0
                                            ? const SizedBox()
                                            : Container(
                                          decoration: BoxDecoration(
                                            color: AppColors.background,
                                            borderRadius: BorderRadius.only(
                                              topLeft: Radius.circular(10),
                                              topRight: Radius.circular(10),
                                            ),
                                          ),
                                          margin: EdgeInsets.only(top: 8.h),
                                          padding: EdgeInsets.all(7.w),
                                          child: Text(
                                            Utils.formatNumber(filteredPlaces[index].lastOrder.totalSumma),
                                            style: AppStyle.font800(AppColors.buttonColor),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              },
                            );
                          },
                        ),
                      );
                    } else {
                      return Center(
                          child: CircularProgressIndicator.adaptive(
                              backgroundColor: AppColors.buttonColor));
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
              color: AppColors.inputColor),
          margin: EdgeInsets.only(left: 16.w, right: 16.h, top: 84.h),
          child: StreamBuilder(
              stream: hallCategoryAndPlaceBloc.getHallCategoryStream,
              builder: (context, asyncSnapshot) {
                if (asyncSnapshot.hasData) {
                  var data = asyncSnapshot.data!;
                  return TabBar.secondary(
                      isScrollable: true,
                      tabAlignment: TabAlignment.start,
                      labelPadding: EdgeInsets.symmetric(vertical: 16.h, horizontal: 42),
                      indicatorSize: TabBarIndicatorSize.tab,
                      indicator: BoxDecoration(
                        color: AppColors.buttonColor,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      dividerColor: Colors.transparent,
                      unselectedLabelColor: AppColors.grey,
                      controller: _tabController,
                      tabs: data.hallCategoryModel.map((halls) {
                        return Text(halls.name);
                      }).toList());
                } else {
                  return const Center(child: CircularProgressIndicator.adaptive());
                }
              }),
        ),
      ),
    );
  }
}