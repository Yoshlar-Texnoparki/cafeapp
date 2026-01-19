import 'package:cafeapp/src/bloc/account/account_bloc.dart';
import 'package:cafeapp/src/dialog/center_dialog.dart';
import 'package:cafeapp/src/model/account/account_model.dart';
import 'package:cafeapp/src/theme/app_colors.dart';
import 'package:cafeapp/src/theme/app_style.dart';
import 'package:cafeapp/src/ui/auth/login_screen.dart';
import 'package:cafeapp/src/utils/cache.dart';
import 'package:cafeapp/src/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  void initState() {
    accountBloc.getAccount();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text(
          "Profil",
          style: AppStyle.font800(AppColors.white).copyWith(fontSize: 20.sp),
        ),
        backgroundColor: AppColors.inputColor,
        elevation: 0,
        centerTitle: true,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(25.r),
            bottomRight: Radius.circular(25.r),
          ),
        ),
      ),
      body: StreamBuilder<AccountModel>(
        stream: accountBloc.getAccountStream,
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }
          final data = snapshot.data!;
          return SingleChildScrollView(
            padding: EdgeInsets.all(20.w),
            child: Column(
              children: [
                // Profile Header Card
                Container(
                  padding: EdgeInsets.all(20.w),
                  decoration: BoxDecoration(
                    color: AppColors.inputColor,
                    borderRadius: BorderRadius.circular(25.r),
                    border: Border.all(
                      color: AppColors.buttonColor.withOpacity(0.3),
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.2),
                        blurRadius: 15,
                        offset: const Offset(0, 8),
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      CircleAvatar(
                        radius: 40.r,
                        backgroundColor: AppColors.buttonColor,
                        child: Text(
                          "${data.firstName.isNotEmpty ? data.firstName[0] : ""}${data.lastName.isNotEmpty ? data.lastName[0] : ""}",
                          style: AppStyle.font800(
                            AppColors.black,
                          ).copyWith(fontSize: 22.sp),
                          textAlign: TextAlign.center,
                        ),
                      ),
                      SizedBox(height: 16.h),
                      Text(
                        "${data.firstName} ${data.lastName}",
                        style: AppStyle.font800(
                          AppColors.white,
                        ).copyWith(fontSize: 22.sp),
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(height: 8.h),
                      Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 12.w,
                          vertical: 4.h,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.buttonColor.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(12.r),
                        ),
                        child: Text(
                          data.role.toUpperCase(),
                          style: AppStyle.font600(
                            AppColors.buttonColor,
                          ).copyWith(fontSize: 12.sp),
                        ),
                      ),
                      SizedBox(height: 16.h),
                      const Divider(color: Colors.grey),
                      SizedBox(height: 16.h),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          _buildSummaryItem(
                            label: "Status",
                            value: data.isActive ? "Aktiv" : "Nofaol",
                            color: data.isActive ? AppColors.green : Colors.red,
                          ),
                          _buildSummaryItem(
                            label: "Kompaniya",
                            value: data.company,
                            color: AppColors.white,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 24.h),

                // Earnings Card
                Container(
                  width: double.infinity,
                  padding: EdgeInsets.all(20.w),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        AppColors.buttonColor,
                        AppColors.buttonColor.withOpacity(0.8),
                      ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(25.r),
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.buttonColor.withOpacity(0.3),
                        blurRadius: 12,
                        offset: const Offset(0, 6),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Ofitsiant balansi",
                        style: AppStyle.font600(
                          AppColors.black,
                        ).copyWith(fontSize: 14.sp),
                      ),
                      SizedBox(height: 8.h),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            Utils.formatNumber(data.waiterSumma),
                            style: AppStyle.font800(
                              AppColors.black,
                            ).copyWith(fontSize: 28.sp),
                          ),
                          Text(
                            data.waiterSummaType,
                            style: AppStyle.font800(
                              AppColors.black,
                            ).copyWith(fontSize: 16.sp),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 24.h),

                // Details List
                _buildInfoCard(
                  title: "Shaxsiy ma'lumotlar",
                  items: [
                    _buildInfoItem(
                      Icons.person_outline,
                      "Foydalanuvchi nomi",
                      data.username,
                    ),
                    _buildInfoItem(Icons.phone_outlined, "Telefon", data.phone),
                    _buildInfoItem(Icons.badge_outlined, "ID", "${data.id}"),
                  ],
                ),

                SizedBox(height: 32.h),

                // Logout Button
                SizedBox(
                  width: double.infinity,
                  height: 56.h,
                  child: OutlinedButton(
                    onPressed: () {
                      CenterDialog.showLogoutDialog(
                          context, () async {
                        await CacheService.clear();
                        if (context.mounted) {
                          Navigator.pushAndRemoveUntil(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const LoginScreen(),
                            ),
                            (route) => false,
                          );
                        }
                      });
                    },
                    style: OutlinedButton.styleFrom(
                      side: const BorderSide(color: Colors.redAccent),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16.r),
                      ),
                    ),
                    child: Text(
                      "Chiqish",
                      style: AppStyle.font600(
                        Colors.redAccent,
                      ).copyWith(fontSize: 16.sp),
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildSummaryItem({
    required String label,
    required String value,
    required Color color,
  }) {
    return Column(
      children: [
        Text(
          label,
          style: AppStyle.font400(AppColors.grey).copyWith(fontSize: 12.sp),
        ),
        SizedBox(height: 4.h),
        Text(value, style: AppStyle.font800(color).copyWith(fontSize: 14.sp)),
      ],
    );
  }

  Widget _buildInfoCard({required String title, required List<Widget> items}) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(20.w),
      decoration: BoxDecoration(
        color: AppColors.inputColor,
        borderRadius: BorderRadius.circular(25.r),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: AppStyle.font800(AppColors.white).copyWith(fontSize: 16.sp),
          ),
          SizedBox(height: 16.h),
          ...items,
        ],
      ),
    );
  }

  Widget _buildInfoItem(IconData icon, String label, String value) {
    return Padding(
      padding: EdgeInsets.only(bottom: 16.h),
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.all(8.w),
            decoration: BoxDecoration(
              color: AppColors.background,
              borderRadius: BorderRadius.circular(10.r),
            ),
            child: Icon(icon, color: AppColors.buttonColor, size: 20.sp),
          ),
          SizedBox(width: 16.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: AppStyle.font400(
                    AppColors.grey,
                  ).copyWith(fontSize: 12.sp),
                ),
                Text(
                  value,
                  style: AppStyle.font600(
                    AppColors.white,
                  ).copyWith(fontSize: 14.sp),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
