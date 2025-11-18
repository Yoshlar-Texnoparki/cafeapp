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
  bool isLoad = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 12.0.sp),
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    SizedBox(height: 106.sp,),
                    Center(
                      child: Container(
                        width: 120.sp,
                        height: 120.sp,
                        decoration: BoxDecoration(
                            color: AppColors.inputColor,
                            borderRadius: BorderRadius.circular(10)
                        ),
                      ),
                    ),
                    SizedBox(height: 16.sp,),
                    Text("Kitchen",style: AppStyle.font800(AppColors.white),),
                    SizedBox(height: 106.sp,),
                    TextField(
                      style: AppStyle.font500(AppColors.white),
                      controller: controllerUsername,
                      decoration: InputDecoration(
                          prefixIcon: Icon(Icons.person,color: AppColors.buttonColor,),
                          hintText: "Foydalanuvchi nomi",
                          hintStyle: TextStyle(color: AppColors.grey),
                          filled: true,
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(20)
                          ),
                          fillColor: AppColors.inputColor
                      ),
                    ),
                    SizedBox(height: 16.sp,),
                    TextField(
                      style: AppStyle.font500(AppColors.white),
                      keyboardType: TextInputType.number,
                      controller: controllerPassword,
                      decoration: InputDecoration(
                          prefixIcon: Icon(Icons.call,color: AppColors.buttonColor,),
                          hintText: "Telefon raqami",
                          hintStyle: TextStyle(color: AppColors.grey),
                          filled: true,
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(20.r)
                          ),
                          fillColor: AppColors.inputColor
                      ),
                    ),
                    SizedBox(height: 34.sp,),
                  ],
                ),
              ),
            ),
            ButtonWidget(text: "Kirish", textColor: AppColors.white, backgroundColor: AppColors.buttonColor, onTap: ()async{
              if(isCheckController()){
                CenterDialog.showLoadingDialog(context);
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
            }),
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
