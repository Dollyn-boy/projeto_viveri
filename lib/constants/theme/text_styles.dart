import 'package:flutter/material.dart';
import 'package:viveri/constants/theme/app_colors.dart';

class AppTextStyles {
  static const TextStyle headerTitle = TextStyle(
    fontFamily: 'Roboto',
    fontWeight: FontWeight.w700,
    fontSize: 22,
    color: AppColors.textBody,
  );

  static const TextStyle sectionTitle = TextStyle(
    fontFamily: 'Roboto',
    fontWeight: FontWeight.bold,
    fontSize: 14,
    color: AppColors.textBody,
  );

  static const TextStyle infoLabel = TextStyle(
    fontFamily: 'Roboto',
    fontWeight: FontWeight.bold,
    fontSize: 14,
    color: AppColors.textBody,
  );

  static const TextStyle infoValue = TextStyle(
    fontFamily: 'Roboto',
    fontWeight: FontWeight.w400,
    fontSize: 12,
    color: AppColors.textBody,
    height: 1.3,
  );

  static const TextStyle link = TextStyle(
    fontFamily: 'Roboto',
    fontWeight: FontWeight.w900,
    fontSize: 12,
    color: AppColors.textBody,
  );
}
