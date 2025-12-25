import 'package:cafeapp/src/theme/app_colors.dart';
import 'package:cafeapp/src/theme/app_style.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';


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
        foregroundColor: AppColors.white,
        title: Text("3 Stol"),
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
          ListView.builder(itemCount: 10,itemBuilder: (itemBuilder,index){
            return Container(
              padding: EdgeInsets.all(4.r),
              width:1.sw,
              margin: EdgeInsets.symmetric(horizontal: 16,vertical: 8),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: AppColors.inputColor
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 70.r,
                    height: 70.r,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: AppColors.inputColor
                    ),
                    child: Icon(Icons.fastfood_sharp,size: 34,color: AppColors.grey,),
                  ),
                  Expanded(child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Uygur lagmon",style: AppStyle.font800(AppColors.white),),
                      SizedBox(height: 8,),
                      Text("89 000 000 so'm",style: AppStyle.font800(AppColors.buttonColor),),
                    ],
                  ))
                ],
              ),
            );
          }),
          Text("data"),
          Text("data"),
          Text("data"),
        ],
      ),
    );
  }
}
