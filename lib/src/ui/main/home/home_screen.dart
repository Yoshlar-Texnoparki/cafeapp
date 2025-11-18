import 'package:cafeapp/src/theme/app_colors.dart';
import 'package:cafeapp/src/theme/app_style.dart';
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
    _tabController = TabController(length: 2, vsync: this);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        backgroundColor: AppColors.inputColor,
        title: Text("1 560 000 so'm", style: AppStyle.font800(AppColors.white)),
        shape: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20),
        ),
      ),

      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: GridView.builder(
          itemCount: 8 + 1, // <<<<<<<< BU YERGA +1 QO‘SHILDI
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
            crossAxisSpacing: 12.w,
            mainAxisSpacing: 12.h,
            childAspectRatio: 0.85,
          ),
          itemBuilder: (context, index) {
            if (index == 8) {
              return GestureDetector(
                onTap: () {
                },
                child: Container(
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15),
                    color: AppColors.inputColor.withOpacity(0.8),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.add_circle, size: 36, color: AppColors.buttonColor),
                      SizedBox(height: 8),
                      Text(
                        "Buyurtma qo‘shish",
                        style: AppStyle.font600(AppColors.white),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
              );
            }
            /// -----------------------------------------------------

            return Container(
              alignment: Alignment.center,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15),
                color: AppColors.inputColor,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("Stol${index + 1}",
                      style: AppStyle.font600(AppColors.white)),
                  Container(
                    margin: EdgeInsets.only(top: 12.sp),
                    padding: EdgeInsets.all(4),
                    child: Text(
                      "560 000 so'm",
                      style: AppStyle.font400Bold(AppColors.green),
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),

      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: Container(
        padding: EdgeInsets.symmetric(vertical: 4, horizontal: 4),
        height: 60.spMin,
        decoration: BoxDecoration(
            border: Border.all(color: AppColors.grey.withOpacity(0.3)),
            borderRadius: BorderRadius.circular(25),
            color: AppColors.inputColor),
        margin: EdgeInsets.symmetric(horizontal: 26.sp),
        child: TabBar(
          indicatorSize: TabBarIndicatorSize.tab,
          indicator: BoxDecoration(
            color: AppColors.buttonColor,
            borderRadius: BorderRadius.circular(25),
          ),
          dividerColor: Colors.transparent,
          unselectedLabelColor: AppColors.grey,
          controller: _tabController,
          tabs: const [
            Text("Aktiv Joylar"),
            Text("Bo‘sh Joylar"),
          ],
        ),
      ),
    );
  }
}
