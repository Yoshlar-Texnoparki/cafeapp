import 'package:cafeapp/src/api/repository.dart';
import 'package:cafeapp/src/model/http_result.dart';
import 'package:cafeapp/src/theme/app_colors.dart';
import 'package:cafeapp/src/theme/app_style.dart';
import 'package:cafeapp/src/utils/cache.dart';
import 'package:cafeapp/src/widget/button_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../dialog/center_dialog.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  TextEditingController controllerUsername = TextEditingController();
  TextEditingController controllerPassword = TextEditingController();
  final Repository _repository = Repository();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 12.0.sp),
        child: Column(
          children: [
            SizedBox(height: 106.sp,),
            Center(
              child: Container(
                width: 120.sp,
                height: 120.sp,
                decoration: BoxDecoration(
                    boxShadow: [
                      BoxShadow(
                          spreadRadius: -8,
                          blurRadius: 10.r,
                          color: Colors.grey
                      )
                    ],
                    color: AppColors.white,
                    borderRadius: BorderRadius.circular(10)
                ),
              ),
            ),
            SizedBox(height: 106.sp,),
            TextField(
              style: AppStyle.font500(AppColors.black),
              controller: controllerUsername,
              decoration: InputDecoration(
                  prefixIcon: Icon(Icons.person),
                  hintText: "Foydalanuvchi nomi",
                  filled: true,
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10)
                  ),
                  fillColor: AppColors.white
              ),
            ),
            SizedBox(height: 16.sp,),
            TextField(
              style: AppStyle.font500(AppColors.black),
              controller: controllerPassword,
              decoration: InputDecoration(
                  prefixIcon: Icon(Icons.call),
                  hintText: "Telefon raqami",
                  filled: true,
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.r)
                  ),
                  fillColor: AppColors.white
              ),
            ),
            Spacer(),
            ButtonWidget(text: "Kirish", textColor: AppColors.white, backgroundColor: Colors.indigo, onTap: ()async{
              if(isCheckController()){
                Map data =
                {
                  "username": controllerUsername.text,
                  "password": controllerPassword.text
                };
                HttpResult res = await _repository.login(data);
                if(res.status>= 200 && res.status <299){
                  CacheService.saveToken(res.result["access_token"]);
                }else{
                  CenterDialog.showCenterDialog(context, res.result);
                }
              }else{
                CenterDialog.showCenterDialog(context, "Iltimos ko'rsatilgan maydonni to'liring");
              }
            })
          ],
        ),
      ),
    );
  }

  bool isCheckController(){
    if(controllerPassword.text.isEmpty&&controllerUsername.text.isEmpty) return false;
    return true;
  }
}
