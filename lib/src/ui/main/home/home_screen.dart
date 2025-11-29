import 'package:cafeapp/src/bloc/account/account_bloc.dart';
import 'package:cafeapp/src/bloc/hall/hall_category_bloc.dart';
import 'package:cafeapp/src/dialog/bottom_dialog.dart';
import 'package:cafeapp/src/theme/app_colors.dart';
import 'package:cafeapp/src/theme/app_style.dart';
import 'package:cafeapp/src/ui/food/foods_screen.dart';
import 'package:cafeapp/src/ui/main/home/room/room_screen.dart';
import 'package:cafeapp/src/widget/button_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with TickerProviderStateMixin{
  TabController? _tabController;

  @override
  void initState() {
    accountBloc.getAccount();
    _tabController = TabController(length: 3, vsync: this);
    super.initState();
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
                  if(asyncSnapshot.hasData){
                    var data = asyncSnapshot.data!;
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(data.firstName,style: AppStyle.font600(AppColors.white),),
                        Text(data.role,style: AppStyle.font400(AppColors.white),),
                      ],
                    );
                  }else{
                    return SizedBox();
                  }
                }
            ),
            Container(
                padding: EdgeInsets.all(10),
                decoration: BoxDecoration(
                    color: AppColors.background,
                    borderRadius: BorderRadius.circular(20)
                ),
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
              padding:  EdgeInsets.only(left: 8.sp,right: 8.sp,top: 94.sp),
              child: TabBarView(
                  controller: _tabController,
                  children: [
                    GridView.builder(
                      itemCount: 8,
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 3,
                        crossAxisSpacing: 12.w,
                        mainAxisSpacing: 12.h,
                        childAspectRatio: 0.85,
                      ),
                      itemBuilder: (context, index) {
                        return GestureDetector(
                          onTap: (){
                            BottomDialog.showBottomOrderDialog(context);
                          },
                          child: Container(
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(15),
                              color: AppColors.inputColor,
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                SizedBox(
                                  height: 70,
                                  width: double.infinity,
                                  child: Image.asset("assets/images/chair.png",color: AppColors.grey,),
                                ),
                                SizedBox(height: 8.sp,),
                                Center(
                                  child: Text("Zal ${index + 1}",
                                      style: AppStyle.font600(AppColors.white)),
                                ),
                                Spacer(),
                                Container(
                                  decoration: BoxDecoration(
                                      color: AppColors.background,
                                      borderRadius: BorderRadius.only(
                                          bottomLeft: Radius.circular(5),
                                          topRight: Radius.circular(10)
                                      )
                                  ),
                                  margin: EdgeInsets.only(top: 8.sp),
                                  padding: EdgeInsets.all(7.sp),
                                  child: Text(
                                    "56 000 so'm",
                                    style: AppStyle.font400Bold(AppColors.green),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                    GridView.builder(
                      itemCount: 8,
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 3,
                        crossAxisSpacing: 12.w,
                        mainAxisSpacing: 12.h,
                        childAspectRatio: 0.85,
                      ),
                      itemBuilder: (context, index) {
                        return GestureDetector(
                          onTap: (){
                            BottomDialog.showBottomOrderDialog(context);
                          },
                          child: Container(
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(15),
                              color: AppColors.inputColor,
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                SizedBox(
                                  height: 70,
                                  width: double.infinity,
                                  child: Image.asset("assets/images/room.png",color: AppColors.grey,),
                                ),
                                SizedBox(height: 8.sp,),
                                Center(
                                  child: Text("Zal ${index + 1}",
                                      style: AppStyle.font600(AppColors.white)),
                                ),
                                Spacer(),
                                Container(
                                  decoration: BoxDecoration(
                                      color: AppColors.background,
                                      borderRadius: BorderRadius.only(
                                          bottomLeft: Radius.circular(5),
                                          topRight: Radius.circular(10)
                                      )
                                  ),
                                  margin: EdgeInsets.only(top: 8.sp),
                                  padding: EdgeInsets.all(7.sp),
                                  child: Text(
                                    "56 000 so'm",
                                    style: AppStyle.font400Bold(AppColors.green),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                    GridView.builder(
                      itemCount: 8,
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 3,
                        crossAxisSpacing: 12.w,
                        mainAxisSpacing: 12.h,
                        childAspectRatio: 0.85,
                      ),
                      itemBuilder: (context, index) {
                        return GestureDetector(
                          onTap: (){
                            BottomDialog.showBottomOrderDialog(context);
                          },
                          child: Container(
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(15),
                              color: AppColors.inputColor,
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                SizedBox(
                                  height: 70,
                                  width: double.infinity,
                                  child: Image.asset("assets/images/chair.png",color: AppColors.grey,),
                                ),
                                SizedBox(height: 8.sp,),
                                Center(
                                  child: Text("Zal ${index + 1}",
                                      style: AppStyle.font600(AppColors.white)),
                                ),
                                Spacer(),
                                Container(
                                  decoration: BoxDecoration(
                                      color: AppColors.background,
                                      borderRadius: BorderRadius.only(
                                          bottomLeft: Radius.circular(5),
                                          topRight: Radius.circular(10)
                                      )
                                  ),
                                  margin: EdgeInsets.only(top: 8.sp),
                                  padding: EdgeInsets.all(7.sp),
                                  child: Text(
                                    "56 000 so'm",
                                    style: AppStyle.font400Bold(AppColors.green),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ]),
            ),
          ),
          ButtonWidget(text: "Yangi buyurtma", textColor: AppColors.white, backgroundColor: AppColors.buttonColor, onTap: (){})
        ],
      ),

      floatingActionButtonLocation: FloatingActionButtonLocation.centerTop,
      floatingActionButton: Container(
        padding: EdgeInsets.symmetric(vertical: 4, horizontal: 4),
        height: 60.spMin,
        decoration: BoxDecoration(
            border: Border.all(color: AppColors.grey.withOpacity(0.3)),
            borderRadius: BorderRadius.circular(25),
            color: AppColors.inputColor),
        margin: EdgeInsets.only(left: 16.sp,right: 16.sp,top: 84.sp),
        child: StreamBuilder(
            stream: hallCategoryBloc.getHallCategoryStream,
            builder: (context, asyncSnapshot) {
              if(asyncSnapshot.hasData){
                var data = asyncSnapshot.data!;
                return TabBar.secondary(
                    isScrollable: true,
                    tabAlignment: TabAlignment.start,
                    labelPadding: EdgeInsets.symmetric(vertical: 16.sp,horizontal: 42),
                    indicatorSize: TabBarIndicatorSize.tab,
                    indicator: BoxDecoration(
                      color: AppColors.buttonColor,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    dividerColor: Colors.transparent,
                    unselectedLabelColor: AppColors.grey,
                    controller: _tabController,
                    tabs: data.map((halls){
                      return Text(halls.name);
                    }).toList()
                );
              }else{
                hallCategoryBloc.getHallCategory();
                return CircularProgressIndicator.adaptive(backgroundColor: AppColors.buttonColor,);
              }
            }
        ),
      ),
    ));
  }
}
