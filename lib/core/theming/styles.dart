import 'package:flutter/material.dart';
import 'package:nutri_track/core/theming/colors.dart';
import 'package:nutri_track/core/theming/font_weight_helper.dart';

class AppTextStyles {

    static TextStyle font48Black700 = TextStyle(
    fontSize: 48,
    fontWeight: FontWeightHelper.bold,
    color: Colors.black,
    
  );
   static TextStyle font16green400 = TextStyle(
    fontSize: 16,
    fontWeight: FontWeightHelper.regular,
    color: AppColors.onboardingSmalltxt,
    
  );
  static TextStyle font18green600 = TextStyle(
    fontSize: 18,
    fontWeight: FontWeightHelper.semiBold,
    color: AppColors.primaryGreen,
    
  );
  static TextStyle font18wHITE600 = TextStyle(
    fontSize: 18,
    fontWeight: FontWeightHelper.semiBold,
    color: Colors.white,
    
  );
  


  
}