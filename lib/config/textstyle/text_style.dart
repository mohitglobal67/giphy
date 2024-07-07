import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:giphy_app/config/color/color.dart';

TextStyle h1TextStyle(Color? color) {
  return TextStyle(
      color: color ?? AppColors.blackColor,
      fontWeight: FontWeight.w800,
      fontSize: 26.sp);
}

TextStyle h2TextStyle(Color? color) {
  return TextStyle(
      color: color ?? AppColors.blackColor,
      fontWeight: FontWeight.bold,
      letterSpacing: 1,
      fontSize: 18.sp);
}

TextStyle fieldTextStyle(Color? color) {
  return TextStyle(
      color: color ?? AppColors.blackColor,
      fontWeight: FontWeight.w600,
      fontSize: 12.sp);
}

TextStyle? textRegular(Color? color) {
  return TextStyle(
      color: color ?? AppColors.primarymaincolor,
      fontWeight: FontWeight.w800,
      height: 1.1,
      fontSize: 13.sp);
}

TextStyle? text2Regular(Color? color) {
  return TextStyle(
      color: color ?? AppColors.primarymaincolor,
      fontWeight: FontWeight.w500,
      height: 1.2,
      fontSize: 14.sp);
}
