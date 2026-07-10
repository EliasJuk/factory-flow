import 'package:flutter/material.dart';

abstract final class AppColors {
  // Cores principais.
  static const Color primary = Color(0xFF3B82F6);
  static const Color secondary = Color(0xFF14B8A6);

  // Tema escuro.
  static const Color darkBackground = Color(0xFF0F172A);
  static const Color darkSurface = Color(0xFF172033);
  static const Color darkSurfaceVariant = Color(0xFF1E293B);
  static const Color darkBorder = Color(0xFF334155);

  // Tema claro.
  static const Color lightBackground = Color(0xFFF4F6F8);
  static const Color lightSurface = Color(0xFFFFFFFF);
  static const Color lightSurfaceVariant = Color(0xFFEFF2F6);
  static const Color lightBorder = Color(0xFFD8DEE8);

  // Cores de estado.
  static const Color success = Color(0xFF22C55E);
  static const Color warning = Color(0xFFF59E0B);
  static const Color error = Color(0xFFEF4444);
  static const Color info = Color(0xFF0EA5E9);
}