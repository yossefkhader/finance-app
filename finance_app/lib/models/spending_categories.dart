import 'package:finance_app/theme/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:heroicons/heroicons.dart';

final Map<String, List<dynamic>> spendingCategories = {

  'housingUtilities': ['السكن والخدمات', const Color(0xFF6B7280),HeroIcons.shoppingBag],
  'foodGroceries':['الطعام والمطاعم',AppTheme.accentColor,HeroIcons.buildingStorefront],
  'transport':['المواصلات',const Color(0xFF8B5CF6),HeroIcons.truck],
  'educationChildcare':['التعليم ورعاية الأطفال',const Color(0xFF3B82F6),HeroIcons.academicCap],
  'health':['الرعاية الصحية',const Color(0xFFEC4899),HeroIcons.heart],
  'other':['أخرى',const Color(0xFFF59E0B),HeroIcons.ellipsisHorizontal],
};
