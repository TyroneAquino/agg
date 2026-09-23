import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:agg/constants/colors.dart';

class AppTextTheme {
  static final TextStyle mainlogo = GoogleFonts.bangers(
    fontSize: 128, 
    fontWeight: FontWeight.bold, 
    color: AppColors.body
  );

  static final TextStyle screenLogo = GoogleFonts.bangers(
    fontSize: 96, 
    fontWeight: FontWeight.bold, 
    color: AppColors.body
  );

  static final TextStyle headingLarge = GoogleFonts.inter(
    fontSize: 48, 
    fontWeight: FontWeight.bold, 
    color: AppColors.body
  );

  static final TextStyle headingMedium = GoogleFonts.inter(
    fontSize: 32, 
    fontWeight: FontWeight.bold, 
    color: AppColors.body
  );

  static final TextStyle headingSmall = GoogleFonts.inter(
    fontSize: 24, 
    fontWeight: FontWeight.bold, 
    color: AppColors.body
  );

  static final TextStyle bodyLarge = GoogleFonts.inter(
    fontSize: 20, 
    fontWeight: FontWeight.bold, 
    color: AppColors.body
  );

  static final TextStyle bodyText = GoogleFonts.inter(
    fontSize: 16, 
    color: AppColors.body
  );

  static final TextStyle captionText = GoogleFonts.inter(
    fontSize: 12, 
    color: AppColors.body
  );

  static final TextStyle buttonTitle = GoogleFonts.inter(
    fontSize: 24, 
    fontWeight: FontWeight.bold, 
    color: AppColors.body,
    height: 1.1
  );

  static final TextStyle buttonCaption = GoogleFonts.inter(
    fontSize: 16, 
    color: AppColors.body,
    height: 1.1
  );

  static final TextStyle generalButton = GoogleFonts.inter(
    fontSize: 20, 
    color: AppColors.body,
    height: 1.1
  );
  
  static final TextStyle streakText = GoogleFonts.inter(
    fontSize: 20, 
    fontWeight: FontWeight.bold, 
    color: AppColors.flame
  );
  
}