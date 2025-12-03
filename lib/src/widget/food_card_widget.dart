import 'package:cafeapp/src/theme/app_colors.dart';
import 'package:cafeapp/src/theme/app_style.dart';
import 'package:cafeapp/src/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class FoodCardWidget extends StatelessWidget {
  final String name,img;
  final num price;
  const FoodCardWidget({super.key, required this.name, required this.img, required this.price});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        // BottomDialog.showBottomOrderDialog(context);
      },
      child: Container(
        padding: EdgeInsets.all(10.sp),
        margin: EdgeInsets.symmetric(vertical: 8.sp),
        width: MediaQuery.of(context).size.width,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
          color: AppColors.inputColor,
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              margin: EdgeInsets.only(right: 8.sp),
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                color: AppColors.inputColor,
                borderRadius: BorderRadius.circular(15)
              ),
              child: Icon(Icons.fastfood_sharp,color: AppColors.grey,),
            ),Expanded(child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text(name,style: AppStyle.font500(AppColors.white),),
                SizedBox(height: 8.sp,),
                Text("${Utils.formatNumber(price)} so'm",style: AppStyle.font500(AppColors.buttonColor),)
              ],
            ))
          ],
        ),
      ),
    );
  }
}
