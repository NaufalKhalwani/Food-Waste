import 'package:flutter/material.dart';

class TColors {
  TColors._();

  // =========================
  // PRIMARY COLORS
  // =========================
  static const Color primary = Color(0xFF0D631B); // hijau button
  static const Color secondary = Color(0xFFE6EAD9); // soft background card
  static const Color accent = Color.fromARGB(
    255,
    243,
    255,
    238,
  ); // aksen hijau lembut

  // =========================
  // GRADIENT
  // =========================
  static const LinearGradient linearGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFFBFCABA), Color(0xFFE6EAD9)],
  );

  // =========================
  // TEXT COLORS
  // =========================
  static const Color textPrimary = Color(0xFF40493D);
  static const Color textSecondary = Color(0xFF7A8473);
  static const Color textWhite = Colors.white;

  // =========================
  // BACKGROUND COLORS
  // =========================
  static const Color light = Color(0xFFBFCABA); // background utama
  static const Color dark = Color(0xFF2E2E2E);
  static const Color primaryBackground = Color(0xFFBFCABA);

  // =========================
  // CONTAINER COLORS
  // =========================
  static const Color lightContainer = Color(0xFFF4F6F0); // card putih kehijauan
  static Color darkContainer = Colors.white.withOpacity(0.1);

  // =========================
  // BUTTON COLORS
  // =========================
  static const Color buttonPrimary = Color(0xFF0D631B);
  static const Color buttonSecondary = Color(0xFF7A8473);
  static const Color buttonDisabled = Color(0xFFC4C4C4);

  // =========================
  // BORDER COLORS
  // =========================
  static const Color borderPrimary = Color(0xFFD6DCCF);
  static const Color borderSecondary = Color(0xFFEDEFE8);

  // =========================
  // STATUS COLORS
  // =========================
  static const Color error = Color(0xFFD32F2F);
  static const Color success = Color(0xFF2E7D32);
  static const Color warning = Color(0xFFFF8F00);
  static const Color info = Color(0xFF1976D2);

  // =========================
  // NEUTRAL
  // =========================
  static const Color black = Color(0xFF232323);
  static const Color white = Color(0xFFFFFFFF);
  static const Color darkerGrey = Color(0xFF4F4F4F);
  static const Color darkGrey = Color(0xFF6D6D6D);
  static const Color grey = Color(0xFFE0E0E0);
}
