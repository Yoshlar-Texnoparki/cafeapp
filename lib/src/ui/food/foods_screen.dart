import 'package:cafeapp/src/theme/app_colors.dart';
import 'package:cafeapp/src/theme/app_style.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../dialog/bottom_dialog.dart';

class FoodsScreen extends StatefulWidget {
  const FoodsScreen({super.key});

  @override
  State<FoodsScreen> createState() => _FoodsScreenState();
}

class _FoodsScreenState extends State<FoodsScreen>
    with TickerProviderStateMixin {
  TabController? _tabController;

  @override
  void initState() {
    _tabController = TabController(length: 4, vsync: this);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Container(
          width: MediaQuery.of(context).size.width,
          height: 40.sp,
          decoration: BoxDecoration(borderRadius: BorderRadius.circular(20)),
          child: Row(
            children: [
              Container(
                width: MediaQuery.of(context).size.width,
                height: 40.sp,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
            ],
          ),
        ),
        automaticallyImplyLeading: false,
        shape: OutlineInputBorder(borderRadius: BorderRadius.circular(20)),
        surfaceTintColor: Colors.transparent,
        backgroundColor: AppColors.inputColor,
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(30.sp),
          child: Padding(
            padding: EdgeInsets.only(left: 8.0.sp, right: 8.sp),
            child: TabBar.secondary(
              padding: EdgeInsets.only(bottom: 10),
              labelColor: AppColors.black,
              indicatorPadding: EdgeInsets.zero,
              tabAlignment: TabAlignment.start,
              overlayColor: MaterialStateProperty.all<Color>(
                Colors.transparent,
              ),
              labelPadding: EdgeInsets.symmetric(
                vertical: 12.sp,
                horizontal: 12.sp,
              ),
              dividerColor: Colors.transparent,
              unselectedLabelColor: AppColors.grey,
              indicatorSize: TabBarIndicatorSize.tab,
              indicator: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                color: AppColors.buttonColor,
              ),
              isScrollable: true,
              controller: _tabController,
              tabs: [
                Text("Milly taomlar"),
                Text("Uygur taomlar"),
                Text("Fast fodlar taomlar"),
                Text("Oshlar"),
              ],
            ),
          ),
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: GridView.builder(
              itemCount: 8,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                crossAxisSpacing: 12.w,
                mainAxisSpacing: 12.h,
                childAspectRatio: 0.85,
              ),
              itemBuilder: (context, index) {
                return GestureDetector(
                  onTap: () {
                    // BottomDialog.showBottomOrderDialog(context);
                  },
                  child: Container(
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15),
                      color: AppColors.inputColor,
                    ),
                    child: Column(
                      children: [
                        Container(
                          width: double.infinity,
                          height: 75.sp,
                          decoration: BoxDecoration(
                            color: AppColors.inputColor,
                            borderRadius: BorderRadius.vertical(
                              bottom: Radius.circular(0),
                              top: Radius.circular(15),
                            ),
                          ),
                          child: Icon(
                            Icons.fastfood_sharp,
                            size: 44,
                            color: AppColors.background,
                          ),
                        ),
                        SizedBox(height: 2.sp),
                        Text(
                          "Polvon shashlik assorti",
                          textAlign: TextAlign.center,
                          style: AppStyle.font400Bold(AppColors.white),
                        ),
                        SizedBox(height: 2.sp),
                        Text(
                          "73 200 so'm",
                          style: AppStyle.font400Bold(AppColors.green),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
          Text("data"),
          Text("data"),
          Text("data"),
        ],
      ),
    );
  }
}
