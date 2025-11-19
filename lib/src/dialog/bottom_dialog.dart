import 'package:cafeapp/src/theme/app_colors.dart';
import 'package:cafeapp/src/theme/app_style.dart';
import 'package:cafeapp/src/widget/button_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class BottomDialog{
  static showBottomOrderDialog(BuildContext context){
    return showModalBottomSheet(context: context, builder: (builder){
      return Container(
        height: 200.sp,
        decoration: BoxDecoration(
          color: AppColors.background,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20))
        ),
        child: Column(
          children: [
            SizedBox(height: 18.sp,),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Container(
                  width: 100.sp,
                  height: 70.sp,
                  padding: EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15),
                    color: AppColors.inputColor
                  ),
                  child:Column(
                    children: [
                      Icon(Icons.edit,color: AppColors.green,),
                      Text("Tahrilash",style: AppStyle.font400Bold(AppColors.white),)
                    ],
                  ),
                ),
                Container(
                  height: 70.sp,
                  width: 100.sp,
                  padding: EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15),
                    color: AppColors.inputColor
                  ),
                  child:Column(
                    children: [
                      Icon(Icons.cancel,color: AppColors.red,),
                      Text("Bekor qilish",style: AppStyle.font400Bold(AppColors.white),)
                    ],
                  ),
                ),
                Container(
                  height: 70.sp,
                  width: 100.sp,
                  padding: EdgeInsets.all(16),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15),
                      color: AppColors.inputColor
                  ),
                  child:Column(
                    children: [
                      Icon(Icons.receipt,color: AppColors.buttonColor,),
                      Text("Chek",style: AppStyle.font400Bold(AppColors.white),)
                    ],
                  ),
                ),

              ],
            ),
            Spacer(),
            ButtonWidget(text: "Yopish", textColor: AppColors.white, backgroundColor: AppColors.buttonColor, onTap: (){
              Navigator.pop(context);
            })
          ],
        ),
      );
    });
  }
}