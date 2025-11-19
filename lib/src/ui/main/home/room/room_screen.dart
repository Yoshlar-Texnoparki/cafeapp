import 'package:cafeapp/src/theme/app_colors.dart';
import 'package:cafeapp/src/theme/app_style.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class RoomScreen extends StatefulWidget {
  const RoomScreen({super.key});

  @override
  State<RoomScreen> createState() => _RoomScreenState();
}

class _RoomScreenState extends State<RoomScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        surfaceTintColor: Colors.transparent,
        shape: OutlineInputBorder(
          borderRadius: BorderRadius.circular(25)
        ),
        foregroundColor: AppColors.white,
        backgroundColor: AppColors.inputColor,
        title: Text("Stollar"),
      ),
      backgroundColor: AppColors.background,
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: GridView.builder(
            itemCount: 8 + 1,
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              crossAxisSpacing: 12.w,
              mainAxisSpacing: 12.h,
              childAspectRatio: 0.85,
            ),
            itemBuilder: (context, index) {
              return GestureDetector(
                onTap: (){
                },
                child: Container(
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
                ),
              );
            },
          ),
      ),
    );
  }
}
